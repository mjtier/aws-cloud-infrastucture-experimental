#!/usr/bin/env bash

# warm the db
mkdir -p /home/ec2-user/import_db
aws s3 cp  s3://mjtier.development.terraform.backup/cache.db /home/ec2-user/cahce.db

# if the cahced db from the s3 bucket was copied, this is not the first time
# that the infastructure was provisioned by terraform

FILE=/tmp/import_db/cache.db
if [ -f "$FILE" ]; then
    echo "$FILE exist"
    sqlite3 .read $FILE
fi
# setup cron job to run every 5 minutes to export the database
mkdir -p  /tmp/backup_db
# grab the export script from an s3 bucket
aws s3 cp  s3://mjtier.development.terraform.provisioning/exportdb.sh /home/ec2-user/exportdb.sh
chmod a+x /home/ec2-user/exportdb.sh
crontab -e */5 * * * * /tmp/exportdb.sh