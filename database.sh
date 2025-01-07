

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
    echo "mysql-server is already installed in your server...SKIPPING..."
fi


systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "mysql is enable  :: "

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "mysql is starting  :: "

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "mysql setting up password  :: "