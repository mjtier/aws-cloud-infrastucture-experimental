# Create a bucket to store our configuration state for new
# instances in

resource "aws_s3_bucket" "config_bucket" {
    bucket = "mjtier.development.terraform.provisioning"
    acl    = "private"
    versioning {
      enabled = true
    }
}

