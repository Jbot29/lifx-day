require 'lifx'
require_relative 'sun-altitude'

$light_name = 'Bedroom'
$latitude = 30.2500
$longitude = -97.7500
$gmtoffset = -6

def get_light(client)
    while $break != 1
      puts "Find lights"
      begin
        puts "Discover"
            client.discover! do |c|
                                c.lights.with_label($light_name)
                                end
                $break = 1
        rescue Exception
               print "Error"
      end
      end

     light = client.lights.with_label($light_name)
     return light
end

def match_sun(light)
    last_altitude = -1

    while 1
    	 altitude = suns_altitude($latitude,$longitude,$gmtoffset)
	 normalized = [altitude / 90.0,0.01].max
	 if altitude > 0
	    if last_altitude == -1
	    light.set_power!(:on)
	    end
		  time = Time.new
		  puts time.hour
		  puts normalized
		  if time.hour > 11 and time.hour < 13
		     color = LIFX::Color.white(brightness: 1.0)
		  else
		     color = LIFX::Color.orange(saturation: 1.0 - normalized, brightness: normalized)
		  end
      		  light.set_color(color, duration: 1)	    
	  end

	  if altitude < 0
	     if last_altitude > -1
	     	     light.set_power!(:off)
		     last_altitude = -1     
		     end
		     
	  end	    
	 sleep 60	
	  
    end

end



client = LIFX::Client.lan

light = get_light(client)

match_sun(light)

client.flush 