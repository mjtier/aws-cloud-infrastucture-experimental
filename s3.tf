resource "aws_s3_bucket" "sqlite3-db-bucket" {
  bucket = "sqlite3-db-bucket"
  acl = "private"
  region = "${var.aws_region}"
  versioning {
    enabled = true
  }

  tags = {
    Name = "SQLite DB Backup Bucket"
  }
}