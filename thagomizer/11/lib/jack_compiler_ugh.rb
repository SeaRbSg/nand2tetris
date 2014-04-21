#!/usr/bin/env ruby -w

require_relative 'jack_tokenizer'
require_relative 'compilation_engine'
require_relative 'symbol_table'
require_relative 'vm_writer'
require 'pp'

class JackCompiler
  attr_accessor :path, :prefix, :vm_writer, :symbol_table

  def initialize(path = "")
    @path = path
    @vm_writer = VmWriter.new
    @symbol_table = SymbolTable.new
  end

  def compile
    tokenizer = JackTokenizer.from_file(@path)
    tokenizer.advance
    compilation_engine = CompilationEngine.new tokenizer
    ast = compilation_engine.compile_class
    generate_vm_code(ast)
  end

  def generate_vm_code(ast)
    return if ast.empty?

    case ast[0]
    when :class
      compile_class(ast[1..-1])
    else
      raise "BOOM generate_vm_code #{ast}"
    end
  end

  def compile_class(ast)
    # ast[0] is [keyword, class]
    # ast[1] is [identifier, className]
    # ast[2] is [symbol, {]
    @prefix = ast[1][1]

    index = 3
    while true do
      case
        # when :class_var_dec
        #   # TODO
      when ast[index][0] == :subroutine_dec
        compile_subroutine_dec ast[index][1..-1]
      when ast[index] == [:symbol, "}"]
        break
      else
        raise "BOOM compile_class #{ast[index]}"
      end
      index += 1
    end
  end

  def compile_subroutine_dec ast
    # ast[0] is [keyword, function]
    # ast[1] is a terminal for return type
    # ast[2] is [identifier, subroutine_name]
    subroutine_name = "#{@prefix}.#{ast[2][1]}"

    # ast[3] is [symbol, (]
    # ast[4] is [parameter_list]
    # TODO compile_parameter_list ast[3]

    # ast[5] is [symbol, )]

    # TODO count the number of locals
    num_locals = 0

    @vm_writer.write_function(subroutine_name, num_locals)

    while true do

    end
  end

  def compile_subroutine_body ast
    # ast[0] is [symbol, {]

    index = 1
    while true do
      case
      when :foo
      else
        raise "BOOM compile_subroutine_body #{ast[index]}"
      end
      index += 1
    end
  end

  def output
    @vm_writer.output.string
  end
end

ARGV.each do |path|
  paths = []
  if File.directory?(path)
    Dir.entries(path).each do |entry|
      paths << "#{path}/#{entry}" if entry =~ /jack$/
    end
  else
    paths << path
  end

  paths.each do |p|
    compiler = JackCompiler.new(p)

    compiler.compile

    File.open(p.gsub(".jack", ".vm"), "w") do |f|
      f.write compiler.output
    end
  end
end
