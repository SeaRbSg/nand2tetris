#!/usr/bin/env ruby
$: << File.dirname(__FILE__)

require 'n2t_parser'

class Assembler
  attr_reader :input_file, :output_file, :parser

  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
    @parser = Parser.new(input_file)
  end

  def assemble
    File.open(output_file, 'w') do |f|
      while parser.more_commands?
        bits = parser.translate_current_command
        f.write("#{bits}\n")
        parser.advance
      end
    end
  end
end

asm = Assembler.new(ARGV[0], ARGV[1] || "./out.hack")
asm.assemble