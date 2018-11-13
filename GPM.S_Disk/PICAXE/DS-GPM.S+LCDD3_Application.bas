;
; Designer Systems DS-GPM.S & DS-LCDD3 PICAXE Demonstrator
;
; Requires PICAXE 18X, 28X or 40X processor
; 
; DS-GPM.S on I2C interface (I3&4) Serial LCD DS-LCDD3 on serial interface (O7)
; and pushbutton switch btween V+ & I0
; 
; DS-GPM.S+LCDD3_Application.bas		Date: 23/5/10	Version: 1.00
;

	pause 2000
	
	i2cslave $D0, i2cfast, i2cbyte			'Setup DS-GPM I2C access

	serout 7,N2400,(254,1,255,6)				'Clear LCD and set LCD backlight brightness to 6
	serout 7,N2400,(254,128,"PICAXE DS-GPMu GPS &")
	serout 7,N2400,(254,192,"DS-LCDD3 LCD Sample")
	serout 7,N2400,(254,148,"Application")		'Ouptut start message to serial LCD

	pause 5000							'Wait 5 seconds	

main:

	serout 7,N2400,(254,1)					'Clear displays
	serout 7,N2400,(255,3)					'Set LCD backlight brightness to 3
pos:
	'
	' Output latitude and longitude to displays
	'
	readi2c 14,(b0,b1,b2,b3,b4,b5,b6,b7)			'Read latitude from GPM
	b0=b0+48
	b1=b1+48
	b2=b2+48
	b3=b3+48
	b4=b4+48
	b5=b5+48
	b6=b6+48
	b7=b7+48							'Convert values to ASCII
	readi2c 22,(b8)						'Read latitude character

	' Output to serial LCD
	serout 7,N2400,(254,128,"Lat: ",b0,b1," ",b2,b3,".",b4,b5,b6,b7,b8)

	readi2c 23,(b0,b1,b2,b3,b4,b5,b6,b7,b8)		'Read longitude from GPM
	b0=b0+48
	b1=b1+48
	b2=b2+48
	b3=b3+48
	b4=b4+48
	b5=b5+48
	b6=b6+48
	b7=b7+48
	b8=b8+48							'Convert values to ASCII
	readi2c 32,(b9)						'Read latitude character

	' Output to serial LCD
	serout 7,N2400,(254,192,"Lng: ",b0,b1,b2," ",b3,b4,".",b5,b6,b7,b8,b9)

	readi2c 52,(b0,b1,b2,b3)				'Read speed from GPM
	b0=b0+48
	b1=b1+48
	b2=b2+48
	b3=b3+48							'Convert values to ASCII

	' Output to serial LCD
	serout 7,N2400,(254,148,"Speed: ",b0,b1,b2,".",b3,"Kmh")

	readi2c 44,(b0,b1,b2,b3)				'Read heading from GPM
	b0=b0+48
	b1=b1+48
	b2=b2+48
	b3=b3+48							'Convert values to ASCII

	' Output to serial LCD
	serout 7,N2400,(254,212,"Heading: ",b0,b1,b2,".",b3,"Deg")
	
	if pin0=1 then time

	goto pos
	'
	' Output time and date to LCD display for 5 seconds
	'
time:

	serout 7,N2400,(254,1)					'Clear LCD
	serout 7,N2400,(255,6)					'Set LCD backlight brightness to 6

	for b10=0 to 5

	readi2c 0,(b0,b1,b2,b3,b4,b5)				'Read time from GPM
	b0=b0+48
	b1=b1+48
	b2=b2+48
	b3=b3+48
	b4=b4+48
	b5=b5+48							'Convert values to ASCII

	' Output to serial LCD
	serout 7,N2400,(254,128,"Time: ",b0,b1,":",b2,b3,":",b4,b5)

	readi2c 6,(b0,b1,b2,b3,b4,b5,b6,b7)			'Read date from GPM
	b0=b0+48
	b1=b1+48
	b2=b2+48
	b3=b3+48
	b4=b4+48
	b5=b5+48
	b6=b6+48
	b7=b7+48							'Convert values to ASCII

	' Output to serial LCD
	serout 7,N2400,(254,192,"Date: ",b0,b1,"/",b2,b3,"/",b4,b5,b6,b7)

	pause 1000							'Wait 1 second

	next b10							'and loop 5 times

	goto main							'and return to main routine

	end










