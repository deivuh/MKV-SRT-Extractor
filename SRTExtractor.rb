#!/usr/bin/env ruby



@styles = []
@subtitle_counter = 1
@new_file = []

# Replace ASS format tags to it's SRT equivalents
def replace_tags(line)
	
	tags = {
		"{\\i1}"=>"<i>",
		"{\\i0}"=>"</i>",
		"{\\u1}"=>"<u>",
		"{\\u0}"=>"</u>",
		"{\\b1}"=>"<b>",
		"{\\b0}"=>"</b>",
		"\\N"=>""
	}


	tags.each do |key, value|
		line = line.gsub(key, value)
	end

	return line

end

# Remove {anything inside braces}  
def replace_braces(line)
	

	line = line.gsub(/\{[\w\W]+\}/,"")
	# line = line.gsub("}", "; ")

	return line

end


# Get style properties
def get_styles(line) 

	regex = /Style: +([\wWd ]+),([\wWd ]+),(\d+),\&H[\wd]{2}([\wWd]+),\&[\wWd]+,\&[\wWd]+,\&[\wWd]+,-*(\d),-*(\d),-*(\d),-*(\d),-*[\d]+,-*[\d]+.+$/

	#If Style line is found
	if line.scan(regex).length > 0
		match = line.scan(regex)
		new_style = {
			:name => match[0][0],
			:font_name => match[0][1],
			:font_size => match[0][2],
			:font_color => match[0][3],
			:bold => match[0][4],
			:italic => match[0][5],
			:underline => match[0][6],
			:strike_out => match[0][7]
		}
		
		@styles.push(new_style)


	end

	return line
	
end

# Set SRT format
def set_srt_formatting(line)
	new_line = ""
	regex = /Dialogue: *\d+, *(\d+:\d+:\d+).(\d+), *(\d+:\d+:\d+).(\d+), *([^,]+), *([^,]*), *\d{4},\d{4},\d{4}, *[^,]*, *(.*)$/
	#If Dialogue line is found
	if line.scan(regex).length > 0
		match = line.scan(regex)
		new_line = "#{@subtitle_counter}\n0#{match[0][0]},0#{match[0][1]} --> 0#{match[0][2]},0#{match[0][3]}\n#{match[0][6]}\n\n"
		@subtitle_counter += 1
		print new_line
	end

		
	return new_line

end



# For each file defined as arguments
ARGV.each do|arg|

	filename = arg

	f = File.open(arg)

	while line = f.gets do
		line = replace_tags(line)
		line = get_styles(line)
		line = replace_braces(line)
		line = set_srt_formatting(line)
		if line.length > 0
			@new_file.push(line)	

		
		end
		

	end

	f.close  




	srt_filename = filename.gsub(/.ass/,".srt")

	# print "Filename #{srt_filename}"

	# puts File.exists? srt_filename

	File.open(srt_filename, 'w:UTF-8') do |srt_file|
		@new_file.each do |new_line|
			srt_file.puts(new_line)
			print new_line
		end
	
	srt_file.close

	end

	

end




