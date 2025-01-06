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
    echo -e $R "Please Provide ROOT access.." $N  
    exit 2
else    
    echo -e $Y "You Have already SUDO access..." $N 
fi


VALIDATE()
{
    if [ $1 -ne 0 ]
    then 
        echo -e $R "$2 FAILURE..." $N 
    else
        echo -e $G "$2 SUCCESS..." $N
    fi
}

dnf list installed mysql-server
if [ $? -ne 0 ]
then    
    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "Installtion of mysql :" 
else
    echo -e $G "mysql server is installed already..." $N 
fi

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "mysql  enable :" 

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "mysql  starting :" 

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "mysql password setup :" 