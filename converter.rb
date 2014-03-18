 # This file is part of MKV-SRT-Extractor.

 #    MKV-SRT-Extractor is free software: you can redistribute it and/or modify
 #    it under the terms of the GNU General Public License as published by
 #    the Free Software Foundation, either version 3 of the License, or
 #    (at your option) any later version.

 #    Foobar is distributed in the hope that it will be useful,
 #    but WITHOUT ANY WARRANTY; without even the implied warranty of
 #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #    GNU General Public License for more details.

 #    You should have received a copy of the GNU General Public License
 #    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.





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
		"{\\b0}"=>"</b>"
		# "\\N"=>""
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
	line = line.gsub(/(\\N)+/) { "\n" }
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
def set_srt_formatting(dialogue)
	style = @styles.detect {|style| style[:name] == dialogue[:style] }
	new_line = "#{@subtitle_counter}\n#{dialogue[:show_time]} --> #{dialogue[:hide_time]}\n<font color=\"\##{style[:font_color]}\">#{dialogue[:dialogue]}<\/font>\n\n"
	@subtitle_counter += 1
		
	

		
	return new_line

end


# Parse and sort dialogues
def parse_dialogue(line)
	new_dialogue = Hash.new
	regex = /Dialogue: *\d+, *(\d+:\d+:\d+).(\d+), *(\d+:\d+:\d+).(\d+), *([^,]+), *([^,]*), *\d{4},\d{4},\d{4}, *[^,]*, *(.*)/m
	#If Dialogue line is found
	if line.scan(regex).length > 0
		match = line.scan(regex)
		new_dialogue = {
			:counter => @subtitle_counter,
			:show_time => "#{match[0][0]},#{match[0][1]}",
			:hide_time => "#{match[0][2]},#{match[0][3]}",
			:style => "#{match[0][4]}",
			:dialogue => "#{match[0][6]}"
		}
		
		@subtitle_counter += 1
		

	end

		
	return new_dialogue

end


# For each file defined as arguments
ARGV.each do|arg|

	filename = arg
	dialogues = []

	f = File.open(arg)

	while line = f.gets do
		line = replace_tags(line)
		line = get_styles(line)
		line = replace_braces(line)
		# print line
		dialogue = parse_dialogue(line)
		if dialogue.length > 0
			dialogues.push(dialogue)	
		end
		
		# line = set_srt_formatting(line)
		# if line.length > 0
			# @new_file.push(line)	


		# end



	end

	f.close  

	@subtitle_counter = 1

	da = dialogues.sort_by { |d| d[:show_time] }

	da.each do |d| 
		@new_file.push(set_srt_formatting(d))
	end

	srt_filename = filename.gsub(/.ass/,".srt")

	print "Filename #{srt_filename}"

	puts File.exists? srt_filename

	File.open(srt_filename, 'w:UTF-8') do |srt_file|
		@new_file.each do |new_line|
			srt_file.puts(new_line)
			print new_line
		end
	
	srt_file.close

	end

	

end




