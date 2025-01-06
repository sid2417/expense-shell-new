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
    echo -e $G"You Have already SUDO access..."$N
fi


VALIDATE()
{
    if [ $1 -ne 0 ]
    then 
        echo "$2 FAILURE..."
    else
        echo "$2 SUCCESS..."
    fi
}

dnf list install mysql-server
if [ $? -ne 0 ]
then    
    dnf install mysql-server -y
    VALIDATE $? "Installtion of mysql :"
else
    echo "mysql server is installed already..."
fi

systemctl enable mysqld 
VALIDATE $? "mysql  enable :"

systemctl start mysqld
VALIDATE $? "mysql  starting :"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "mysql password setup :"