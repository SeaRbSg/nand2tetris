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
      when /^push (\w+) (\d+)/
        push = Push.new $1, $2.to_i, file
        asm << push.to_asm
      when /^pop (\w+) (\d+)/
        pop = Pop.new $1, $2.to_i, file
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
      when /^label (.+)/
        asm << Label.to_asm($1)
      when /^if-goto (.+)/
        asm << IfGoto.to_asm($1)
      when /^goto (.+)/
        asm << Goto.to_asm($1)
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
end

asm = []
vm_files = ARGV
vm_files.each do |vm_file|
  raw_lines = File.readlines(vm_file)

  clean_lines = raw_lines.map {|line| line.strip}
    .select {|line| !line.start_with?("//") && !line.empty?}
    .map {|line| line.split("//")[0].strip}

    #asm << [
    #  "@256",
    #  "D=A",
    #  "@SP",
    #  "M=D"
    #]
    #asm << Call.new("Sys.init", 0).to_asm
    asm << Compiler.run(clean_lines, vm_file.split('/').last)
end

directory_paths = ARGV[0].split('/')[0..1]
outfile = directory_paths.join('/') + "/" + directory_paths[1] + ".asm"
File.open(outfile, 'w') do |file| 
  asm.flatten.each {|line| file.write(line + "\n")}
end
