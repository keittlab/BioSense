# Biosense
This is a template repository for the BioSense platform, which demonstrates simple recording schedules via Cronjobs of a BME 280 sensor, a USB microphone, and two soil moisture sensors. Recording schedules or different sets of attached sensors should be customized by editing the Cronjob and/or sensor_collect.py.

# Set Up:
Run these commands on a fresh RPi

# Make sure the pi is updated
```
sudo apt-get update 
sudo apt-get upgrade
```
# Install Packages
```
sudo apt install git
sudo apt install pip
sudo apt-get install python3-pip
sudo pip3 install --upgrade setuptools
sudo apt-get install -y i2c-tools
```
# Enable SSH and i2c
```
sudo raspi-config
```
Select '3 Interface Options' and enable SSH, then repeat and enable I2C

# Make sure the Timezone is correct
```
sudo raspi-config
```
select "5 Localization Options", then select "L2 Timezone" and select the correct timezone, for Austin select US then Central

# Clone the repository
Enter this command from the home directory
```
git clone https://github.com/keittlab/BioSense.git
```
# Run the Setup bash script
```
bash /home/pi/BioSense/hooksetup.bash
```
# Set Up the RTC
```
sudo nano /boot/config.txt
```
Add line below to the end of the file
```
dtoverlay=i2c-rtc,ds3231
```
Then do a reboot
```
sudo reboot
```
Check for the device in i2c, 
Should see UU at 0x68
```
sudo i2cdetect -y 1
```
Disable the Fake Clock
```
sudo apt-get -y remove fake-hwclock
sudo update-rc.d -f fake-hwclock remove
sudo systemctl disable fake-hwclock
sudo nano /lib/udev/hwclock-set
```
Comment out these lines with a #
```
#if [-e /run/systemd/system]; then
#exit 0
#fi
#/sbin/hwclock --rtc=$dev -systz
```
Check the rtc time
```
sudo hwclock -D -r
```
# Run the Raspi-Blinka Scripts, enter Y, will reboot the pi
```
sudo python raspi-blinka.py
```
# Check Blinka
```
python3 ~/BioSense/blinkatest.py
```
# Checking the i2c devices  
Solder the AD0 pad on ONE of the Soil moisture sensors to change the i2c address for one of the soil moisture sensors to 0x37
Enter this command to check the visible devices
```
i2cdetect -y 1
```
Should see this output

![image](https://user-images.githubusercontent.com/45701166/195462601-e89c3723-71dc-4676-90ad-39358cb91333.png)

The BME280 address should be 0x77, The Soil Moisture sensors should be 0x36 and 0x37, the RTC should be 0xUU in cell 0x68, the Display should be 0x3c
# Check that the Microphone is Recording
```
/home/pi/BioSense/upstream-sound.bash
```
Wait for the recording to finish and check the sound directory in ~/BioSense to see if there is a recording
```
cd /home/pi/BioSense/sound/
ls
```
There should be a new recoring with the pi's hostname in the directory 

# Add the Display and Soft Shutdown Scripts to Crontab 
```
crontab -e
```
Enter the following lines into crontab
```
# Update Display
* * * * * python3 /home/pi/BioSense/display.py
```
Enter this line at the top of the file underneath the other reboot commands
```
@reboot python3 /home/pi/BioSense/softshutdown.py &
```

# Add Environmental and Acoustic Data Collection to Crontab 
```
crontab -e
```
Copy and paste this line into the Crontab
```
#Collect Environmental Data every 10 minutes
*/10 * * * * /usr/bin/python3 /home/pi/BioSense/sensor_collect.py >> /home/pi/DATA/logs/sensors.log
```

#Collect Acoustic Data at sunrise and sunset for 1800 seconds (30 minutes)
45 7 * * * /home/pi/BioSense/upstream-sound.bash 1800
35 19 * * * /home/pi/BioSense/upstream-sound.bash 1800
```
CTRL X to exit and then save

```
crontab -e
```
Copy and Paste these lines into the Crontab
```

CTRL X to exit and then save


 sudo arecord -D hw:2,0 -f cd -d 3600 /media/egret/22b60715-a60f-4b6d-9cf6-8c624228142c/$HOSTNAME-`(date +%s)>35 19 * * * sudo arecord -D hw:2,0 -f cd -d 3600 /media/egret/22b60715-a60f-4b6d-9cf6-8c624228142c/$HOSTNAME-`(date +%s>


# Optional Networking and/or Remote Maintenace

To set up a Zerotier VPN that allows us to SSH into devices with dynamic IPs for remote administration without needing to set up port forwarding on the remote network, create a Zerotier account and installation using a local device, then run the following commands to install it on the remote BioSense node
```
https://www.zerotier.com/download/
curl -s https://install.zerotier.com | sudo bash
sudo service zerotier-one restart
sudo zerotier-cli join <network id>
```
