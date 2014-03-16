#!/usr/bin/env ruby -w

require_relative 'parser'
require_relative 'code_writer'
require 'stringio'
require 'pp'

class VMTranslator
  attr_accessor :code_writer

  def initialize source
    @parser = Parser.new(source)
    @code_writer = CodeWriter.new
  end

  def self.run path
    paths = []

    if File.directory?(path)
      Dir.entries(path).each do |entry|
        paths << "#{path}#{entry}" if entry =~ /vm$/
      end
    else
      paths << path
    end

    paths.each do |p|
      sio = StringIO.new File.read p

      vmt = VMTranslator.new(sio)

      path =~ /\/(\w*)\.vm$/
      vmt.code_writer.file_name = $1

      vmt.translate
      vmt.write(p.gsub(/\..*/, '.asm'))
    end
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
