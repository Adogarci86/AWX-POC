// Dependency
terraform {
  required_version = "> 0.11.6"
}

// Provider specific configs
provider "aws" {
  version = "~> 1.60.0"
  region     = "${var.aws_region}"
}

// Get the latest base AMI
data "aws_ami" "baseami" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:AMIID"
    values = ["${var.AMIIDQUERY}"]
  }

  most_recent = true
}

// EC2 Instance Resource for Module
resource "aws_instance" "ec2_instance" {
  ami                    = "${var.latest_ami == "true" ? data.aws_ami.baseami.id : var.ami_id}"
  count                  = "${var.number_of_instances}"
  subnet_id              = "${var.subnets[count.index % length(var.subnets)]}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  monitoring             = "${var.monitoring}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  placement_group        = "${var.placement_group}"
  tags                   = "${merge(var.tags,
                               map("NAME", format("%s%02d", var.instance_name, count.index+1)),
                               map("Name", format("%s%02d", var.instance_name, count.index+1)),
                               map("SHORT_HOSTNAME", format("%s%02d", var.short_name, count.index+1)))}"
  volume_tags            = "${merge(var.tags,
                               map("NAME", format("%s%02d", var.instance_name, count.index+1)),
                               map("Name", format("%s%02d", var.instance_name, count.index+1)),
                               map("SHORT_HOSTNAME", format("%s%02d", var.short_name, count.index+1)))}"

  root_block_device = {
    volume_type     = "${var.ebs_volume_type}"
    iops            = "${var.ebs_volume_iops}"
  }

  lifecycle              = {
    ignore_changes = ["ami", "tags", "volume_tags"]
  }

  provisioner "local-exec" {
    when            = "destroy"
    command         = "(sudo su ${var.chef_user} -c \"cd ${var.chef_repo_dir}; echo Y | knife client delete ${format("%s%02d", var.instance_name, count.index+1)} || true\")"
  }
  provisioner "local-exec" {
    when            = "destroy"
    command         = "(sudo su ${var.chef_user} -c \"cd ${var.chef_repo_dir}; echo Y | knife node delete ${format("%s%02d", var.instance_name, count.index+1)} || true\")"
  }
}

// Create ebs volume is enable_encrypted_ebs is set to "true"
resource "aws_ebs_volume" "ebs_volume" {
  count             = "${var.attach_volume == "true" ? var.number_of_instances : 0 }"
  type              = "${var.ebs_volume_type}"
  size              = "${var.ebs_volume_size}"
  iops              = "${var.ebs_volume_iops}"
  kms_key_id        = "${var.enable_encrypted_ebs == "true" ? var.kms_key_id : "" }"
  encrypted         = "${var.enable_encrypted_ebs}"
  availability_zone = "${aws_instance.ec2_instance.*.availability_zone[count.index]}"
  size              = "${var.ebs_volume_size}"

  tags              = "${merge(var.tags,
                               map("NAME", format("%s%02d", var.instance_name, count.index+1)),
                               map("Name", format("%s%02d", var.instance_name, count.index+1)),
                               map("SHORT_HOSTNAME", format("%s%02d", var.short_name, count.index+1)))}"

  lifecycle              = {
    ignore_changes = ["kms_key_id"]
  }
}

// ebs volume attachment is enable_encrypted_ebs is set to "true"
resource "aws_volume_attachment" "ebs_att" {
  count       = "${var.attach_volume == "true" ? var.number_of_instances : 0 }"
  device_name = "${var.ebs_device_name}"
  volume_id   = "${aws_ebs_volume.ebs_volume.*.id[count.index]}"
  instance_id = "${aws_instance.ec2_instance.*.id[count.index]}"
  force_detach      = "true"

  // References in future changes:
  // https://unix.stackexchange.com/questions/15024/umount-device-is-busy-why
  // http://oletange.blogspot.com/2012/04/umount-device-is-busy-why.html
  provisioner "remote-exec" {
    when   = "destroy"
    inline = [
      "${var.AMIIDQUERY == "BASEAMIRHEL7" ? "sudo systemctl stop sensu-client" : "sudo service sensu-client stop"}",
      "/usr/local/bin/consul leave",
      "${format("sudo swapoff %s/swapfile", var.ebs_mount_point)}",
      "${format("sudo umount %s -l || true", var.ebs_mount_point)}",
      "${format("sudo umount %s -l || true", var.efs_mount_location)}"
    ]
  }

  connection {
    type = "ssh"
    user = "${var.ec2_user}"
    host = "${aws_instance.ec2_instance.*.private_ip[count.index]}"
    private_key = "${file("${var.user_key}")}"
  }
}

