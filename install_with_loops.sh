#!/bin/bash

LOGS_FOLDER="/var/log/shell_scripting_vra"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"

mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


CHECK_ROOT(){
if [ USERID -ne 0 ]
then
    echo -e "$R Use ROOT previlages to installations $N" &>>LOG_FILE
    exit 1
fi
}

VALIDATE(){
if [ $1 -ne 0]
then 
    echo -e "$2 is $R FAILED $N" &>>LOG_FILE
    exit 1
else
    echo -e "$2 is $G SUCCESS... $N" &>>LOG_FILE
fi
}

CHECK_ROOT

for package in $@
do 
    echo $package
    dnf list installed $package
    if [ $? -ne 0 ]
    then
        echo -e "$package is not installed, going to $G install $N" &>>LOG_FILE
        dnf install $package -y
        VALIDATE $? "Installing $package"
    else
        echo -e "$package $G already installed... $N Nothing to do" &>>LOG_FILE
    fi
done
