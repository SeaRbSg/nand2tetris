require_relative 'push'
require_relative 'pop'

class Function
  def initialize func_name, num_vars
    @func_name = func_name
    @num_vars = num_vars
  end

  def to_asm
    asm = [
      "(#{@func_name})",
      "D=0",
    ]
    @num_vars.times do
      Push.push_d asm
    end
    asm
  end
end

class Return
  def self.to_asm
    asm = [ 
      "@LCL", # FRAME = LCL
      "D=M",
      "@FRAME",
      "M=D",
      "@5", # RET = *(FRAME-5)
      "A=D-A",
      "D=M",
      "@RET",
      "M=D" ]
    asm << Pop.pop("D") # *ARG = pop()
    asm << [
      "@ARG",
      "A=M",
      "M=D",
      "D=A+1", # SP = ARG+1
      "@ARG",
      "D=M+1",
      "@SP",
      "M=D",
      "@FRAME", #Restore THAT, THIS, ARG, LCL
      "AM=M-1",
      "D=M",
      "@THAT",
      "M=D",
      "@FRAME",
      "AM=M-1",
      "D=M",
      "@THIS",
      "M=D",
      "@FRAME",
      "AM=M-1",
      "D=M",
      "@ARG",
      "M=D",
      "@FRAME",
      "AM=M-1",
      "D=M",
      "@LCL",
      "M=D",
      "@RET",
      "A=M",
      "0;JMP",
    ]
  end
end
