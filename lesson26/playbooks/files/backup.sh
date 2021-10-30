#!/usr/bin/env bash

LOCKFILE=/tmp/lockfile
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "already running"
    exit
fi

LOG="/var/log/backup.log"

# Make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# Configure backup

BACKUP_HOST='192.168.10.10'
BACKUP_USER='borg'
BACKUP_REPO='/var/backup/client-etc'
export BORG_RSH="ssh  -o StrictHostKeyChecking=no  -i /root/.ssh/id_rsa"
export BORG_PASSPHRASE='123'

echo $BACKUP_REPO > $LOG

# Make backup
borg create \
  --stats --progress \
  ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO}::"etc-{now:%Y-%m-%d_%H-%M}" \
  /etc 2>>$LOG


# Prune backup
borg prune \
  -v --list \
  ${BACKUP_USER}@${BACKUP_HOST}:${BACKUP_REPO} \
  --keep-daily 93 \
  --keep-monthly 12 2>>$LOG

# Delete lockfile
rm -f ${LOCKFILE}
