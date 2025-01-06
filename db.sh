R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log



if [ $USERID -ne 0 ]
then   
    echo -e $R "Please Provide ROOT access.." $N  &>>$LOGFILE
    exit 2
else    
    echo -e $Y"You Have already SUDO access..."$N &>>$LOGFILE
fi


VALIDATE()
{
    if [ $1 -ne 0 ]
    then 
        echo -e $R "$2 FAILURE..." $N &>>$LOGFILE 
    else
        echo -e $G "$2 SUCCESS..." $N &>>$LOGFILE
    fi
}

dnf list install mysql-server
if [ $? -ne 0 ]
then    
    dnf install mysql-server -y
    VALIDATE $? "Installtion of mysql :" &>>$LOGFILE
else
    echo -e $G "mysql server is installed already..." $N &>>$LOGFILE
fi

systemctl enable mysqld 
VALIDATE $? "mysql  enable :" &>>$LOGFILE

systemctl start mysqld
VALIDATE $? "mysql  starting :" &>>$LOGFILE

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "mysql password setup :" &>>$LOGFILE