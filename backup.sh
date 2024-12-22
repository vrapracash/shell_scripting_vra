#!/bin/bash
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=$3
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USAGE(){
    echo -e "$R USAGE:: $N sh backup.sh <source> <destination> <days(optional)>"
}
#check the source and destination are provided

if [ $# -lt 2 ]
then
    USAGE
    exit 1
fi

if [ ! -d $SOURCE_DIR ]
then
    echo "$SOURCE_DIR does not exists... Please check directory path"
fi

if [! -d $DEST_DIR ]
then
    echo "$DEST_DIR does not exists... Please check directory path"
fi

FILES=$(find ${SOURCE_DIR} -name "*.log" -mtime +$DAYS)

echo "Files: $FILES"

if [ ! -z $FILES ] # -z finds if folder is empty, ! is not command
then
    echo = "Files are found"
    ZIP_FILE="$DEST_DIR/app-logs-$TIME_STAMP.zip"
    find ${SOURCE_DIR} -name "*.log" -mtime $DAYS | zip "$ZIP_FILE" -@

    #chek if zip operation is successfull
    if [ -f $ZIP_FILE ]
    then
        echo "Successfully zipped files older than $DAYS"
        #remove the files after zipping
        while IFS= read -r file #internal filed separator
        do
            echo "Deleting files: $FILEs"
            rm -rf $FILES
        done <<< $FILES
    else
        echo -e "$R Zipping failed $N"
        exit 1
    fi
else
    echo -e "$R No files older then $DAYS $N"
fi
