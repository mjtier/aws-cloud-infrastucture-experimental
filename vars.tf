variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS Region where module should operate"
}

variable "ami_id" {
  default     = "ami-04a3d424ed14a1996"
  description = "The AMI to use in the Auto Scaling group"
}

variable "key_name" {
  type    = string
  default = "ec2_key"
}

variable "availability_zones" {
  description = "AZ to be used for iCAN"
  default     = "us-east-1a"
}

variable "my_bucket_name" {
  type    = string
  default = "mjtier.development.terraform.provisioning"
}

