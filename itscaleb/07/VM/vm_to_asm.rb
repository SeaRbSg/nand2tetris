require_relative 'arithmetic'
require_relative 'push'
require_relative 'pop'
require 'pry'

raw_lines = File.readlines(ARGV[0])

clean_lines = raw_lines.map {|line| line.strip}
              .select {|line| !line.start_with?("//") && !line.empty?}
              .map {|line| line.split("//")[0].strip}

asm = []
arithmetic = Arithmetic.new
clean_lines.each do |line|
  if line.start_with? "push"
    lines = line.split
    push = Push.new lines[1], lines[2].to_i
    asm << push.to_asm
  elsif line.start_with? "pop"
    lines = line.split
    pop = Pop.new lines[1], lines[2].to_i
    asm << pop.to_asm
  elsif line.start_with? "add"
    asm << arithmetic.add
  elsif line.start_with? "eq"
    asm << arithmetic.eq
  elsif line.start_with? "lt"
    asm << arithmetic.lt
  elsif line.start_with? "gt"
    asm << arithmetic.gt
  elsif line.start_with? "sub"
    asm << arithmetic.sub
  elsif line.start_with? "neg"
    asm << arithmetic.neg
  elsif line.start_with? "and"
    asm << arithmetic.and
  elsif line.start_with? "or"
    asm << arithmetic.or
  elsif line.start_with? "not"
    asm << arithmetic.not
  end
end

File.open(ARGV[0].gsub("vm", "asm"), 'w') do |file| 
  asm.flatten.each {|line| file.write(line + "\n")}
end
