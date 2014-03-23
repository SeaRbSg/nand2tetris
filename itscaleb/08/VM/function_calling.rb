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

class Call
  @@count = 0;
  def initialize func_name, num_args
    @func_name = func_name
    @num_args = num_args
    @asm = []
  end

  def to_asm
    return_label = "RETURN#{@@count+=1}"
    @asm << [
      "@#{return_label}",
      "D=A", ]
    Push.push_d @asm
    self.save_pointer "@LCL"
    self.save_pointer "@ARG"
    self.save_pointer "@THIS"
    self.save_pointer "@THAT"
    @asm << [
      "@SP",
      "D=M",
      "@LCL",
      "M=D",
      "@#{@num_args + 5}",
      "D=D-A",
      "@ARG",
      "M=D", ]
    @asm << Goto.to_asm(@func_name)
    @asm << Label.to_asm(return_label)
    return @asm
  end

  def save_pointer pointer
    @asm << [
      pointer,
      "D=M", ]
    Push.push_d @asm
  end
end
