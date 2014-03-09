#!/usr/bin/env ruby -w

class String
  def number_instructions
    i = -1
    self.lines.map { |s|
      if s =~ /^\// then
        "\n#{s}"
      else
        i += 1
        "%-21s // %d" % [s.chomp, i]
      end
    }.join "\n"
  end
end

class Compiler
  def self.run paths
    paths.each do |path|
      File.open path do |file|
        puts postprocess Compiler.new.assemble file
      end
    end
  end

  def self.postprocess result
    result.flatten.compact.join("\n").gsub(/^(?!\/)/, '   ').number_instructions
  end

  def initialize
  end

  SEGMENTS = %w(argument local static constant this that pointer temp).join "|"
  OPS      = %w(add sub neg eq gt lt and or not).join "|"

  def assemble io
    io.each_line.map { |line|
      case line.strip.sub(%r%\s*//.*%, '')
      when "" then
        nil
      when /^push (#{SEGMENTS}) (\d+)/ then
        Push.new $1, $2.to_i
      when /^pop (#{SEGMENTS}) (\d+)/ then
        Pop.new $1, $2.to_i
      when /^(#{OPS})$/ then
        Op.new $1
      else
        raise "Unparsed: #{line.inspect}"
      end
    }
  end

  module Stackable
    @@next_num = Hash.new 0

    def next_num name
      n = @@next_num[name] += 1
      "#{name}.#{n}"
    end

    def push_d deref = "AM=M+1"
      # deref_sp      dec_ptr  write
      [ "@SP", deref, "A=A-1", "M=D" ]
    end

    def peek
      [ "@SP", "AM=M-1", "D=M" ]
    end
  end

  module Operable
    def pop dest
      [ "@SP", "AM=M-1", "#{dest}=M" ]
    end

    def peek dest
      [ "A=A-1", "#{dest}=M"]
    end

    def binary *instructions
      [ pop(:D), peek(:A), *instructions ]
    end

    def unary *instructions
      [ "@SP", "A=M-1", *instructions ]
    end

    def binary_test test
      addr = next_num test
      binary("D=A-D",
             "@#{addr}",
             "D;#{test}",
             "D=0",
             "@#{addr}.done",
             "0;JMP",
             "(#{addr})",
             "D=-1",
             "(#{addr}.done)")
    end

    def neg; unary "M=-M";      end
    def not; unary "M=!M";      end

    def add; binary "D=A+D";    end
    def and; binary "D=A&D";    end
    def or;  binary "D=A|D";    end
    def sub; binary "D=A-D";    end

    def eq;  binary_test "JEQ"; end
    def gt;  binary_test "JGT"; end
    def lt;  binary_test "JLT"; end
  end

  module Segmentable
    def name
      self.class.name.split(/::/).last.downcase
    end

    def dereference name, deref2
      a =
      case offset
      when 0 then
        [
         "@#{name}",
         "A=M",
        ]
      when 1 then
        [
         "@#{name}",
         "A=M+1",
        ]
      else
        [
         "@#{name}",
         "D=M",
         "@#{offset}",
         "A=A+D",
        ]
      end
      a << (deref2 ? "D=M" : "D=A")
      a
    end

    def constant _ = false
      [ "@#{offset}", "D=A" ]
    end

    def local deref = false
      dereference "LCL", deref
    end

    def argument deref = false
      dereference "ARG", deref
    end

    def this deref = false
      dereference "THIS", deref
    end

    def that deref = false
      dereference "THAT", deref
    end

    def temp deref = false
      a_m  = deref ? "M" : "A"
      off = offset + 5
      [ "@R#{off}", "D=#{a_m}" ]
    end

    def static deref = false
      a_m = deref ? "M" : "A"
      off = offset ? [ "@#{offset}", "A=A+D" ] : nil
      [ "@16", "D=A", off, "D=#{a_m}" ].compact.flatten
    end

    def pointer deref = false
      a_m  = deref ? "M" : "A"
      off = offset == 0 ? nil : "A=A+1"
      [ "@THIS", off, "D=#{a_m}" ].compact
    end
  end

  class StackThingy < Struct.new :segment, :offset
    include Stackable
    include Segmentable

    def comment
      "// #{name} #{segment} #{offset}"
    end
  end

  class Push < StackThingy
    def to_s
      [
       comment,
       send(segment, :double),
       push_d,
       ].join "\n"
    end
  end

  class Pop < StackThingy
    def temp_store reg
      [
       reg,
       "M=D",
       yield,
       reg,
       "A=M",
      ]
    end

    def to_s
      [
       comment,
       send(segment),
       temp_store("@R15") do
         peek
       end,
       "M=D",
      ].join "\n"
    end
  end

  class Op < Struct.new :msg
    include Stackable
    include Operable

    def comment
      "// #{msg}"
    end

    def push_d
      super("A=M") unless %w[not neg].include? msg
    end

    def to_s
      [
       comment,
       send(self.msg),  # perform whatever operation, put into D
       push_d,
       ].join "\n"
    end
  end
end

Compiler.run ARGV if $0 == __FILE__
