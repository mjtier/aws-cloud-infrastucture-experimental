resource "aws_s3_bucket" "bucket" {
  bucket = "sqlite3-db"
  acl = "private"
  region = "${var.aws_region}"
  versioning {
    enabled = true
  }

  tags = {
    Name = "SQLite DB Backup Bucket"
  }
}