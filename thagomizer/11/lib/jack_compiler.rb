#!/usr/bin/env ruby -w

require_relative 'jack_tokenizer'
require_relative 'compilation_engine_ast'
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
    compilation_engine = CompilationEngineAst.new tokenizer
    ast = compilation_engine.compile_class
    generate_vm_code(ast)
  end

  def generate_vm_code(ast)
    return if ast.empty?

    case ast[0]
    when :class
      compile_class ast
    else
      raise "BOOM generate_vm_code #{ast}"
    end
  end

  def compile_class(ast)
    ast.shift # get rid of :class
    ast.shift # get rid of [keyword, class]

    # ast[1] is [identifier, className]
    @prefix = ast[1][1]
    ast.shift

    ast.shift # get rid of [symbol, {]

    ast.each do |term|
      case
      when term[0] == :subroutine_dec
      else
        raise "BOOM compile_class #{ast[index]}"
      end
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

    compile_subroutine_body ast[6]
  end

  def compile_subroutine_body ast
    ast.shift # get rid of :subroutine_body
    ast.shift # get rid of [symbol, {]

    ast.each do |term|
      case term[0]
      when :statements
        compile_statements term
      else
        raise term.inspect
      end
    end
  end

  def compile_statements ast
    ast.shift # get rid of :statements

    ast.each do |statement|
      case statement[0]
      when :do_statement
        compile_do statement
      else
        raise statement.inspect
      end
    end
  end

  def compile_do ast
    ast.shift # get rid of :do_statement
    ast.shift # get rid of :do

    compile_subroutine_call ast
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