resource "null_resource" "post_bootstrap" {
  count = "${var.attach_volume == "true" ? var.number_of_instances : 0 }"
  depends_on = ["aws_volume_attachment.ebs_att"]

  provisioner "local-exec" {
    command     = <<EOT
      timeout=60
      while [[ `aws ec2 describe-instances --instance-id ${aws_instance.ec2_instance.*.id[count.index]} --query 'Reservations[0].Instances[0].State.Code'` -ne 16 && timeout -ne 0 ]]
      do
        aws ec2 start-instances --instance-ids ${aws_instance.ec2_instance.*.id[count.index]}
        timeout=$(( timeout-10 ))
        sleep 10
      done
    EOT
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install nfs-utils",
      "echo 'Installed NFS Utils'>>/tmp/init.log",
      "sudo mkdir /tempfiles",
      "${format("sudo cp -r %s/* /tempfiles/", var.ebs_mount_point)}",
      "${format("sudo mkdir -p %s", var.ebs_mount_point)}",
      "${format("sudo mkfs.ext4 %s", replace(var.ebs_device_name, "sd", "xvd"))}",
      "${format("sudo mount -t ext4 %s %s", replace(var.ebs_device_name, "sd", "xvd"), var.ebs_mount_point)}",
      "${format("sudo mv /tempfiles/* %s/", var.ebs_mount_point)}",
      "sudo rmdir /tempfiles",
      "${format("echo \"%s %s ext4 defaults 0 0\" | sudo tee --append /etc/fstab", replace(var.ebs_device_name, "sd", "xvd"), var.ebs_mount_point)}"
    ]
  }

  // Misc: create route#53 record, change to US/Eastern, create tomcat user...
  provisioner "remote-exec" {
    inline = [
      "if [[ ! -d /home/${var.ebs_mount_point_ics_user} ]]; then",
      "sudo mkdir -p /home/${var.ebs_mount_point_ics_user}",
      "sudo groupadd -g 502 ${var.ebs_mount_point_ics_user}",
      "sudo useradd -u 502 -g 502 -d /home/${var.ebs_mount_point_ics_user} ${var.ebs_mount_point_ics_user}",
      "sudo chown ${var.ebs_mount_point_ics_user}:${var.ebs_mount_point_ics_user} /home/${var.ebs_mount_point_ics_user}",
      "fi",
      "sudo ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime",
      "sudo mkdir -p /home/tomcat",
      "sudo groupadd tomcat",
      "sudo useradd tomcat -g tomcat -d /home/tomcat",
      "sudo chown tomcat:tomcat /home/tomcat",
      "sudo mkdir -p /home/kafka",
      "sudo groupadd kafka",
      "sudo useradd kafka -g kafka -d /home/kafka",
      "sudo chown kafka:kafka /home/kafka",
      "sudo rm /etc/haproxy/00-haproxy.cfg",
      "echo 'consul ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers",
      "if [[ ! -d /home/${var.ebs_mount_point_ics_user} ]]; then",
      "${format("echo '%s ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers", var.ebs_mount_point_ics_user)}",
      "fi",
      "sudo yum remove mariadb-libs -y",
      "sudo yum install mysql -y"
    ]
  }

  // Mount EFS Instance
  provisioner "remote-exec" {
    inline = [
      "if [[ ${var.mount_efs} == \"true\" ]]; then",
      "sudo mkdir -p ${var.efs_mount_location}; echo \"${var.efs_ip_address}:/ ${var.efs_mount_location} nfs defaults,vers=4.1,nosuid 0 0\" | sudo tee --append /etc/fstab;",
      "sudo mkdir -p /opt/local_upload",
      "sudo chown tomcat:tomcat /opt/local_upload",
      "sudo mount ${var.efs_mount_location}",
      "sudo chown tomcat:tomcat ${var.efs_mount_location}",
      "fi"
    ]
  }

  // Add swap memory
  provisioner "remote-exec" {
    inline = [
      "${format("sudo fallocate -l %sG %s/swapfile", var.swap_memory, var.ebs_mount_point)}",
      "${format("sudo chmod 0600 %s/swapfile", var.ebs_mount_point)}",
      "${format("sudo mkswap %s/swapfile", var.ebs_mount_point)}",
      "${format("sudo swapon %s/swapfile", var.ebs_mount_point)}",
      "${format("echo '%s/swapfile swap swap defaults 0 0' | sudo tee --append /etc/fstab", var.ebs_mount_point)}"
   ]
  }

  // Bootstrapping Chef client
  provisioner "local-exec" {
    command = "sudo su ${var.chef_user} -c \"cd ${var.chef_repo_dir}; knife bootstrap ${aws_instance.ec2_instance.*.private_ip[count.index]} -i ${var.user_key} --ssh-user ${var.ec2_user} --sudo -E ${format("%s", var.chef_env_name)} -N ${format("%s%02d", var.instance_name, count.index+1)}\""
  }

provisioner "remote-exec" {
    inline = [
      "sudo true && curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -v ${var.chef_version}"
    ]
  }

  connection {
    type = "ssh"
    user = "${var.ec2_user}"
    host = "${aws_instance.ec2_instance.*.private_ip[count.index]}"
    private_key = "${file("${var.user_key}")}"
  }
}
