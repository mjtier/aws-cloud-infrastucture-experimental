#!/usr/bin/env bash
mkdir -p  /tmp/backup_db
aws s3 cp  s3://mjtier.development.terraform.provisioning/exportdb.sh
aws s3 cp  s3://mjtier.development.terraform.provisioning/importdb.sh
