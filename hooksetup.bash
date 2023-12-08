#!/bin/bash 
#This File installs and runs all the necesarry commands to set up a fresh Pi with the Hook/Upstream repositories
# run this file with `bash hooksetup.bash`

# Update and Upgrade the RPi to make sure it's up to date
echo "Updating and Upgrading the Pi, this could take a while..."
sudo apt-get update 
sudo apt-get upgrade

# Install needed packages
echo "Installing needed Packages"
sudo apt install pip
sudo apt-get install python3-pip
sudo pip3 install --upgrade setuptools
sudo apt-get install -y i2c-tools
pip3 install python-dateutil
sudo apt -y install at
sudo pip3 install python-dateutil
sudo pip3 install --upgrade adafruit-python-shell
wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/raspi-blinka.py
pip install pathlib
sudo apt-get install exfat-fuse
sudo apt-get install exfat-utils
sudo apt-get install python3-pil
sudo apt-get install python3-numpy
pip3 install adafruit-circuitpython-display-text

# Installing Sensor Libraries
echo "Installing Sensor Libraries"
pip3 install adafruit-circuitpython-bme280
sudo pip3 install adafruit-circuitpython-seesaw
pip3 install adafruit-circuitpython-ssd1306
pip3 install adafruit-circuitpython-displayio-ssd1306
sudo python -m pip install --upgrade pip setuptools wheel
sudo pip install Adafruit-SSD1306

# Set Up Required Directories
echo "Adding required directories"
bash ./setup-dirs.bash

# Making Files executable
sudo chmod +x ./display.py
sudo chmod +x ./sensor_collect.py
sudo chmod +x ./transfersensorfiles.bash
sudo chmod +x ./cleanup-all-transferedsensorfiles.bash

# # Installing Python Modules for the MinIO tests
# echo "Installing Python Modules for the MinIO tests"
# cd upstream-rpi/stengl-minio-tests 
# bash minio-clientsetup.bash 

# # Setting up the Sunset and Sunrise Recordings
# echo "Setting up the Sunrise Sunset Recording Schedule"
# # rm -rf /home/pi/upstream
# # ln -s /home/pi/upstream-rpi /home/pi/upstream
# # mkdir /home/pi/upstream/sound 
# sudo cp ./crontabs.txt /var/spool/cron/crontabs/pi 
# sudo chmod 0600 /var/spool/cron/crontabs/pi 
# sudo chown pi /var/spool/cron/crontabs/pi 
# sudo systemctl restart cron 
# rm /home/pi/upstream-rpi/sunrise-sunset-times.txt
# mv /home/pi/Hook-Deployment/sunrise-sunset-times.txt /home/pi/upstream-rpi/sunrise-sunset-times.txt

# echo "Scheduling the Recordings..."
# bash /home/pi/upstream/upstream-atqcheck.bash 

echo "All done!"




