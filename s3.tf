resource "aws_s3_bucket" "cofig_bucket" {
    bucket = "mjtier.development.terraform.provisioning"
    acl    = "private"
    versioning {
      enabled = true
    }
}

