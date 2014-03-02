module Parser
  def self.parse lines=[]
    lines.map do |line|
      line.strip!

      case line
      when /^@/
        A.new(line)
      when %r{//}, /^$/
        Garbage.new(line)
      else
        C.new(line)
      end
    end.map(&:to_binary).compact
  end

  class A
    def initialize(line)
      @line = line
    end

    def to_binary
      @line[1..-1].to_i.to_s(2).rjust(16, "0")
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

  out = Parser.parse File.readlines(input_file)
  puts out
end
