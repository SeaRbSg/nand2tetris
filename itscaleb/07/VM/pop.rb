class Pop

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
    when "local", "argument", "this", "that"
      # calculate the memory location
      # and store it in @R13
      @asm << "@#@index"
      @asm << "D=A"
      @asm << @@segment[@segment]
      @asm << "D=D+M"
      # store the location in @R13 because I need
      # the registers for popping
      @asm << "@R13"
      @asm << "M=D"
      # pop off stack
      @asm.concat Pop.pop "D"
      # put @R13 in memory
      @asm << "@R13"
      @asm << "A=M"
      @asm << "M=D"
    when "temp"
      @asm.concat Pop.pop "D"
      @asm << "@#{5 + @index}"
      @asm << "M=D"
    when "pointer"
      @asm.concat Pop.pop "D"
      @asm << "@#{3 + @index}"
      @asm << "M=D"
    when "static"
      @asm.concat Pop.pop "D"
      @asm << "@#{@file}.#{@index}"
      @asm << "M=D"
    end
  end

  def self.pop reg
    asm = []
    asm << "@SP"
    asm << "AM=M-1"
    asm << "#{reg}=M"
  end
end
