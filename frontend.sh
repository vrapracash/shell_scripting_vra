#!/bin/bash

LOGS_FOLDER="/var/log/shell_scripting_vra"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"

mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Use ROOT previlages to installations $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is $R FAILED $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is $G SUCCESS... $N" | tee -a $LOG_FILE
    fi
}

CHECK_ROOT

for package in $@
do 
    echo $package
    dnf list installed $package
    if [ $? -ne 0 ]
    then
        echo -e "$G $package is not installed, going to install $N" | tee -a $LOG_FILE
        dnf install $package -y
        VALIDATE $? "Installing $package" | tee -a $LOG_FILE
    else
        echo -e "$G $package already installed... $N Nothing to do" | tee -a $LOG_FILE
    fi
done

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing Nginix"

systemctl start nginx
VALIDATE $? "Start NGINX"

systemctl enable nginx
VALIDATE $? "Enable NGINX"

#remove default website
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing default website"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATE $? "Download Build file"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "Unzipping Build folder"

cp /home/ec2-user/shell_scripting_vra/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE
VALIDATE $? "Copying configuration file"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "Restarting NGINX"