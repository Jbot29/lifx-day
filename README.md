This is a simple program to use the LIFX Api to crudely mimic daylight on one lifx bulb.

The code to get the suns altitude is from http://www.cerebralmeltdown.com

Requires the lifx api ruby package https://github.com/LIFX/lifx-gem

Then the script uses the following global vars to 

$light_name = 'Name of lifx bulb to use'
$latitude = 30.2500
$longitude = -97.7500
$gmtoffset = -6

run with 

ruby lifx-day.rb

And script will run and update every minute. When the sun is below the horizon light is turned of, and the opposite for sun rise. It crudely uses the inclination of the sun to set the intensity of the bulb.

