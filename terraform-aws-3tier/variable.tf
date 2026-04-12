variable "region" { default = "us-east-1" }
variable "az1" { default = "us-east-1a" }
variable "az2" { default = "us-east-1b" }

variable "ami" {
  description = "Ubuntu AMI"
}

variable "db_password" {
  sensitive = true
}