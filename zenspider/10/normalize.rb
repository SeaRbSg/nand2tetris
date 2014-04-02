#!/usr/bin/ruby -w

ARGF.each_line do |line|
  line.chomp!

  case line
  when /^$/ then
    next
  when /^[^ ]/ then
    puts line
  when /^ +<\w+>/ then
    print line.strip
  when /^ +<\/\w+>/ then
    puts line.strip
  when /^ +\"([^\"]+)\"/ then
    print " #{$1} "
  when /^ +(.+)/ then
    print " #{$1} "
  else
    warn "unparsed: #{line.chomp}"
  end
end
