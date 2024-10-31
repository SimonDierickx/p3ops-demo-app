#!/bin/bash

# 1. Repository klonen
echo -e "\033[1;34mStap 1: Repository klonen\033[0m"
sudo dnf install git -y
git config --global user.name "SimonDierickx"
git config --global user.email "simon.dierickx@student.hogent.be"
git clone https://github.com/SimonDierickx/p3ops-demo-app.git

# 2. Docker installeren
echo -e "\033[1;34mStap 6: Docker installeren\033[0m"
sudo dnf install yum-utils -y
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# 3. Docker starten en inschakelen
echo -e "\033[1;34mStap 3: Docker starten en inschakelen\033[0m"
sudo systemctl start docker
sudo systemctl enable docker

# 4. Jenkins installeren
echo -e "\033[1;34mStap 4: Jenkins installeren\033[0m"
sudo docker pull jenkins/jenkins:lts

# 5. Jenkins wachtwoord ophalen en weergeven
echo -e "\033[1;34mHet Jenkins wachtwoord is:\033[0m"
jenkins_password=$(sudo docker exec jenkins_server cat /var/jenkins_home/secrets/initialAdminPassword)
#79458596710c4eb1ba32f3a68571d6ce
echo -e "\033[1;33m$jenkins_password\033[0m"
