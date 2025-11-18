#!/bin/bash

echo "===== Updating system ====="
sudo apt update -y
sudo apt upgrade -y

echo "===== Installing Java ====="
sudo apt install openjdk-11-jdk -y

echo "===== Installing Maven ====="
sudo apt install maven -y

echo "===== Installing Git ====="
sudo apt install git -y

echo "===== Installing Tomcat9 ====="
sudo apt install tomcat9 tomcat9-admin -y

echo "===== Starting Tomcat ====="
sudo systemctl enable tomcat9
sudo systemctl start tomcat9

echo "===== Installation Completed Successfully ====="