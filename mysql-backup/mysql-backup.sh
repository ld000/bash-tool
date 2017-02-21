#!/usr/bin/env bash

#####################################################################
#
# Mysql backup script
#
#
# author   : lidong9144@163.com
# version  : 0.0.1
#
#####################################################################

USER=bkpuser
PASSWORD=bkppassword
DATA_DIR=/var/lib/mysql/
FULL_DIR=/home/kmxnode7/backup/full
TARGET_DIR=$FULL_DIR/`date +%Y-%m-%d_%H%M`
BACKUP_KEEP_NUM=3

usage() {
  cat <<-EOF
    Mysql backup.Depends on xtrabackup.

    options:
      -h show help
      -b backup, either incremental or full, "-b inc" or "-b full"
      -r restore, format:%Y-%m-%d_%H%M, "-r 2017-01-01_1101" or "-r latest"
      
EOF
  exit 1
}

[[ -z "$1" ]] && { usage; }

set -u


full_backup() {
  echo "Mysql full backup..."

  innobackupex \
    --parallel=5 \
    --compress \
    --compress-threads=5 \
    --user=$USER \
    --password=$PASSWORD \
    --no-timestamp \
    $TARGET_DIR

  echo "check if backup successfully"

  if [ "${PIPESTATUS[0]}" -ne 0 ]; then 
    echo "Mysql backup failed!" 
  
    if [ -z $TARGET_DIR ]; then
      rm -rf $TARGET_DIR
    fi

    exit 1
  fi

  echo "backup success."
  echo "delete out of date backup... (keep_num: $BACKUP_KEEP_NUM)"

  cd $FULL_DIR
  dir_num=`ls -l | grep -c ^d`
  if [ $dir_num -gt $BACKUP_KEEP_NUM ]; then
    del_num=$[$dir_num-$BACKUP_KEEP_NUM]

    ls -t | tail -n $del_num | xargs rm -rf
  fi
}

restore() {
  if [ "$OPTARG" -e "latest" ]; then
    dir=`ls -t $FULL_DIR | tail -n 1`
  else
    dir=$OPTARG
  fi

  echo "prepareing full backup..."
  innobackupex \
    --parallel=5 \
    --apply-log \
    $FULL_DIR/$dir
  
  echo "stop mysql..."
  service mysql stop

  echo "restore data file..."
  innobackupex \
    --copy-back \
 #   --include="^lingong\." \
    $FULL_DIR/$dir

  echo "start mysql..."
  service mysql start
}

while getopts "hb:r:" option
do
  case $option in
    h)
      usage
    ;;
    b)
      b_type=$OPTARG
      if [[ "$b_type" == "full" ]]; then
        full_backup
      elif [[ "$b_type" == "inc" ]]; then
        echo inc 
      fi
    ;;
    r)
      restore
    ;;
  esac
done
