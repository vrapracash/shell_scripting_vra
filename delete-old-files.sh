#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SOURCE_DIR= /home/ec2-user/logs/

if [ -d $SOURCE_DIR ]
then
    echo "$SOURCE_DIR found"
else
    echo "$SOURCE_DIR not found"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +14)
echo "files:$FILES"

while IFS= read -r line #IFS is Internal filed separator, empty it will ignore while space, -r is for not to igonre special characters
do
    echo "Deleting line: $line"
    rm -rf $line
done <<< $FILES