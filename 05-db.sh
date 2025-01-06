

#!/bin/bash/

# where ever we are getting failure manually we provide the exit

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "Please provide the SUDO ACCESS"
    # if it is not a super user we need to break
    exit 1 # Here you need to mention 1 to 127 upto
    # in suppose you mentioned exit 0 it is considered as success,
    # exit 0 is continue the srcipt
else
    echo "You are a SUPER USER"

fi

dnf install mysql-server -y   #Here -y is mandatory


if [ $? -ne 0 ]
then 
     echo "Your installation is FAILED"  
    exit 1
else
   
    echo "Your installation is SUCCESS"
fi


dnf install git

if [ $? -ne 0 ]
then 
    echo "Your Installaion was FAILED"
    exit 1
else
    echo "Your Installaion was SUCCESS"

fi

echo "script is Proceeding...ThankYou"
