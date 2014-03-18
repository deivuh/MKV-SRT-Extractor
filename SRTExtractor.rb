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

