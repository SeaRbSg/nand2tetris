#!/usr/bin/env ruby -w

require_relative 'jack_tokenizer'
require 'builder'
require 'pp'

class TokenizeToXML
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

      File.open(p.gsub(".jack", "T.mine.xml"), "w") do |f|
        f.puts write_to_xml(tokens)
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


  def self.write_to_xml tokens
    tokens.compact!
    result_xml = ""

    builder = Builder::XmlMarkup.new(:target => result_xml, :indent => 1)

    builder.tokens do

      tokens.each do |token|
        case token.type
        when :keyword
          builder.keyword token.token
        when :symbol
          builder.symbol token.token
        when :identifier
          builder.identifier token.token
        when :string_constant
          builder.stringConstant token.token
        when :integer_constant
          builder.integerConstant token.token
        else
          raise "Unknown token type"
        end
      end
    end

    result_xml
  end
end

TokenizeToXML.run ARGV[0]
