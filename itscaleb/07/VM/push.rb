class Push

  @@segment = {
    "local" => "@LCL",
    "argument" => "@ARG",
    "this" => "@THIS",
    "that" => "@THAT",
  }

  def initialize segment, index
    @segment = segment
    @index = index
  end

  def to_asm
    asm = []
    case @segment
    when "constant"
      asm << "@#@index"
      asm << "D=A"
    when "local", "argument", "this", "that"
      asm << "@#@index"
      asm << "D=A"
      asm << @@segment[@segment]
      asm << "A=D+M"
      asm << "D=M"
    when "temp"
      asm << "@#{5 + @index}"
      asm << "D=M"
    end
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
