#!/usr/bin/env bash

# clean up old backup
rm -rf /tmp/backup_db/cache.db
# export the database into the temp directory
sqlite3 cache.db .dump > /tmp/backup_db/cache.db
#copy the new backup to the s3 bucket
aws s3 cp /tmp/backup_db/cache.db s3://mjtier.development.terraform.backup/cache.db
