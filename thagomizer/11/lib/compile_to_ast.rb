#!/usr/bin/env ruby -w

require_relative 'jack_tokenizer'
require_relative 'compilation_engine_ast'
require 'pp'

class CompileToAST
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

      tokenizer.advance

      ce = CompilationEngineAst.new tokenizer

      ast = ce.compile_class
      File.open(p.gsub(".jack", ".ast"), "w") do |f|
        PP.pp ast, f
      end
    end
  end
end

CompileToAST.run ARGV[0]
