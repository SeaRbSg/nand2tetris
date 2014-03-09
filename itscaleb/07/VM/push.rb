class Push
  def initialize segment, index
    @segment = segment
    @index = index
  end

  def to_asm
    asm = []
    asm << "@#@index"
    asm << "D=A"
    Push.push_d asm
  end

  def self.push_d asm
    asm << "@SP"
    asm << "A=M"
    asm << "M=D"
    asm << "@SP"
    asm << "M=M+1"
  end
end
