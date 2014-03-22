#!/usr/bin/env ruby -w

require_relative 'arithmetic'
require_relative 'push'
require_relative 'pop'
require_relative 'program_flow'
require_relative 'function_calling'

class Compiler
  def self.run lines, file
    asm = []
    lines.each do |line|
      case line
      when /^push/
        instructions = line.split
        push = Push.new instructions[1], instructions[2].to_i, file
        asm << push.to_asm
      when /^pop/
        instructions = line.split
        pop = Pop.new instructions[1], instructions[2].to_i, file
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
        instructions = line.split
        asm << Label.to_asm(instructions[1])
      when /^if-goto/
        instructions = line.split
        asm << IfGoto.to_asm(instructions[1])
      when /^goto/
        instructions = line.split
        asm << Goto.to_asm(instructions[1])
      when /^function/
        instructions = line.split
        func = Function.new(instructions[1], instructions[2].to_i)
        asm << func.to_asm
      when /^return/
        asm << Return.to_asm
      else
        raise "cannot parse line"
      end
    end
    asm
  end
end

raw_lines = File.readlines(ARGV[0])
clean_lines = raw_lines.map {|line| line.strip}
  .select {|line| !line.start_with?("//") && !line.empty?}
  .map {|line| line.split("//")[0].strip}

asm = Compiler.run clean_lines, ARGV[0]

File.open(ARGV[0].gsub("vm", "asm"), 'w') do |file| 
  asm.flatten.each {|line| file.write(line + "\n")}
end
