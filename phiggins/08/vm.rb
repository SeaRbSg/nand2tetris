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
    @lines.map do |line|
      INSTRUCTIONS.detect {|t| t.match? line }.to_asm(line)
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

    def pop_stack
      %w[@SP M=M-1 @SP A=M D=M]
    end

    def push_stack
      %w[@SP A=M M=D @SP M=M+1]
    end

    def debug info=line
      "// #{self.class} #{info}"
    end

    def to_asm
      [debug, asm].join("\n")
    end
  end

  class Call < Instruction
    REGEXP = /^call ([^ ]*) (\d+)$/

    def self.match? line
      line =~ REGEXP
    end

    def name
      line.match(REGEXP)[1]
    end

    def args
      line.match(REGEXP)[2].to_i
    end

    def index
      @index ||= begin
        @@index ||= 0
        i = @@index
        @@index += 1
        i
      end
    end

    def asm
      return_label = "CALL.#{index}"

      [
        "@#{return_label}", "D=A", push_stack,

        ["LCL", "ARG", "THIS", "THAT"].map { |r|
          ["@#{r}", "D=M", push_stack]
        },

        "@SP",
        "D=M",
        "@5",
        "D=D-A",
        "@#{args}",
        "D=D-A",
        "@ARG",
        "M=D",

        "@SP",
        "D=M",
        "@LCL",
        "M=D",

        "@#{name}",
        "0;JMP",

        "(#{return_label})",
      ]
    end
  end

  class Function < Instruction
    REGEXP = /^function ([^ ]*) (\d+)$/

    def self.match? line
      line =~ REGEXP
    end

    def name
      line.match(REGEXP)[1]
    end

    def args
      line.match(REGEXP)[2].to_i
    end

    def asm
      [
        "(#{name})",
        args.times.map { ["@0", "D=A", push_stack] },
      ]
    end
  end

  class Return < Instruction
    def self.match? line
      line =~ /^return$/
    end

    def asm
      [
        "@LCL", # Store LCL
        "D=M",
        "@R13",
        "M=D",

        pop_stack,
        "@ARG",
        "A=M",
        "M=D",

        "@ARG", # Set SP = ARG+1
        "D=M",
        "D=D+1",
        "@SP",
        "M=D",

        %w[THAT THIS ARG LCL].map { |r|
          [
            "@R13",
            "M=M-1",
            "@R13",
            "A=M",
            "D=M",
            "@#{r}",
            "M=D",
          ]
        },
        "@R13",
        "M=M-1",
        "@R13",
        "A=M",
        "A=M",
        "0;JMP",
      ]
    end
  end

  class Goto < Instruction
    REGEXP = /^goto (.*)$/

    def self.match? line
      line =~ REGEXP
    end

    def label
      line[REGEXP, 1]
    end

    def asm
      ["@#{label}", "0;JMP"]
    end
  end

  class IfGoto < Instruction
    REGEXP = /^if-goto (.*)$/

    def self.match? line
      line =~ REGEXP
    end

    def label
      line[REGEXP, 1]
    end

    def asm
      [
        pop_stack,
        "@#{label}",
        "D;JNE"
      ]
    end
  end

  class Label < Instruction
    REGEXP = /^label (.*)$/

    def self.match? line
      line =~ REGEXP
    end

    def label
      line[REGEXP, 1]
    end

    def asm
      "(#{label})"
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

    def store_segment_address
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
        store_segment_address,
        "@R15",
        "A=M",
        "D=M",
        push_stack,
      ]
    end
  end

  class Pop < MemoryInstruction
    def self.match? line
      line =~ /^pop /
    end

    def asm
      [
        store_segment_address,
        pop_stack,
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
    def self.match? *_
      true
    end

    def asm
    end
  end

  INSTRUCTIONS = [
    Call,
    Function,
    Return,
    Goto,
    IfGoto,
    Label,
    PushConstant,
    Push,
    Pop,
    BinaryOp,
    ConditionOp,
    UnaryOp,
    UnknownInstruction,
  ]
end

if $0 == __FILE__
  input = ARGV.first

  unless input && File.exists?(input)
    abort "Usage: #{$0} input"
  end

  files = Dir[File.join(input, "*.vm")]

  case files.size
  when 0
    abort "No *.vm files found in #{input}"
  when 1
    puts Parser.parse File.readlines(files.first)
  else
    puts [
      ["@256", "D=A", "@SP", "M=D"],
      Parser.parse(["call Sys.init 0"]),
      Dir[File.join(input, "*.vm")].map {|f| Parser.parse File.readlines(f) },
    ].join("\n")
  end
end
