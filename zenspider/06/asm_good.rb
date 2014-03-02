#!/usr/bin/env ruby -w

class Assembler
  def self.dict *keys
    Hash[keys.zip((0...keys.size).to_a)]
  end

  DEFAULTS = dict("R0", "R1", "R2",  "R3",  "R4",  "R5",  "R6",  "R7",
                  "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15")
  DEFAULTS["SCREEN"] = 0x4000
  DEFAULTS["KBD"]    = 0x6000
  DEFAULTS.merge! dict("SP", "LCL", "ARG", "THIS", "THAT") # aliases

  C_CMD_RE = /^(?!@)(?:([ADM]+)\s*=)?([^;\n]+)(?:;(J(?:GT|EQ|GE|LT|LE|NE|MP)))?$/

  attr_accessor :env, :n

  def self.run paths
    paths.each do |path|
      File.open path do |file|
        puts Assembler.new.assemble(file).join
      end
    end
  end

  def initialize
    self.env = DEFAULTS.dup
    self.n   = 15

    env.default_proc = proc { |h, k|
      next k if Integer === k # pass through literals
      self.n += 1
      h[k] = self.n
    }
  end

  def assemble io
    l = 0
    io.each_line.map { |line|
      case line.strip.sub(%r%\s*//.*%, '')
      when "" then
        next
      when /^\(([\w:.$-]+)\)$/ then
        env[$1] = l
        next
      when /^@([\w:.$-]+)$/ then
        l += 1
        label = $1
        label = label.to_i if label[/^\d+$/]
        A.new self.env, label
      when C_CMD_RE then
        l += 1
        dest, comp, jump = $1, $2, $3
        C.new comp.gsub(/\s+/, ""), dest, jump
      else
        raise "Unparsed: #{line.inspect}"
      end
    }
  end

  class A < Struct.new :env, :ref
    def to_s
      "0%015b\n" % env[ref]
    end
  end

  class C < Struct.new :code, :dest, :jump
    DEST = Assembler.dict nil, "M",   "D",   "MD",  "A",   "AM",  "AD",  "AMD"
    JUMP = Assembler.dict nil, "JGT", "JEQ", "JGE", "JLT", "JNE", "JLE", "JMP"
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

    def to_s
      c, d, j = COMP[code], DEST[dest], JUMP[jump]
      raise "no comp for #{code.inspect}" unless c
      raise "no dest for #{dest.inspect}" unless d
      raise "no jump for #{jump.inspect}" unless j
      "111%07b%03b%03b\n" % [c, d, j]
    end
  end
end

Assembler.run ARGV if $0 == __FILE__
