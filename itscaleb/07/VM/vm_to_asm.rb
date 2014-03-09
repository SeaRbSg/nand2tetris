require_relative 'arithmetic'
require_relative 'push'

raw_lines = File.readlines(ARGV[0])

clean_lines = raw_lines.map {|line| line.strip}
              .select {|line| !line.start_with?("//") && !line.empty?}
              .map {|line| line.split("//")[0].strip}

asm = []
clean_lines.each do |line|
  if line.start_with? "push"
    lines = line.split
    push = Push.new lines[1], lines[2].to_i
    asm << push.to_asm
  elsif line.start_with? "add"
    asm << Arithmetic.add
  end
end

File.open(ARGV[0].gsub("vm", "asm"), 'w') do |file| 
  asm.flatten.each {|line| file.write(line + "\n")}
end
