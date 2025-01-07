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


dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx :: "

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx :: "

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting of nginx :: "

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing default frontend content of nginx ::"


curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading the frontend.zip file in /tmp directory :: "


cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? "We moved to default content of nginx frontend :: "


unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Unzipping the frontend service in /tmp folder :: "


# vim /etc/nginx/default.d/expense.conf &>>$LOGFILE
# VALIDATE $? "Copy the file absolute path to nginx default path::"


#check your repo and path expense.conf
cp /home/ec2-user/expense-shell-new/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
# VALIDATE $? "Copy the file absolute path to nginx expense.conf path::"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting the nginx service :: "

