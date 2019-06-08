#!/usr/bin/env bash

WORKING_DIR = /home/ec2-user
EXPORT_FILE=$WORKING_DIR/backup_db/cache.db
BUCKET = mjtier.development.terraform.provisioning

# clean up old backup
rm -rf $EXPORT_FILE/cache.db
# export the database into the temp directory
sqlite3 cache.db .dump > $EXPORT_FILE/cache.db
# copy the new backup to the s3 bucket
# TODO add a method to use a user specified bucket name
aws s3 cp $EXPORT_FILE/cache.db s3:/$BUCKET/cache.db
