#!/usr/bin/env bash

# Set this working directory to the directory on your EC2 instance
# were you would like to work out of
WORKING_DIR = /home/ec2-user

mkdir -p $WORKING_DIR/backup_db
mkdir -p $WORKING_DIR/import_db

IMPORT_FILE=$WORKING_DIRr/import_db/cache.db
EXPORT_FILE=$WORKING_DIR/backup_db/cache.db

# Attempt to copy an existing backup
aws s3 cp  s3://mjtier.development.terraform.provisioning/cache.db $IMPORT_FILE

# if the cahced db from the s3 bucket was copied, this is not the first time
# that the infastructure was provisioned by terraform

if [ -f "$IMPORT_FILE" ]; then
    echo "$IMPORT_FILE exist"
    sqlite3 .read $IMPORT_FILE
fi

# We have read teh import file, so now we can delete it
rm -rf $IMPORT_FILE

# grab the export script from an s3 bucket
aws s3 cp  s3://mjtier.development.terraform.provisioning/exportdb.sh $WORKING_DIR/exportdb.sh
chmod a+x $WORKING_DIR/exportdb.sh
# setup cron job to run every 5 minutes to export the database
echo "$(echo '*/5 * * * * /home/ec2-user/exportdb.sh' ; crontab -l)" | crontab -