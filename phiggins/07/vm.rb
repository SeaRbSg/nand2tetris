class Parser
  def self.parse lines=[]
    lines = lines.map {|line| line.strip.sub(%r{\s*//.*$}, '') }
    lines.reject! {|line| line.empty? }

    new(lines).parse
  end

  def initialize lines=[]
    @lines = lines
  end

  def parse
    types = [PushConstant, Push, Pop, BinaryOp, ConditionOp, UnaryOp, UnknownInstruction]
    @lines.map do |line|
      types.detect {|t| t.match? line }.to_asm(line)
    end
  end

  class Instruction
    attr_reader :line
    def initialize line
      @line = line
    end

    def self.to_asm(line)
      new(line).to_asm
    end

    def decrement_stack_pointer
      %w[@SP M=M-1]
    end

    def increment_stack_pointer
      %w[@SP M=M+1]
    end

    def pop_stack
      decrement_stack_pointer + %w[@SP A=M D=M]
    end

    def push_stack
      %w[@SP A=M M=D] + increment_stack_pointer
    end

    def debug
      "// #{self.class} #{line}"
    end

    def to_asm
      [debug, asm].join("\n")
    end
  end

  class PushConstant < Instruction
    def self.match? line
      line =~ /^push constant/
    end

    def constant
      line[/(\d*)$/, 1]
    end

    def asm
      ["@#{constant}", "D=A", push_stack]
    end
  end

  class MemoryInstruction < Instruction
    attr_reader :segment, :index

    SEGMENTS = { "local" => "LCL", "argument" => "ARG", "this" => "THIS", "that" => "THAT", "static" => "static" }

    def initialize *args, &block
      super
      _, @segment, @index = *line.split
    end

    def store_segment_address(segment, index)
      if segment == "temp"
        <<-ASM
          @#{index.to_i + 5}
          D=A
          @R15
          M=D
        ASM
      elsif segment == "pointer"
        pointer = index == "0" ? "THIS" : "THAT"
        <<-ASM
          @#{pointer}
          D=A
          @R15
          M=D
        ASM
      else
        register = SEGMENTS[segment]
        <<-ASM
          @#{register}
          D=M
          @#{index}
          D=D+A
          @R15
          M=D
        ASM
      end
    end
  end

  class Push < MemoryInstruction
    def self.match? line
      line =~ /^push /
    end

    def asm
      [
        store_segment_address(segment, index),
        "@R15",
        "A=M",
        "D=M",
        "@SP",
        "A=M",
        "M=D",
        "@SP",
        "M=M+1",
      ]
    end
  end

  class Pop < MemoryInstruction
    def self.match? line
      line =~ /^pop /
    end

    def asm
      [
        store_segment_address(segment, index),
        "@SP",
        "M=M-1",
        "@SP",
        "A=M",
        "D=M",
        "@R15",
        "A=M",
        "M=D",
      ]
    end
  end

  class Op < Instruction
    def temp op, register="@R15"
      [register, op]
    end

    def to_asm
      [
        debug,
        pop_stack,
        asm,
        push_stack,
      ].join("\n")
    end
  end

  class BinaryOp < Op
    OPS = { "and" => "&", "or" => "|", "sub" => "-", "add" => "+" }
    MATCHES = OPS.keys

    def self.match? line
      MATCHES.include? line
    end

    def op
      OPS[line]
    end

    def asm
      [
        temp("M=D"),
        pop_stack,
        temp("D=D#{op}M"),
      ]
    end
  end

  class UnaryOp < Op
    OPS = { "neg" => "-", "not" => "!" }
    MATCHES = OPS.keys

    def self.match? line
      MATCHES.include? line
    end

    def op
      OPS[line]
    end

    def asm
      ["@SP", "A=M", "D=#{op}M"]
    end
  end

  class ConditionOp < Op
    OPS = { "eq" => "EQ", "lt" => "LT", "gt" => "GT" }
    MATCHES = OPS.keys

    def self.match? line
      MATCHES.include? line
    end

    def op
      OPS[line]
    end

    def index
      @index ||= begin
        @@condition_count ||= 0
        i = @@condition_count
        @@condition_count += 1
        i
      end
    end

    def label
      "#{op}.#{index}"
    end

    def end_label
      "#{op}end.#{index}"
    end

    def asm
      [
        temp("M=D"),
        pop_stack,
        temp("D=D-M"),
        "@#{label}",
        "D;J#{op}",
        "@SP",
        "A=M",
        "D=0",
        "@#{end_label}",
        "0;JMP",
        "(#{label})",
        "@SP",
        "A=M",
        "D=-1",
        "(#{end_label})",
      ]
    end
  end

  class UnknownInstruction < Instruction
    def self.match?
      true
    end

    def asm
    end
  end
end

if $0 == __FILE__
  input_file = ARGV.first

  abort "Usage: #{$0} vm_file" unless input_file

  out = Parser.parse File.readlines(input_file)
  puts out
end
