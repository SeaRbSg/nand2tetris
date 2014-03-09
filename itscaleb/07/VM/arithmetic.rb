require_relative 'push'

class Arithmetic
  def self.add
    asm = Arithmetic.op "D=D+A"
  end

  def self.sub
    asm = Arithmetic.op "D=A-D"
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

    Push.push_d asm
  end
end
