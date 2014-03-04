#!/usr/bin/env ruby

require_relative 'parser'
require_relative 'code'
require 'stringio'

class Assembler
  attr_accessor :parser, :out_path, :machine_cmds

  def initialize(path)
    File.open(path, "r") do |f|
      @parser = Parser.new(StringIO.new(f.read))
    end

    self.out_path = path.gsub(/\..*/, '.hack')
    self.machine_cmds = []

    self.assemble
  end

  def assemble
    while @parser.has_more_commands?
      @parser.advance

      case @parser.command_type
      when :a_command
        handle_a_command
      when :l_command
        handle_l_command
      when :c_command
        handle_c_command
      end
    end

    write
  end

  def handle_a_command
    machine_cmds << Code.a_command(@parser.symbol)
  end

  # def handle_l_command
  #   // TBD
  # end

  def handle_c_command
    machine_cmds << Code.c_command(@parser.dest, @parser.comp, @parser.jump)
  end

  def write
    File.open(self.out_path, "w") do |f|
      f.puts(machine_cmds.join("\n"))
    end
  end
end

Assembler.new ARGV[0]
