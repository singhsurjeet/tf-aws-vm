#####---  VPC Infrastructure Variables ---######

variable "cidr_block" {}
variable "product" {
  default = "kismatic"
}
variable "environment" {}
variable "region" {}

variable "availability_zones" {
  type    = "list"
  default = []
}

variable "public_subnet_cidr" {
  type    = "list"
  default = []
}

//variable "private_subnet_cidr" {
//  type    = "list"
//  default = []
//}