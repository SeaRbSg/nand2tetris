require_relative 'arithmetic'
require_relative 'push'
require_relative 'pop'
require_relative 'program_flow'
require 'pry'

raw_lines = File.readlines(ARGV[0])

file = ARGV[0].split('.')[0]
clean_lines = raw_lines.map {|line| line.strip}
              .select {|line| !line.start_with?("//") && !line.empty?}
              .map {|line| line.split("//")[0].strip}

asm = []
clean_lines.each do |line|
  case line
  when /^push/
    lines = line.split
    push = Push.new lines[1], lines[2].to_i, file
    asm << push.to_asm
  when /^pop/
    lines = line.split
    pop = Pop.new lines[1], lines[2].to_i, file
    asm << pop.to_asm
  when /^add/
    asm << Add.to_asm
  when /^eq/
    asm << Eq.to_asm
  when /^lt/
    asm << Lt.to_asm
  when /^gt/
    asm << Gt.to_asm
  when /^sub/
    asm << Sub.to_asm
  when /^neg/
    asm << Neg.to_asm
  when /^and/
    asm << And.to_asm
  when /^or/
    asm << Or.to_asm
  when /^not/
    asm << Not.to_asm
  when /^label/
    lines = line.split
    asm << Label.to_asm(lines[1])
  when /^if-goto/
    lines = line.split
    asm << IfGoto.to_asm(lines[1])
  when /^goto/
    lines = line.split
    asm << Goto.to_asm(lines[1])
  else
    raise "cannot parse line"
  end
end

File.open(ARGV[0].gsub("vm", "asm"), 'w') do |file| 
  asm.flatten.each {|line| file.write(line + "\n")}
end
