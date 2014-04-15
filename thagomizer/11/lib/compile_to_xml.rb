#!/usr/bin/env ruby -w

require_relative 'jack_tokenizer'
require_relative 'compilation_engine'
require 'builder'

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

      tokenizer.advance

      ce = CompilationEngine.new tokenizer

      ast = ce.compile_class

      File.open(p.gsub(".jack", ".mine.xml2"), "w") do |f|
        f.puts generate_xml(ast)
      end
    end
  end

  def self.generate_xml(ast)
    output = ""

    builder = Builder::XmlMarkup.new(:target => output, :indent => 1)

    output_nodes(builder, ast)

    output
  end

  def self.output_nodes(builder, ast)
    return if ast.empty?

    if ast.length == 2 && (ast[1].class == String || ast[1].class == Fixnum)
      builder.tag! ast[0], ast[1]
    elsif ast.length == 1
      builder.tag! ast[0]
    else
      builder.tag! ast[0] do
        ast[1..-1].each do |node|
          output_nodes(builder, node)
        end
      end
    end
  end
end


CompileToXML.run ARGV[0]
