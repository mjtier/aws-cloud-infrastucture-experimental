variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "aws_region" {
  default = "us-east-1"
  description = "AWS Region where module should operate"
}
variable "ami_id" {
  default = "ami-04a3d424ed14a1996"
  description = "The AMI to use in the Auto Scaling group"
}

variable "key_name" {
  default = "mykey"
}

variable "public_key" {
  default = "mykey.pub"
}
variable "private_key" {
  default = "~/.ssh/id_rsa"
}
