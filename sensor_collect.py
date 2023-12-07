#!/usr/bin/env python3

from time import sleep, strftime, time
import board
import csv
from pathlib import Path
from os import path, uname
from adafruit_bme280 import basic as adafruit_bme280
from adafruit_seesaw.seesaw import Seesaw

# creating the sensor objects, uses the boards default I2C bus
i2c = board.I2C()
try:
	bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c)
	# setting location's Pressure (hPa) at Sea level, Austin TX
	bme280.sea_level_pressure = 1019
except:
	print(strftime("%Y-%m-%d-%H:%M:%S") + ": BME280 i2c address could not be found.")
try:
	ss = Seesaw(i2c, addr = 0x36)
except:
	print(strftime("%Y-%m-%d-%H:%M:%S") + ": Soil Moisture Sensor 1 at 0x36 could not be found.")
try:
	ss2 = Seesaw(i2c, addr = 0x37)
except:
	print(strftime("%Y-%m-%d-%H:%M:%S") + ": Soil Moisture Sensor 2 at 0x37 could not be found.")

# Get Hostname and Location
Hostname = uname()[1]
# print(Hostname)
Location = "unique_location"

# Create String for File Name
FilePath = Path("~/DATA/environmental/" + str(Hostname) + str("-") + strftime("%Y%m%d") + str(".csv")).expanduser()
#print(FileName)

# Check if Data file is already Created
if FilePath.exists() is False:
	FilePath.parent.mkdir(parents=True, exist_ok=True)
	# print("file does not exist")
	# If not Create the File and add the Headers
	# Hostname - Location - Date - Time - Temp - Hum - Press - SM1_T - SM1_M- SM2_T - SM2_M
	with Filepath.open("a") as log:
		log.write("Hostname,Location,Date,Time,Temp,Hum,Press,Alt,SM1_T,SM1_M,SM2_T,SM2_M\n")


# Collecting and writing data to the CSV
with FilePath.open("a") as log:
#	while True:
		# creating the data variables
		try:
			temp = bme280.temperature
			hum = bme280.relative_humidity
			pres = bme280.pressure
			alt = bme280.altitude
		except:
			print(strftime("%Y-%m-%d-%H:%M:%S") + ": Could not collect data from the BME280.")
			temp="n/a"
			hum="n/a"
			pres="n/a"
			alt="n/a"
		try:
			mois1 = ss.moisture_read()
			smtemp1 = ss.get_temp()
		except:
			print(strftime("%Y-%m-%d-%H:%M:%S") + ": Could not collect data from SS1 at 0x36.")
			mois1="n/a"
			smtemp1="n/a"
		try:
			mois2 = ss2.moisture_read()
			smtemp2 = ss2.get_temp()
		except:
			print(strftime("%Y-%m-%d-%H:%M:%S") + ": Could not collect data from SS2 at 0x37.")
			mois2="n/a"
			smtemp2="n/a"
		
		log.write("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}\n".format(str(Hostname),str(Location),strftime("%Y-%m-%d"),strftime("%H:%M:%S"),str(temp), str(hum), str(pres),str(alt),str(smtemp1),str(mois1),str(smtemp2),str(mois2)))
		log.close()

# Print commands for testing
#		print("\nTemperature: %0.2f C" % bme280.temperature)
#		print("Humidity: %0.2f %%" % bme280.relative_humidity)
#		print("Pressure: %0.2f hPa" % bme280.pressure)
#		print("Altitude: %0.2f meters" % bme280.altitude)

#		sleep(2)

