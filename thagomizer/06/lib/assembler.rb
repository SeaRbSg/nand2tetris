#!/usr/bin/env ruby -w

require_relative 'parser'
require_relative 'code'
require_relative 'symbol_table'
require 'stringio'

class Assembler
  attr_accessor :parser, :out_path, :machine_cmds

  def initialize source
    @parser = Parser.new(source)
    @symbol_table = SymbolTable.new
    @machine_cmds = []
  end

  def self.run path
    sio = StringIO.new File.read path

    ass = Assembler.new(sio)

    ass.process_labels
    ass.assemble
    ass.write(path.gsub(/\..*/, '.hack'))
  end

  def process_labels
    line_no = 0

    while @parser.has_more_commands?
      @parser.advance

      case @parser.command_type
      when :l_command
        @symbol_table.add_entry @parser.symbol, line_no
      else
        line_no += 1
      end
    end

    @parser.reset
  end

  def assemble
    while @parser.has_more_commands?
      @parser.advance

      case @parser.command_type
      when :a_command
        convert_a_command
      when :c_command
        convert_c_command
      when :l_command
        # no-op
      end
    end
  end

  def convert_a_command
    if @parser.symbol =~ /^\d+$/
      @machine_cmds << Code.a_command(@parser.symbol)
    else
      address = @symbol_table.add_var @parser.symbol
      @machine_cmds << Code.a_command(address)
    end
  end

  def convert_c_command
    @machine_cmds << Code.c_command(@parser.dest, @parser.comp, @parser.jump)
  end

  def write path
    File.open(path, "w") do |f|
      f.write @machine_cmds.join("\n")
    end
  end
end

Assembler.run ARGV[0]
