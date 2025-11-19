#!/bin/bash

TOMCAT_VERSION=9.0.112
TOMCAT_FILE=apache-tomcat-$TOMCAT_VERSION.tar.gz
TOMCAT_DIR=apache-tomcat-$TOMCAT_VERSION

echo "===== Updating System ====="
sudo apt update -y

echo "===== Installing Java ====="
sudo apt install -y openjdk-11-jdk

echo "===== Installing Maven ====="
sudo apt install -y maven

echo "===== Installing Git ====="
sudo apt install -y git

echo "===== Downloading Tomcat $TOMCAT_VERSION ====="
wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/${TOMCAT_FILE}

echo "===== Extracting Tomcat ====="
tar -xvf ${TOMCAT_FILE}

echo "===== Moving Tomcat to /opt/tomcat ====="
sudo mv ${TOMCAT_DIR} /opt/tomcat

echo "===== Giving Execute Permission to Scripts ====="
sudo chmod +x /opt/tomcat/bin/*.sh

echo "===== Creating Tomcat Service ====="

sudo bash -c 'cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat 9 Service
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment=CATALINA_OPTS="-Xms512M -Xmx1024M"
Environment=JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=ubuntu
Group=ubuntu

[Install]
WantedBy=multi-user.target
EOF'

echo "===== Setting Permissions for Tomcat Directory ====="
sudo chown -R ubuntu:ubuntu /opt/tomcat

echo "===== Reloading Daemon and Starting Tomcat ====="
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

echo "===== Tomcat Installation Completed Successfully ====="
echo "Open Tomcat in browser: http://<EC2_PUBLIC_IP>:8080"
