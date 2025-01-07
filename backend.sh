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


dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling previous version of nodejs ::"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling present version of nodejs ::"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installind nodejs ::"

# #This useradd is not idempotent nature, we got error if you run multiple times 
# useradd expense &>>$LOGFILE  
# VALIDATE $? "Creating user as expense ::"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
else
    echo -e "Expense user already created...$Y SKIPPING $N"
fi


# Here -p is if /app directory is exit then it is skipping otherwise it is creating /app
mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory ::"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading zip file in your tmp directory ::"


cd /app &>>$LOGFILE
#VALIDATE $? "Moving to /app folder ::"
rm -rf /app/*  # here /* is removing all content inside of /app folder


unzip /tmp/backend.zip &>>$LOGFILE #This unzipping is not idempotent nature, we got error if you run multiple times 
VALIDATE $? "Unzipping backend.zip file in /tmp directory ::"


npm install &>>$LOGFILE
VALIDATE $? "Installind supporting nodejs packages/nodejs dependencies to our servise ::"


# Here we need to mention backend.service absolute path to avoid errors
# we copied absolute path of backend.service into /etc/systemd/system/backend.service
# To get systemctl services like start stop enable disables checkind status ..etc
cp /home/ec2-user/expense-shell-new/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Deamon reloading ::"
 
systemctl start backend &>>$LOGFILE
VALIDATE $? "Stariting Backend  ::"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling Backend ::"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing Client mysql software ::"


# mysql -h db.happywithyogamoney.fun -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOGFILE
# VALIDATE $? "Connectioin creation from backend to frontend while setting password Schema loading ::"

mysql -h db.happywithyogamoney.fun -uroot -p${DB_Password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Connectioin creation from backend to frontend while setting password Schema loading ::"


systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting the backend application ::"


