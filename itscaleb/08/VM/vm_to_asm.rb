#!/usr/bin/env ruby -w

require_relative 'arithmetic'
require_relative 'push'
require_relative 'pop'
require_relative 'program_flow'
require_relative 'function_calling'

class Compiler
  def self.run lines, filename
    asm = []
    asm << Compiler.bootstrap_code
    lines.each do |line|
      case line
      when /^push (\w+) (\d+)/
        push = Push.new $1, $2.to_i, filename
        asm << push.to_asm
      when /^pop (\w+) (\d+)/
        pop = Pop.new $1, $2.to_i, filename
        asm << pop.to_asm
      when /^(add|eq|lt|gt|sub|neg|and|or|not)/
        operator = Object.const_get($1.capitalize)
        asm << operator.to_asm
      when /^if-goto (.+)/
        asm << IfGoto.to_asm($1)
      when /^goto (.+)/
        asm << Goto.to_asm($1)
      when /^label (.+)/
        asm << Label.to_asm($1)
      when /^function (.+) (\d+)/
        func = Function.new($1, $2.to_i)
        asm << func.to_asm
      when /^return/
        asm << Return.to_asm
      when /^call (.+) (\d+)/
        call = Call.new($1, $2.to_i)
        asm << call.to_asm
      else
        raise("cannot parse line: " + line)
      end
    end
    asm
  end

  def self.bootstrap_code
    [ "@256",
      "D=A",
      "@SP",
      "M=D",
      Call.new("Sys.init", 0).to_asm
    ]
  end
end

asm = []
vm_files = ARGV
vm_files.each do |vm_file|
  raw_lines = File.readlines(vm_file)

  clean_lines = raw_lines.map {|line| line.strip}
    .select {|line| !line.start_with?("//") && !line.empty?}
    .map {|line| line.split("//")[0].strip}

    asm << Compiler.run(clean_lines, vm_file.split('/').last)
end

asm.flatten.each do |instruction|
  puts instruction
end
