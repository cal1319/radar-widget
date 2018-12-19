require 'open-uri'

@cameraDelay = 1 # Needed for image sync. 
@fetchNewImageEvery = '90s'

@radar1Host = "https://cdn.tegna-media.com/kxtv/weather/satradsac16x9.jpg"
@newFile1 = "assets/images/radar/new.png"
@oldFile1 = "assets/images/radar/old.png"

@radar2Host = "https://cdn.tegna-media.com/kxtv/weather/satradnorcal16x9.jpg"
@newFile2 = "assets/images/radar/tahoe_new.png"
@oldFile2 = "assets/images/radar/tahoe_old.png"

@radar3Host = "https://cdn.tegna-media.com/kxtv/weather/satradtahoe16x9.jpg"
@newFile3 = "assets/images/radar/norcal_new.png"
@oldFile3 = "assets/images/radar/norcal_old.png"

# Change "OHX" in the file << open... line to your radar station ID. Check README for link.
def fetch_image(host,old_file,new_file)
	`rm #{old_file}` 
	`mv #{new_file} #{old_file}`	
	open('assets/images/radar/new.png', 'wb') do |file|
		file << open('host').read
	end
	new_file
end

def make_web_friendly(file)
  "/" + File.basename(File.dirname(file)) + "/" + File.basename(file)
end

SCHEDULER.every @fetchNewImageEvery, first_in: 0 do
	new_file1 = fetch_image(@oldFile1,@newFile1)
	new_file2 = fetch_image(@oldFile2,@newFile2)
	new_file3 = fetch_image(@oldFile3,@newFile3)

	if not File.exists?(@newFile1 && @newFile2 && @newFile3)
		warn "Failed to Get Radar Image"
	end
 
	send_event('radar', image: make_web_friendly(@oldFile1))
	send_event('tahoe', image: make_web_friendly(@oldFile2))
	send_event('norcal', image: make_web_friendly(@oldFile3))
	sleep(@cameraDelay)
	send_event('radar', image: make_web_friendly(new_file1))
	send_event('tahoe', image: make_web_friendly(new_file2))
	send_event('norcal', image: make_web_friendly(new_file3))
end
