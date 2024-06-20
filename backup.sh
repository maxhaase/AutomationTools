#!/bin/bash
# AUTHOR: maxhaase@gmail.com
# DESCRIPTION: Backsup important files on your computer in a folder, preferebly an external device mounted 
# Yous should add it to crontab so it executes regularly 

# Define backup and source directories
BACKUP_DIR="/SPACE/BACKUP" # This is where your backup files will be stored
SOURCE_DIR="/"
EXCLUDE_DIRS="--exclude=/proc --exclude=/tmp --exclude=/mnt --exclude=/dev --exclude=/sys --exclude=/run --exclude=$BACKUP_DIR"

# Date and time format for backup filename
DATE_FMT=$(date +"%A_%B_%d_%Y_02-00")
BACKUP_FILE="$BACKUP_DIR/backup_$DATE_FMT_.tar.gz"

# Start time
START_TIME=$(date +%s)

# Perform backup
tar -cpzf $BACKUP_FILE $EXCLUDE_DIRS $SOURCE_DIR --warning=no-file-changed

# End time and calculate duration
END_TIME=$(date +%s)
DURATION=$((($END_TIME - $START_TIME)/60))

# Email the result to root
echo "Backup completed in $DURATION minutes." | mail -s "Backup Duration" root

# Clean up older backups, retaining at least the last 10 backups
(cd $BACKUP_DIR && ls -t | grep 'backup' | tail -n +11 | head -n -10 | xargs -d '\n' rm --)

# Ensure at least the last 10 backups are retained
NUM_BACKUPS=$(ls -1 $BACKUP_DIR/backup_*.tar.gz | wc -l)
if [ $NUM_BACKUPS -gt 10 ]; then
    OLDEST_ALLOWED_DATE=$(date -d "15 days ago" +%s)
    for backup in $(ls -tr $BACKUP_DIR/backup_*.tar.gz); do
        # Check if there are more than 10 backups
        NUM_BACKUPS=$(ls -1 $BACKUP_DIR/backup_*.tar.gz | wc -l)
        if [ $NUM_BACKUPS -le 10 ]; then
            break
        fi
        BACKUP_DATE=$(echo $backup | sed -r 's/.*backup_(.*)_.tar.gz/\1/' | xargs -I {} date -d {} +%s)
        if [ $BACKUP_DATE -lt $OLDEST_ALLOWED_DATE ]; then
            rm $backup
        fi
    done
fi
