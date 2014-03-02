#!/usr/bin/env ruby -s

require "strscan"

##
# This is the hack assembler written the way that the book specs it,
# even tho I think it is suboptimal. I've changed all the naming to be
# idiomatic ruby.

class Parser
  C_CMD_RE = /^(?!@)(?:([ADM]+)\s*=)?([^;\n]+)(?:;(J(?:GT|EQ|GE|LT|LE|NE|MP)))?$/

  attr_accessor :ss, :cur, :type, :st, :n

  def self.run paths
    paths.each do |path|
      # warn "Processing #{path}"

      asm = Parser.new path
      code = Code.new

      while asm.has_more_commands?
        asm.advance

        case asm.command_type
        when :A_COMMAND then
          val = asm.cur[1..-1]

          if val =~ /[a-z]/i then
            unless asm.st.contains val
              asm.n += 1
              asm.st.add_entry val, asm.n
            end

            val = asm.st.get_address val
          end

          puts "0%015b\n" % val.to_i
        when :L_COMMAND then
          # do nothing
        when :C_COMMAND then
          c = code.comp asm.comp
          d = code.dest asm.dest
          j = code.jump asm.jump
          puts "111%07b%03b%03b\n" % [c, d, j]
        else
          raise "bork: #{asm.command_type}"
        end
      end
    end
  end

  def initialize path_or_strscanner
    self.cur = self.type = nil
    self.ss = path_or_strscanner
    self.ss = StringScanner.new File.read ss unless StringScanner === ss
    self.st = SymbolTable.new
    self.n  = 15

    # sweet jesus this is cheating and I don't care
    self.ss.string = self.ss.string.gsub(%r%\s*//.*%, "").gsub(%r%\n\n+%, "\n")

    scan_for_symbols
  end

  def scan_for_symbols # this feels so dirty
    i = -1
    asm = self
    while asm.has_more_commands?
      i += 1
      asm.advance

      case asm.command_type
      when :A_COMMAND then
        # do nothing
      when :L_COMMAND then
        name = ss.matched[1..-2]
        st.add_entry name, i
        i -= 1 # pseudocode doesn't have a real line
      when :C_COMMAND then
        # do nothing
      else
        raise "bork: #{asm.command_type}"
      end
    end

    self.ss.pos = 0
  end

  def has_more_commands? # => bool
    while ss.skip(%r%\s*//.*\n%)
      # do nothing
    end
    ss.skip(/\n*\s+/)
    ss.check(/[(@ADM0]/)
  end

  def advance
    raise "No more commands" unless has_more_commands?

    case
    when ss.scan(/^\(([\w:.$-]+)\)$/) then
      self.type, self.cur = :L_COMMAND, ss.matched
    when ss.scan(/^@([\w:.$-]+)$/) then
      self.type, self.cur = :A_COMMAND, ss.matched
    when ss.scan(C_CMD_RE) then
      self.type, self.cur = :C_COMMAND, [ss[1], ss[2], ss[3]]
    else
      raise "Parse Error: #{ss.rest}"
    end

    nil
  end

  def command_type # => :A_COMMAND, :C_COMMAND, :L_COMMAND
    self.type
  end

  def symbol # => string
    raise unless command_type != :C_COMMAND

    self.cur
  end

  def dest # => string
    raise unless command_type == :C_COMMAND

    self.cur[0]
  end

  def comp # => string
    raise unless command_type == :C_COMMAND

    self.cur[1]
  end

  def jump # => string
    raise unless command_type == :C_COMMAND

    self.cur[2]
  end
end

class Code
  def self.build *keys
    r = {}

    keys.each_with_index do |key, i|
      r[key] = i
    end
    r
  end

  DEST = build nil, "M", "D", "MD", "A", "AM", "AD", "AMD"

  def dest s # => 3 bits
    DEST[s]
  end

  COMP = {# a=0 (A's)         a=1 (M's)
          "0"   => 0b0101010,
          "1"   => 0b0111111,
          "-1"  => 0b0111010,
          "D"   => 0b0001100,
          "A"   => 0b0110000, "M"   => 0b1110000,
          "!D"  => 0b0001101,
          "!A"  => 0b0110001, "!M"  => 0b1110001,
          "-D"  => 0b0001111,
          "-A"  => 0b0110011, "-M"  => 0b1110011,
          "D+1" => 0b0011111,
          "A+1" => 0b0110111, "M+1" => 0b1110111,
          "D-1" => 0b0001110,
          "A-1" => 0b0110010, "M-1" => 0b1110010,
          "D+A" => 0b0000010, "D+M" => 0b1000010,
          "D-A" => 0b0010011, "D-M" => 0b1010011,
          "A-D" => 0b0000111, "M-D" => 0b1000111,
          "D&A" => 0b0000000, "D&M" => 0b1000000,
          "D|A" => 0b0010101, "D|M" => 0b1010101,
         }

  def comp s # => 7 bits
    COMP[s]
  end

  JUMP = build nil, "JGT", "JEQ", "JGE", "JLT", "JNE", "JLE", "JMP"

  def jump s # => 3 bits
    JUMP[s]
  end
end

class SymbolTable
  attr_accessor :h

  DEFAULTS = Code.build("R0", "R1", "R2",  "R3",  "R4",  "R5",  "R6",  "R7",
                        "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15")
  DEFAULTS["SCREEN"] = 0x4000
  DEFAULTS["KBD"]    = 0x6000
  DEFAULTS.merge! Code.build("SP", "LCL", "ARG", "THIS", "THAT") # aliases

  def initialize
    self.h = DEFAULTS.dup
  end

  def add_entry symbol, address
    h[symbol] = address
  end

  def contains symbol # => bool
    h.has_key? symbol
  end

  def get_address symbol # => int
    h[symbol]
  end
end

if $0 == __FILE__ then
  $t ||= false

  # gem "minitest"
  # require "minitest/autorun" if $t
  #
  # describe Parser do
  #   describe :has_more_commands? do
  #     it "identifies when we have more commands" do
  #       asm = Parser.new "Prog.asm"
  #       assert asm.has_more_commands?
  #     end
  #
  #     it "knows when we're done" do
  #       asm = Parser.new StringScanner.new("")
  #       refute asm.has_more_commands?
  #     end
  #   end
  #
  #   describe :advance do
  #     it "works across a file" do
  #       asm = Parser.new "Prog.asm"
  #       assert asm.has_more_commands?
  #
  #       assert_nil asm.advance
  #       assert_nil asm.advance
  #       assert_nil asm.advance
  #       assert_nil asm.advance
  #       assert_nil asm.advance
  #     end
  #   end
  #
  #   describe :command_type do
  #     it "works" do
  #       asm = Parser.new "Prog.asm"
  #
  #       assert_nil asm.advance
  #       assert_equal :A_COMMAND, asm.command_type
  #
  #       assert_nil asm.advance
  #       assert_equal :C_COMMAND, asm.command_type
  #
  #       assert_nil asm.advance
  #       assert_nil asm.advance
  #       assert_nil asm.advance
  #       assert_equal :L_COMMAND, asm.command_type
  #     end
  #   end
  #
  #   def assert_cmd expected, cmd, input
  #     asm = Parser.new StringScanner.new input
  #     assert_nil asm.advance
  #     assert_equal expected, asm.send(cmd)
  #   end
  #
  #   def assert_cmd_bad cmd, input
  #     asm = Parser.new StringScanner.new input
  #     assert_nil asm.advance
  #     assert_raises RuntimeError do
  #       asm.send(cmd)
  #     end
  #   end
  #
  #   describe :symbol do
  #     it "works for a number" do
  #       assert_cmd "@42", :symbol, "@42"
  #     end
  #
  #     it "works for symbol" do
  #       assert_cmd "@woot", :symbol, "@woot"
  #     end
  #
  #     it "fails on C_COMMAND" do
  #       assert_cmd_bad :symbol, "D=M"
  #     end
  #   end
  #
  #   describe :dest do
  #     it "works for things with dest" do
  #       assert_cmd "A", :dest, "A=M"
  #     end
  #
  #     it "is nil for things w/o dest" do
  #       assert_cmd nil, :dest, "M"
  #     end
  #
  #     it "fails, otherwise" do
  #       assert_cmd_bad :dest, "@42"
  #     end
  #   end
  #
  #   describe :comp do
  #     it "works" do
  #       assert_cmd "M", :comp, "A=M"
  #     end
  #
  #     it "fails, otherwise" do
  #       assert_cmd_bad :comp, "@42"
  #     end
  #   end
  #
  #   describe :jump do
  #     it "works for jumps" do
  #       assert_cmd "JMP", :jump, "0;JMP"
  #     end
  #
  #     it "is nil for non-jumps" do
  #       assert_cmd nil, :jump, "A=0"
  #     end
  #
  #     it "fails, otherwise" do
  #       assert_cmd_bad :jump, "@42"
  #     end
  #   end
  # end if $t
  #
  # describe Code do
  #   describe :dest do
  #     it "works" do
  #       code = Code.new
  #
  #       assert_equal 0b000, code.dest(nil)
  #       assert_equal 0b001, code.dest("M")
  #       assert_equal 0b010, code.dest("D")
  #       assert_equal 0b011, code.dest("MD")
  #       assert_equal 0b100, code.dest("A")
  #       assert_equal 0b101, code.dest("AM")
  #       assert_equal 0b110, code.dest("AD")
  #       assert_equal 0b111, code.dest("AMD")
  #     end
  #   end
  #
  #   describe :comp do
  #     it "works" do
  #       code = Code.new
  #
  #       assert_equal 0b0000000, code.comp("D&A"), "D&A"
  #       assert_equal 0b0000010, code.comp("D+A"), "D+A"
  #       assert_equal 0b0000111, code.comp("A-D"), "A-D"
  #       assert_equal 0b0001100, code.comp("D"),   "D"
  #       assert_equal 0b0001101, code.comp("!D"),  "!D"
  #       assert_equal 0b0001110, code.comp("D-1"), "D-1"
  #       assert_equal 0b0001111, code.comp("-D"),  "-D"
  #       assert_equal 0b0010011, code.comp("D-A"), "D-A"
  #       assert_equal 0b0010101, code.comp("D|A"), "D|A"
  #       assert_equal 0b0011111, code.comp("D+1"), "D+1"
  #       assert_equal 0b0101010, code.comp("0"),   "0"
  #       assert_equal 0b0110000, code.comp("A"),   "A"
  #       assert_equal 0b0110001, code.comp("!A"),  "!A"
  #       assert_equal 0b0110010, code.comp("A-1"), "A-1"
  #       assert_equal 0b0110011, code.comp("-A"),  "-A"
  #       assert_equal 0b0110111, code.comp("A+1"), "A+1"
  #       assert_equal 0b0111010, code.comp("-1"),  "-1"
  #       assert_equal 0b0111111, code.comp("1"),   "1"
  #       assert_equal 0b1000000, code.comp("D&M"), "D&M"
  #       assert_equal 0b1000010, code.comp("D+M"), "D+M"
  #       assert_equal 0b1000111, code.comp("M-D"), "M-D"
  #       assert_equal 0b1010011, code.comp("D-M"), "D-M"
  #       assert_equal 0b1010101, code.comp("D|M"), "D|M"
  #       assert_equal 0b1110000, code.comp("M"),   "M"
  #       assert_equal 0b1110001, code.comp("!M"),  "!M"
  #       assert_equal 0b1110010, code.comp("M-1"), "M-1"
  #       assert_equal 0b1110011, code.comp("-M"),  "-M"
  #       assert_equal 0b1110111, code.comp("M+1"), "M+1"
  #     end
  #   end
  #
  #   describe :jump do
  #     it "works" do
  #       code = Code.new
  #
  #       assert_equal 0b000, code.jump(nil)
  #       assert_equal 0b001, code.jump("JGT")
  #       assert_equal 0b010, code.jump("JEQ")
  #       assert_equal 0b011, code.jump("JGE")
  #       assert_equal 0b100, code.jump("JLT")
  #       assert_equal 0b101, code.jump("JNE")
  #       assert_equal 0b110, code.jump("JLE")
  #       assert_equal 0b111, code.jump("JMP")
  #     end
  #   end
  # end if $t
  #
  # describe SymbolTable do
  #   attr_accessor :s
  #
  #   def setup
  #     self.s = SymbolTable.new
  #   end
  #
  #   describe :add_entry do
  #     it "works" do
  #       s.add_entry "WOOT", 999
  #       assert_equal 999, s.get_address("WOOT")
  #     end
  #   end
  #
  #   describe :contains do
  #     it "works" do
  #       assert_equal true, s.contains("R1")
  #       assert_equal false, s.contains("WOOT")
  #     end
  #   end
  #
  #   describe :get_address do
  #     it "works" do
  #       assert_equal 1, s.get_address("R1")
  #     end
  #   end
  # end if $t

  Parser.run ARGV
end
