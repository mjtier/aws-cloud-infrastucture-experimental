#!/usr/bin/env bash
mkdir -p  /tmp/backup_db
sqlite3 cache.db .dump > /tmp/backup_db/cache.db
aws s3 cp /tmp/backup_db/cache.db s3://merlot.cshome/LinuxAgent 
ß