#!/usr/bin/env ruby -w

require_relative 'parser'
require_relative 'code'
require_relative 'symbol_table'
require 'stringio'

class Assembler
  attr_accessor :parser, :out_path, :machine_cmds

  def initialize(path)
    File.open(path, "r") do |f|
      @parser = Parser.new(StringIO.new(f.read))
    end
    @symbol_table = SymbolTable.new

    @out_path = path.gsub(/\..*/, '.hack')
    @machine_cmds = []

    self.process_labels
    self.assemble
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

    write
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

  def write
    File.open(self.out_path, "w") do |f|
      f.puts(@machine_cmds.join("\n"))
    end
  end
end

Assembler.new ARGV[0]
