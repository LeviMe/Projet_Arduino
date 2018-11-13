#
# Designer systems DS-GPM.Shield Raspberry-Pi Demonstrator
#
# Requires Raspberry-Pi A or B
#
# DS-GPM.S on GPIO port pin 3 (SDA), pin 5 (SCL) & pin 6 (GND)
#
# ** WARNING **
# ** REMOVE PULLUP JUMPERS FOR SDA & SCL on DS-GPM.S **
#
# Power for DS-GPM.S derived from external 6-15V supply
#
# File: GPM.py   Date: 16/5/2013   Version 1.1
#
# Run from LX terminal window using 'sudo python GPM.py'
# Note: May require i2c setup procedure on R-Pi

 
# import modules needed for this application
import smbus								
import time							
bus = smbus.SMBus(0)

				
# Define DS-GPM.S I2C address (A0 & A1 jumpers ON)
address = 0x68				


# Routine to read single register from GPM.S
def get_single(register):
	try:
	        value = bus.read_byte_data(address, register)
	        return value
	except:
		print 'Oops!'
		return 0


# Routine to read double register from GPM.S and convert
# to tens and units
def get_double(register):
	try:
		value1 = bus.read_byte_data(address, register)
		value2 = bus.read_byte_data(address, register+1)
		value = (value1 * 10) + value2
		return value
	except:
		print 'Oops!'
		return 0


# Main program
while True:

	# Read time from module and display
        hours = get_double(0)
        minutes = get_double(2)
        seconds = get_double(4)
        print hours,':',minutes,':',seconds
       
        time.sleep(1)

	# Read Heading from module and display
        heading = float(get_single(44))*100
        heading += float(get_single(45))*10
        heading += float(get_single(46))
        heading += float(get_single(47))/10
        print 'heading: %.1f' %(heading)
     
        time.sleep(1)
			
        # Read speed from module and display 
        speed = float(get_single(52))*100
        speed += float(get_single(53))*10
        speed += float(get_single(54))
	speed += float(get_single(55))/10  
        print 'speed: %.1f' %(speed)

        time.sleep(1)
			
	# Read latitude from module and display
        latitude_degrees = get_double(14)
        latitude_minutes = float(get_double(16))
        latitude_minutes += float(get_single(18))/10
        latitude_minutes += float(get_single(19))/100
        latitude_minutes += float(get_single(20))/1000
	latitude_minutes += float(get_single(21))/10000
	latitude_direction = chr(get_single(22))
        print 'latitude: %.0f %.5f %s' %(latitude_degrees,latitude_minutes,latitude_direction) 

        time.sleep(1)
        
	# Read longitude from module and display
        longitude_degrees = get_single(23)*100
        longitude_degrees += get_double(24)
        longitude_minutes = float(get_double(26))
        longitude_minutes += float(get_single(28))/10 
        longitude_minutes += float(get_single(29))/100 
        longitude_minutes += float(get_single(30))/1000
        longitude_minutes += float(get_single(31))/10000
        longitude_direction = chr(get_single(32))
        print 'longitude: %.0f %.5f %s' %(longitude_degrees,longitude_minutes,longitude_direction)
                
        time.sleep(1)
