#!/usr/bin/env bash

# clean up old backup
rm -rf /home/ec2-user/backup_db/cache.db
# export the database into the temp directory
sqlite3 cache.db .dump > /home/ec2-user/backup_db/cache.db
#copy the new backup to the s3 bucket
aws s3 cp /home/ec2-user/backup_db/cache.db s3://mjtier.development.terraform.provisioning/cache.db
