class Push

  @@segment = {
    "local" => "@LCL",
    "argument" => "@ARG",
    "this" => "@THIS",
    "that" => "@THAT",
  }

  def initialize segment, index, file
    @segment = segment
    @index = index
    @file = file
    @asm = []
  end

  def to_asm
    case @segment
    when "constant"
      @asm << "@#@index"
      @asm << "D=A"
    when "local", "argument", "this", "that"
      @asm << "@#@index"
      @asm << "D=A"
      @asm << @@segment[@segment]
      @asm << "A=D+M"
      @asm << "D=M"
    when "temp"
      @asm << "@#{5 + @index}"
      @asm << "D=M"
    when "pointer"
      @asm << "@#{3 + @index}"
      @asm << "D=M"
    when "static"
      @asm << "@#{@file}.#{@index}"
      @asm << "D=M"
    end
    Push.push_d @asm
  end

  def self.push_d asm
    asm << "@SP"
    asm << "A=M"
    asm << "M=D"
    asm << "@SP"
    asm << "M=M+1"
  end
end
