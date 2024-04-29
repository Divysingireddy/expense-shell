#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
    echo -e "$2.....$R FAILURE $N"
    else
    echo -e "$2......$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
echo "Please run this script with root access"
exit 1
else
echo "You are a super user"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installation of Mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MYSQL"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.divaws78s.online -uroot -pExpenseApp@1 -e 'show databases;' &>>LOGFILE
if [ $? -ne 0 ]
then 
Mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "MYSQL Root password setup"
else
echo -e "MySQL root password is already setup..$Y SKIPPING $N"
fi