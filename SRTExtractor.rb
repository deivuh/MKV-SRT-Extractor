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


path = ARGV[0]
Dir.chdir(path)
filename = "#{path}#{Dir.glob("*.mkv").first(1)[0]}"
puts filename
info_command = `mkvinfo "#{filename}" | grep 'Name\\|Track number\\|A track'`
puts info_command
# value = `#{cmd}`



track_number = Integer(STDIN.gets.chomp)


Dir.glob("#{path}*.mkv") do | mkv_path |
  mkv_name = File.basename( mkv_path, ".*" )
  extract_command = `mkvextract tracks #{mkv_path} #{track_number}:#{mkv_name}.ass`
end

Dir.glob("#{path}*.ass") do | ass_path |
	puts `ruby ./converter.rb "#{ass_path}"`

end




puts "Done! Delete the extracted .ass files? [Y/n]"
delete = STDIN.gets.chomp[0]

if delete == 'N' || delete == 'n'
	
else
	Dir.glob("#{path}*.ass") do | ass_path |
		rm_msg = `rm "#{ass_path}"`
		puts ".ass files deleted"
	end

end

