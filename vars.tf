variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
  description = "AWS Region where module should operate)"
}
variable "AMI_ID" {
  default = "ami-04a3d424ed14a1996"
  description = "The AMI to use in the Auto Scaling group"
}
