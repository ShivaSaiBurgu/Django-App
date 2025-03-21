#!/bin/bash
time=$(date +%F-%H-%M-%S)
script=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$time-$script.log
validate() {
    if [ $1 -ne 0]
    then
    echo "$2....Failure"
    else
    echo "$1...success"
}
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
 https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
validate $? "Downloading libraries"
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
  validate $? "echoing"
  sudo apt-get update
   validate $? "updating packages"
  sudo apt-get install jenkins
   validate $? "Installing Jenkins"
  sudo apt update
  validate $? "updating packages"
  sudo apt install fontconfig openjdk-17-jre
   validate $? "Installing Java"
  java -version
  sudo systemctl enable jenkins
   validate $? "enabling jenkins"
  sudo systemctl start jenkins
   validate $? "starting jenkins"
  sudo systemctl status jenkins