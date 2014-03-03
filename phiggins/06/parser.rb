class Assembler
  def self.assemble lines=[]
    lines = lines.map {|line| line.strip.sub(%r{\s+//.*$}, '') }

    new(lines).assemble
  end

  def initialize lines=[]
    @lines = lines
    @line_count = 0
  end

  def symbol_table
    @__symbol_table ||= begin
      symbol_table = {
        "SP"      => 0,
        "LCL"     => 1,
        "ARG"     => 2,
        "THIS"    => 3,
        "THAT"    => 4,
        "R0"      => 0,
        "R1"      => 1,
        "R2"      => 2,
        "R3"      => 3,
        "R4"      => 4,
        "R5"      => 5,
        "R6"      => 6,
        "R7"      => 7,
        "R8"      => 8,
        "R9"      => 9,
        "R10"     => 10,
        "R11"     => 11,
        "R12"     => 12,
        "R13"     => 13,
        "R14"     => 14,
        "R15"     => 15,
        "SCREEN"  => 16384,
        "KBD"     => 24576,
      }

      symbol_count = 15
      symbol_table.default_proc = lambda do |hash, symbol|
        if symbol =~ /^\d+$/
          symbol
        else
          symbol_count += 1
          hash[symbol] = symbol_count
        end
      end

      symbol_table
    end
  end

  def assemble
    Parser.parse @lines do |p|
      p.on_a { @line_count += 1 }
      p.on_c { @line_count += 1 }
      p.on_label {|line| symbol_table[line[1..-2]] = @line_count }
    end

    assembled = []
    Parser.parse @lines do |p|
      p.on_c {|line| assembled << C.new(line) }
      p.on_garbage {|line| assembled << Garbage.new(line) }

      p.on_a do |line|
        value = symbol_table[line[1..-1]]

        assembled << A.new(value)
      end
    end
    assembled.map(&:to_binary).compact
  end

  class Parser
    def self.parse lines=[], &block
      new(lines, &block).parse
    end

    def initialize lines=[]
      @lines = lines
      @on_a = []
      @on_c = []
      @on_garbage = []
      @on_label = []
      @on_line = []
      yield(self) if block_given?
    end

    def on_a &block       ; @on_a << block ; end
    def on_c &block       ; @on_c << block ; end
    def on_garbage &block ; @on_garbage << block ; end
    def on_label &block   ; @on_label << block ; end
    def on_line &block    ; @on_line << block ; end

    def parse
      @lines.each do |line|
        @on_line.each {|b| b.call(line) }

        case line
        when /^\(.*\)$/   then  @on_label.each {|b| b.call(line) }
        when /^@/         then  @on_a.each {|b| b.call(line) }
        when %r{//}, /^$/ then  @on_garbage.each {|b| b.call(line) }
        else
          @on_c.each {|b| b.call(line) }
        end
      end
    end
  end

  class A
    def initialize(value)
      @value = value
    end

    def to_binary
      @value.to_i.to_s(2).rjust(16, "0")
    end
  end

  class C
    def initialize(line)
      @line = line
    end

    def parse!
      regexp = /(?:([^=]*)=)?([^;]*)(?:;(.*))?/
      _, @dest, @comp, @jump = *regexp.match(@line)
    end

    def dest
      %w[A D M].map {|l| @dest =~ /#{l}/ ? 1 : 0 }.join
    end

    JUMPS = {
      nil   => "000",
      "JGT" => "001",
      "JEQ" => "010",
      "JGE" => "011",
      "JLT" => "100",
      "JNE" => "101",
      "JLE" => "110",
      "JMP" => "111",
    }

    def jump
      JUMPS.fetch(@jump) { raise "Unrecognized jump.#{debug}" }
    end

    def comp
      a = @comp =~ /M/ ? 1 : 0

      c = case @comp
      when "0"        then "101010"
      when "1"        then "111111"
      when "-1"       then "111010"
      when "D"        then "001100"
      when /^[A,M]$/  then "110000"
      when "!D"       then "001101"
      when /![A,M]/   then "110001"
      when /^-[A,M]/  then "110011"
      when "D+1"      then "011111"
      when /[A,M]\+1/ then "110111"
      when "D-1"      then "001110"
      when /[A,M]-1/  then "110010"
      when /D\+[A,M]/ then "000010"
      when /D-[A,M]/  then "010011"
      when /[A,M]-D/  then "000111"
      when /D&[A,M]/  then "000000"
      when /D\|[A,M]/ then "010101"
      else
        raise "Unrecognized comp.#{debug}"
      end

      [a, c].join
    end

    def to_binary preface="111"
      parse!

      [preface, comp, dest, jump].join
    end

    def debug
      ["", :line, @line, :dest, @dest, :comp, @comp, :jump, @jump].join("\n")
    end
  end

  class Garbage
    def initialize(line)
      @line = line
    end

    def to_binary
      #"garbage: #{@line}"
    end
  end
end

if $0 == __FILE__
  input_file = ARGV.first

  abort "Usage: #{$0} asm_file" unless input_file

  out = Assembler.assemble File.readlines(input_file)
  puts out
end
