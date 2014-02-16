#!/usr/bin/env ruby



@styles = []
@subtitle_counter = 0

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
	

	line = line.gsub(/{[^,]}/,"")
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
	newLine = ""
	regex = /Dialogue: *\d+, *(\d+:\d+:\d+).(\d+), *(\d+:\d+:\d+).(\d+), *([^,]+), *([^,]*), *\d{4},\d{4},\d{4}, *[^,]*, *(.*)$/
	#If Dialogue line is found
	if line.scan(regex).length > 0
		match = line.scan(regex)
		newLine = ""
	end
		

# 1
# 00:00:12,000 --> 00:00:15,123
# This is the first subtitle

# 2
# 00:00:16,000 --> 00:00:18,000
# Another subtitle demonstrating tags:
# <b>bold</b>, <i>italic</i>, <u>underlined</u>
# <font color="#ff0000">red text</font>

# 3
# 00:00:20,000 --> 00:00:22,000  X1:40 X2:600 Y1:20 Y2:50
# Another subtitle demonstrating position.

		#Dialogue: +\d+,(\d+:\d+:\d+).(\d+),(\d+:\d+:\d+).(\d+),(.+),(.+),\d+,.*,(?<![\{\}\S]).+$
	return line

end

# For each file defined as arguments
ARGV.each do|arg|
	f = File.open(arg)

	while line = f.gets do
		line = replace_tags(line)
		line = get_styles(line)
		line = replace_braces(line)
		
		line = set_srt_formatting(line)

	end

	f.close  
	# print @styles

end


