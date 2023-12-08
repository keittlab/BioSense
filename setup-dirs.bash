#!/bin/bash
echo "This script creates needed directories for collecting data through a BME280 Sensor and I2C Soil Moisture Sensors"
echo ""
echo "Setting up directories"
sudo mkdir ~/DATA
sudo chown $USER ~/DATA
sudo chmod +x ~/DATA
mkdir ~/DATA/sound
mkdir ~/DATA/environmental
mkdir ~/DATA/logs

echo "Checking Directories in /DATA"
ls /DATA
echo "ALL DONE!"


