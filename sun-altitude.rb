#This code was taken from the below blog post, only changes to it were to turn it in to a function with parameters

##############
# Go to http://www.cerebralmeltdown.com for the original location of this program
#Sources used for this program
# Meeus, Jean. Astronomical Algorithms. 2nd ed. Willmann-Bell, Inc, 2005.
##################


class Numeric
    #Degrees to radians.
    def to_rad
        self * Math::PI / 180.0
    end
    #Radians to degrees.
    def to_deg
        self * 180.0 / Math::PI
    end
end
 class Float
    alias_method :round_orig, :round
    def round(n=0)
        (self * (10.0 ** n)).round_orig * (10.0 ** (-n))
    end
end  

def suns_altitude(latitude,longitude,timezone)
#Longitude in Hours
longitude = (longitude*-1)/15

######################
# Begin Julian Day Calculation (Meeus Pages 59-61) vvvv
t= Time.now
y = t.gmtime.year
m = t.gmtime.month
d = t.gmtime.day + t.gmtime.hour/24.to_f + t.gmtime.min/1440.to_f + t.gmtime.sec/86400.to_f
if m > 2
  y=y
  m=m
   else
  y = y-1
  m = m+12
      end
a = (y/100).to_int
b = 2 - a + (a/4).to_int
jd = (365.25 * (y+4716)).to_int + (30.6001 * (m+1)).to_int + d + b + -1524.5
# End Julian Day Calculation^^^^
######################


################
# (Meeus Pages 163-164) vvv
#Time in Julian Centuries
t = ((jd - 2451545.0)/36525.0)
#Mean equinox of the date
l = 280.46645 + 36000.76983*t + 0.0003032*t**2
#Mean Anomaly of the Sun 
m = 357.52910 + 35999.05030 *t - 0.0001559 *t**2 - 0.00000048*t**3
#Eccentricity of the Earth's Orbit
e = 0.016708617 - 0.000042037*t - 0.0000001236*t**2
# Sun's Equation of the center
c = (1.914600 - 0.004817 *t - 0.000014 * t**2) * Math.sin(m.to_rad) + (0.019993 - 0.000101*t) * Math.sin(2*m.to_rad) + 0.000290*Math.sin(3*m.to_rad)
#Sun's True Longitude
o = l +c
#Brings 'o' within + or - 360 degrees. (Taking an inverse function of very large numbers can sometimes lead to slight errors in output)
o=o.divmod(360)[1]
################

###############
#(Meeus Page 164)
#Sun's Apparant Longitude (The Output of Lambda)
omega = 125.04 - 1934.136*t
lambda = o - 0.00569 - 0.00478 * Math.sin(omega.to_rad)
#Brings 'lambda' within + or - 360 degrees. (Taking an inverse function of very large numbers can sometimes lead to slight errors in output)
lambda = lambda.divmod(360)[1]
###############


#Obliquity of the Ecliptic (Meeus page 147) (numbers switched from degree minute second in book to decimal degree)
epsilon = (23.4392966666667 - 0.012777777777777778*t - 0.00059/60.to_f * t**2 + 0.00059/60.to_f * t**3) + (0.00256 * Math.cos(omega.to_rad))

#Sun's Declination (Meeus page 165)
delta = Math.asin(Math.sin(epsilon.to_rad)*Math.sin(lambda.to_rad)).to_deg

#Sun's Right Acension (Meeus page 165) (divided by 15 to convert to hours)
alpha =Math.atan2(((Math.cos(epsilon.to_rad) * Math.sin(lambda.to_rad))),(Math.cos(lambda.to_rad))).to_deg/15
if alpha < 0
  alpha = alpha + 24
  end

#Sidereal Time (Meeus Page 88)
theta = (280.46061837 + 360.98564736629 * (jd-2451545.0) + 0.000387933*t**2 - ((t**3)/38710000))/15.to_f
#Brings 'theta' within + or - 360 degrees. (Taking an inverse function of very large numbers can sometimes lead to slight errors in output)
theta = theta.divmod(360)[1]


#The Local Hour Angle (Meeus Page 92) (multiplied by 15 to convert to degrees)
h = (theta - longitude - alpha)*15
#Brings 'h' within + or - 360 degrees. (Taking an inverse function of very large numbers can sometimes lead to slight errors in output)
h =h.divmod(360)[1]


############
#Local Horizontal Coordinates (Meeus Page 93)
#Altitude
altitude = Math.asin(Math.sin(latitude.to_rad)*Math.sin(delta.to_rad) + Math.cos(latitude.to_rad)*Math.cos(delta.to_rad)*Math.cos(h.to_rad)).to_deg
	 return altitude
end









