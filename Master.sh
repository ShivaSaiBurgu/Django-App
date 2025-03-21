#!/bin/bash
USER=$(id -u)
if [ $USER -ne 0 ]
then
echo "Please run the script with root access"
exit 1
else
echo "You are a root user"
fi
time=$(date +%F-%H-%M-%S)
script=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$time-$script.log
VALIDATE() {
    if [ $1 -ne 0 ]
    then
    echo "$2....Failure"
    exit 1
    else
    echo "$2...success"
    fi
}
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
 https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key &>>$LOGFILE
VALIDATE $? "Downloading libraries" 
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null &>>$LOGFILE
 VALIDATE $? "echoing"
  sudo apt-get update &>>$LOGFILE
VALIDATE $? "updating packages"
  sudo apt-get install jenkins &>>$LOGFILE
   VALIDATE $? "Installing Jenkins"
  sudo apt update &>>$LOGFILE
 VALIDATE $? "updating packages"
  sudo apt install fontconfig openjdk-17-jre &>>$LOGFILE
   VALIDATE $? "Installing Java"
  java -version
  sudo systemctl enable jenkins &>>$LOGFILE
   VALIDATE $? "enabling jenkins"
  sudo systemctl start jenkins &>>$LOGFILE
   VALIDATE $? "starting jenkins"
  sudo systemctl status jenkins