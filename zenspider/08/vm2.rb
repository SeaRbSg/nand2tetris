#!/usr/bin/env ruby -w

class String
  def number_instructions
    i = -1
    self.lines.map { |s|
      case s
      when /^\/\/\/+/ then
        "   #{s.chomp}"
      when /^\/\/ / then
        "\n#{s}"
      when /^\(/ then
        s.chomp
      else
        i += 1
        "%-21s // %d" % [s.chomp, i]
      end
    }.join "\n"
  end
end

class Compiler
  def self.run paths
    compiler = Compiler.new

    result = paths.map { |path|
      File.open path do |file|
        compiler.assemble file
      end
    }

    result.unshift Init.new if paths.size > 1

    puts postprocess result
  end

  def self.postprocess result
    result.flatten.compact.join("\n").gsub(/^(?![\/\(])/, '   ').number_instructions
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
      when /^label (\S+)$/ then
        Label.new $1
      when /^if-goto (\S+)$/ then
        IfGoto.new $1
      when /^goto (\S+)$/ then
        Goto.new $1
      when /^function (\S+) (\d+)$/ then
        Function.new $1, $2.to_i
      when /^call (\S+) (\d+)$/ then
        Call.new $1, $2.to_i
      when /^return$/ then
        Return.new
      else
        raise "Unparsed: #{line.inspect}"
      end
    }
  end

  module Asmable
    def asm *instructions
      instructions
    end

    def assemble(*instructions)
      instructions.flatten.compact.join "\n"
    end
  end

  module Stackable
    @@next_num = Hash.new 0

    def pop dest
      asm "@SP", "AM=M-1", "#{dest}=M"
    end

    def next_num name
      n = @@next_num[name] += 1
      "#{name}.#{n}"
    end

    def push_d deref = "AM=M+1", val="D"
      #   deref_sp      dec_ptr  write
      asm "@SP", deref, "A=A-1", "M=#{val}"
    end
  end

  module Operable
    def binary *instructions
      asm pop(:D), "A=A-1", "A=M", instructions
    end

    def unary *instructions
      asm "@SP", "A=M-1", *instructions
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

    def dereference name
      case offset
      when 0 then
        asm "@#{name}", "A=M"
      when 1 then
        asm "@#{name}", "A=M+1"
      else
        asm "@#{name}", "D=M", "@#{offset}", "A=A+D"
      end
    end

    def constant
      asm "@#{offset}"
    end

    def local
      dereference "LCL"
    end

    def argument
      dereference "ARG"
    end

    def this
      dereference "THIS"
    end

    def that
      dereference "THAT"
    end

    def temp
      asm "@R#{offset + 5}"
    end

    def static
      off = [ "@#{offset}", "A=A+D" ] if offset
      asm "@16", "D=A", off
    end

    def pointer
      off = "A=A+1" if offset != 0
      asm "@THIS", off
    end
  end

  class Init
    include Asmable

    def comment
      "// bootstrap"
    end

    def to_s
      assemble(comment,
               "/// SP = 256",
               "@256", "D=A", "@SP",  "M=D",

               "/// set THIS=THAT=LCL=ARG=-1 to force error if used as pointer",
               "@0", "D=-A",
               "@THIS", "M=D", "@THAT", "M=D", "@LCL", "M=D", "@ARG", "M=D",

               Call.new("Sys.init", 0),
               Label.new("FUCK_IT_BROKE"),
               Goto.new("FUCK_IT_BROKE"))
    end
  end

  class StackThingy < Struct.new :segment, :offset
    include Asmable
    include Stackable
    include Segmentable

    def comment
      asm "// #{name} #{segment} #{offset}"
    end
  end

  class Push < StackThingy
    def store
      asm segment == "constant" ? "D=A" : "D=M"
    end

    def to_s
      assemble(comment,
               send(segment),
               store,
               push_d)
    end
  end

  class Pop < StackThingy
    def temp_store reg
      asm reg, "M=D", yield, reg, "A=M"
    end

    def store
      asm "D=A"
    end

    def to_s
      assemble(comment,
               send(segment),
               store,
               temp_store("@R15") do
                 pop "D"
               end,
               asm("M=D"))
    end
  end

  class Op < Struct.new :msg
    include Asmable
    include Stackable
    include Operable

    def comment
      asm "// #{msg}"
    end

    def push_d
      super "A=M" unless %w[not neg].include? msg
    end

    def to_s
      assemble(comment,
               send(msg), # perform whatever operation, put into D
               push_d)
    end
  end

  class Label < Struct.new :name
    include Asmable

    def comment
      asm "// label #{name}"
    end

    def to_s
      assemble(comment,
               asm("(#{name})"))
    end
  end

  class IfGoto < Struct.new :name
    include Asmable
    include Stackable

    def to_s
      assemble pop(:D), "@#{name}", "D;JNE"
    end
  end

  class Goto < Struct.new :name
    include Asmable

    def comment
      "// goto @#{name}"
    end

    def to_s
      assemble comment, "@#{name}", "0;JMP"
    end
  end

  class Function < Struct.new :name, :size
    include Asmable
    include Stackable

    def comment
      asm "// function #{name} #{size}"
    end

    def push_locals
      case size
      when 0 then
      when 1, 2 then # 4n=5+2n == 2n=5 == n=2.5
        asm [push_d("AM=M+1", "0")] * size
      else
        asm "@#{size}", "D=A", "@SP", "AM=M+D", "A=A-D", ["M=0", "A=A+1"] * size
      end
    end

    def to_s
      assemble comment, "(#{name})", push_locals
    end
  end

  class Return
    include Asmable
    include Stackable

    def comment
      "// return"
    end

    def store_frame arg, off
      asm("/// #{arg} = *(FRAME-#{off})",
          "@#{off}", "D=A", "@R14", "A=M-D", "D=M", "@#{arg}", "M=D")
    end

    def to_s
      assemble(comment,
               "/// FRAME = LCL",
               "@LCL", "D=M", "@R14", "M=D",

               store_frame("13", 5),

               "/// *ARG = pop()",
               pop(:D), "@ARG", "A=M", "M=D",

               "/// SP = ARG+1",
               "@ARG", "D=M+1", "@SP", "M=D",

               store_frame("THAT", 1),
               store_frame("THIS", 2),
               store_frame("ARG", 3),
               store_frame("LCL", 4),

               "/// goto RET",
               "@R13", "A=M", "0;JMP"
      )
    end
  end

  class Call < Struct.new :name, :size
    include Asmable
    include Stackable

    def comment
      asm "// call #{name} #{size}"
    end

    def push name, loc="M"
      asm "/// push #{name}", name, "D=#{loc}", push_d
    end

    def set dest, *instructions
      asm instructions + [dest, "M=D"]
    end

    def to_s
      addr = next_num "return"
      assemble(comment,
               push("@#{addr}", "A"),
               push("@LCL"),
               push("@ARG"),
               push("@THIS"),
               push("@THAT"),
               set("@ARG", "/// ARG = SP-#{size}-5",
                   "@#{size + 5}", "D=A", "@SP", "D=M-D"),
               set("@LCL", "/// LCL = SP",
                   "@SP", "D=M"),
               "/// goto #{name}", "@#{name}", "0;JMP",
               "(#{addr})")
    end
  end
end

Compiler.run ARGV if $0 == __FILE__
