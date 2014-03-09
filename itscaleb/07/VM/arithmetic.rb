require_relative 'push'

class Arithmetic
  def self.add
    asm = []
    asm <<  "@SP"
    asm <<  "AM=M-1"
    asm <<  "D=M"
    asm <<  "@SP"
    asm <<  "AM=M-1"
    asm <<  "A=M"
    asm <<  "D=D+A"

    Push.push_d asm
  end
end
