#!/usr/bin/env ruby -w

require_relative 'jack_tokenizer'
require_relative 'compilation_engine'
require 'pp'

class CompileToXML
  def self.run path
    paths = []

    if File.directory?(path)
      Dir.entries(path).each do |entry|
        paths << "#{path}/#{entry}" if entry =~ /jack$/
      end
    else
      paths << path
    end

    paths.each do |p|
      tokenizer = JackTokenizer.from_file(p)

      tokens = extract_tokens tokenizer
      ce = CompilationEngine.new tokens

      ce.compile_class

      File.open(p.gsub(".jack", ".mine.xml"), "w") do |f|
        f.puts ce.output
      end
    end
  end

  def self.extract_tokens t
    tokens = []

    while t.has_more_commands?
      t.advance
      tokens << t.current_token
    end

    tokens
  end
end

CompileToXML.run ARGV[0]
