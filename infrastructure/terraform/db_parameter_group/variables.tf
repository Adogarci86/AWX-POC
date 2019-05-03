variable "aws_region" {}

variable "name" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "tags" {
  type = "map"
}

variable "db_parameters" {
type = "list"
default = [
{
    name  = "character_set_client"
    value = "utf8"
},

{
    name  = "character_set_connection"
    value = "utf8"
},

{
    name  = "character_set_database"
    value = "utf8"
}
]
}
