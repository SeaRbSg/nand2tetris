#!/usr/bin/env ruby -w

require_relative 'parser'
require_relative 'code_writer'
require 'stringio'
require 'pp'

class VMTranslator
  attr_accessor :code_writer, :parser

  def initialize
    @parser = Parser.new
    @code_writer = CodeWriter.new
  end

  def self.run path
    paths = []
    out_path = ""

    vmt = VMTranslator.new

    if File.directory?(path)
      Dir.entries(path).each do |entry|
        paths << "#{path}#{entry}" if entry =~ /vm$/
      end

      out_path = File.join(path, "#{path.split(File::SEPARATOR).last}.asm")
      vmt.code_writer.write_bootstrap
    else
      paths << path
      out_path = path.gsub(".vm", ".asm")
    end

    paths.each do |p|
      sio = StringIO.new File.read p

      vmt.parse(sio)

      vmt.translate
    end

    vmt.write(out_path)
  end

  def parse(io)
    @parser.source = io
  end

  def translate
    while @parser.has_more_commands?
      @parser.advance

      case @parser.command_type
      when :c_push
        @code_writer.write_push(@parser.arg1, @parser.arg2)
      when :c_pop
        @code_writer.write_pop(@parser.arg1, @parser.arg2)
      when :c_arithmetic
        @code_writer.write_arithmetic(@parser.arg1)
      when :c_label
        @code_writer.write_label(@parser.arg1)
      when :c_goto
        @code_writer.write_goto(@parser.arg1)
      when :c_if
        @code_writer.write_if(@parser.arg1)
      when :c_function
        @code_writer.write_function(@parser.arg1, @parser.arg2)
      when :c_return
        @code_writer.write_return
      when :c_call
        @code_writer.write_call(@parser.arg1, @parser.arg2)
      else
        raise "No translate handler for #{@parser.command_type}"
      end
    end
  end

  def write path
    @code_writer.write path
  end
end

VMTranslator.run ARGV[0]
