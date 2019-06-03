resource "aws_s3_bucket" "bucket" {
  bucket = "sqlite3-db"
  acl = "private"
  versioning {
    enabled = true
  }

  tags = {
    Name = "SQLite DB Backup Bucket"
  }
}