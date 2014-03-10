require_relative 'push'

class Arithmetic
  def self.add
    asm = Arithmetic.op "D=D+A"
    Push.push_d asm
  end

  def self.sub
    asm = Arithmetic.op "D=A-D"
    Push.push_d asm
  end

  def self.eq
    asm = Arithmetic.op "D=A-D"
    asm <<  "@EQ"
    asm <<  "D;JEQ"
    asm <<  "D=0"
    asm <<  "@END"
    asm <<  "0;JMP"
    asm <<  "(EQ)"
    asm <<  "D=-1"
    asm <<  "(END)"
    Push.push_d asm
  end

  def self.op op
    asm = []
    asm <<  "@SP"
    asm <<  "AM=M-1"
    asm <<  "D=M"
    asm <<  "@SP"
    asm <<  "AM=M-1"
    asm <<  "A=M"
    asm <<  op
  end
end
