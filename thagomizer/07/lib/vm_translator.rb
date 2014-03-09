#!/usr/bin/env ruby -w

require_relative 'parser'
require_relative 'code_writer'
require 'stringio'

class VMTranslator
  attr_accessor :code_writer

  def initialize source
    @parser = Parser.new(source)
    @code_writer = CodeWriter.new
  end

  def self.run path
    sio = StringIO.new File.read path

    vmt = VMTranslator.new(sio)

    path =~ /\/(\w*)\.vm$/
    vmt.code_writer.file_name = $1

    vmt.translate
    vmt.write(path.gsub(/\..*/, '.asm'))
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
      end
    end
  end

  def write path
    @code_writer.write path
  end
end

VMTranslator.run ARGV[0]
