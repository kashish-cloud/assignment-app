#!/bin/bash

echo_info () {
    echo $1
}

# Updating packages
echo_info "UPDATES-BEING-INSTALLED"
sudo apt update && sudo apt upgrade -y

source ~/.bashrc

# Installing node server
echo_info "INSTALLING-NODEJS"
sudo apt install -y nodejs npm

# Installing unzip
echo_info "INSTALLING-UNZIP"
sudo apt install -y unzip

cd /opt
unzip webapp.zip
rm webapp.zip
cd webapp
mv users.csv /opt/
npm i

# Download the CloudWatch Agent installer
echo_info "DOWNLOADING-CLOUDWATCH-AGENT"
wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb

# Install the CloudWatch Agent
echo_info "INSTALLING-CLOUDWATCH-AGENT"
sudo dpkg -i amazon-cloudwatch-agent.deb

# # Start the CloudWatch Agent service
# echo_info "STARTING-CLOUDWATCH-AGENT"
# sudo service amazon-cloudwatch-agent start

# # Enable the CloudWatch Agent to start on boot
# echo_info "ENABLING-CLOUDWATCH-AGENT"
# sudo systemctl enable amazon-cloudwatch-agent

# # Start CloudWatch Agent
# echo_info "STARTING-CLOUDWATCH-AGENT"
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/cloudwatch-config.json -s

# Starting the service

sudo sh -c "echo '[Unit]
Description=My NPM Service
After=network.target

[Service]
EnvironmentFile=/etc/environment
Type=simple
User=admin
WorkingDirectory=/opt/
ExecStart=/usr/bin/node /opt/app.js
Restart=always
RestartSec=10

[Install]
WantedBy=cloud-init.target
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/webapp.service"

sudo systemctl daemon-reload
sudo systemctl enable webapp
sudo systemctl start webapp
sudo systemctl status webapp