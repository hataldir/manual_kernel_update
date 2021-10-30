#!/usr/bin/env bash
BORG_PASSPHRASE='123' borg init --encryption=repokey-blake2 /var/backup/client-etc
