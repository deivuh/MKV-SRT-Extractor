#!/usr/bin/env ruby


dirname = ARGV[0]
Dir.chdir(dirname)
filename = "#{dirname}#{Dir.glob("*.mkv").first(1)[0]}"
puts filename
value = `mkvinfo "#{filename}" | grep 'Name\\|Track number\\|A track'`
puts value
# value = `#{cmd}`

