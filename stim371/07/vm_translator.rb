#!/usr/bin/env ruby
$: << File.dirname(__FILE__)

require 'vm_parser'
require 'vm_code_writer'

writer = CodeWriter.new
writer.file_name = File.basename(ARGV[0])
File.open(ARGV[0].gsub('vm','asm'), 'w') do |file|
  Parser.new(ARGV[0]).parse do |cmd|
    if cmd
      begin
        line = writer.translate(cmd)
        file << line.gsub(/^\s+/,'') unless cmd.nil?
      rescue
        raise "#{cmd.inspect}"
      end
    end
  end
end



