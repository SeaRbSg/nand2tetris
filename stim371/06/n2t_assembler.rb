#!/usr/bin/env ruby
$: << File.dirname(__FILE__)

require 'n2t_parser'

class Assembler
  attr_reader :input_file, :output_file, :parser
  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
    @parser = Assembler::Parser.new(input_file)
  end

  def assemble
    File.open(output_file, 'w') do |hack|
      while parser.more_commands?
        if parser.command.real?
          bits = parser.translate_current_command
          p "command: #{parser.command.value} translates to #{bits}"
          hack.write("#{bits}\n")
        end
        parser.advance
      end
    end
    p "binary file available at: #{output_file}"
  end
end

asm = Assembler.new(ARGV[0], ARGV[1] || "./out.hack")
asm.assemble