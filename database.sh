

echo "Please Enter Your DataBase Password ::"
read -s DB_Password

USERID=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo -e $Y"Please Run This Script with ROOT access..."$N
    exit 2
else
    echo -e $G"You Have Already SUDO access.."$N
fi


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e $R"$2 FAILURE.."$N
        exit 2
    else
        echo -e $G "$2 SUCCESS.." $N
    fi
}


dnf list installed mysql-server &>>$LOGFILE
if [ $? -ne 0 ]
then
    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "mysql is installing  :: "
else
    echo  -e $Y "mysql-server is already installed in your server...SKIPPING..." $N
fi


systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "mysql is enable  :: "

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "mysql is starting  :: "


#--------------------------------------------------------------
# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "mysql setting up password  :: "
#--------------------------------------------------------------


# #--------------------------------------------------------------
# mysql -h db.happywithyogamoney.fun -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
# if [ $? -ne 0 ]
# then
#     mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#     VALIDATE $? "mysql setting up password  ::"
# else
#     echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
# fi
# #--------------------------------------------------------------



#---------------------HIDDING PASSWORD (pExpenseApp@1)---------------------------
mysql -h db.happywithyogamoney.fun -uroot -p${DB_Password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${DB_Password} &>>$LOGFILE
    VALIDATE $? "mysql setting up password  ::"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi
#---------------------------------------------------------------------------------



#--------------------------------------------------------------
# #Below code will be useful for idempotent nature
# mysql -h db.daws78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
# if [ $? -ne 0 ]
# then
#     mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
#     VALIDATE $? "MySQL Root password Setup"
# else
#     echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
# fi

#--------------------------------------------------------------