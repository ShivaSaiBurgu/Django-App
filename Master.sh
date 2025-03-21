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
validate() {
    if [ $1 -ne 0 ]
    then
    echo "$2....Failure"
    exit 1
    else
    echo "$1...success"
    fi
}
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
 https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key &>>$LOGFILE
validate $? "Downloading libraries" 
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null &>>$LOGFILE
  validate $? "echoing"
  sudo apt-get update &>>$LOGFILE
   validate $? "updating packages"
  sudo apt-get install jenkins &>>$LOGFILE
   validate $? "Installing Jenkins"
  sudo apt update &>>$LOGFILE
  validate $? "updating packages"
  sudo apt install fontconfig openjdk-17-jre &>>$LOGFILE
   validate $? "Installing Java"
  java -version
  sudo systemctl enable jenkins &>>$LOGFILE
   validate $? "enabling jenkins"
  sudo systemctl start jenkins &>>$LOGFILE
   validate $? "starting jenkins"
  sudo systemctl status jenkins