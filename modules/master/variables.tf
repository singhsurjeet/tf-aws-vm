variable "environment" {}

variable "product" {
  default = "kismatic"
}

variable "region" {}

variable "vpc_id" {}

variable "key_name" {}

variable "allowed_cidr" {
  type        = "list"
  default     = ["0.0.0.0/0"]
  description = "A list of CIDR Networks to allow ssh access to."
}

variable "allowed_ipv6_cidr" {
  type        = "list"
  default     = ["::/0"]
  description = "A list of IPv6 CIDR Networks to allow ssh access to."
}

variable "ami" {}

variable "instance_type" {}

variable "iam_instance_profile_master" {}

variable "associate_public_ip_address" {
  default = true
}

variable "public_subnet_id" {
  #type    = "list"
  #default = []
}

variable "component" {}

variable "desired" {}

variable "min" {}
variable "max" {}