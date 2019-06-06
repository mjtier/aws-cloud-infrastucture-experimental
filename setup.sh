#!/usr/bin/env bash

mkdir -p /home/ec2-user/backup_db

FILE=/home/ec2-user/import_db/cache.db

# warm the db
mkdir -p /home/ec2-user/import_db
aws s3 cp  s3://mjtier.development.terraform.provisioning/cache.db $FILE

# if the cahced db from the s3 bucket was copied, this is not the first time
# that the infastructure was provisioned by terraform

if [ -f "$FILE" ]; then
    echo "$FILE exist"
    sqlite3 .read $FILE
fi



# setup cron job to run every 5 minutes to export the database
mkdir -p  /home/ec2/backup_db
# grab the export script from an s3 bucket
aws s3 cp  s3://mjtier.development.terraform.provisioning/exportdb.sh /home/ec2-user/exportdb.sh
chmod a+x /home/ec2-user/exportdb.sh

echo "$(echo '*/5 * * * * /home/ec2-user/exportdb.sh' ; crontab -l)" | crontab -