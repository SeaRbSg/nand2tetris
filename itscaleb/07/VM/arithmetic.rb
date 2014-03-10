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
    Arithmetic.cmp asm "D;JEQ"
    Push.push_d asm
  end

  def self.cmp asm cmp
    asm <<  "@TRUE"
    asm <<  cmp
    asm <<  "D=0"
    asm <<  "@END"
    asm <<  "0;JMP"
    asm <<  "(TRUE)"
    asm <<  "D=-1"
    asm <<  "(END)"
  end

  def self.lt
    asm = Arithmetic.op "D=A-D"
    Arithmetic.cmp asm "D;JLT"
    Push.push_d asm
  end

  def self.gt
    asm = Arithmetic.op "D=A-D"
    Arithmetic.cmp asm "D;JGT"
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
