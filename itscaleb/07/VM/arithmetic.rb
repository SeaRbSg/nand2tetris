require_relative 'push'

class Arithmetic
  def initialize
    @label_number = 0
  end
  def add
    asm = op "D=D+A"
    Push.push_d asm
  end

  def sub
    asm = op "D=A-D"
    Push.push_d asm
  end

  def and
    asm = op "D=A&D"
    Push.push_d asm
  end

  def or
    asm = op "D=A|D"
    Push.push_d asm
  end

  def eq
    asm = op "D=A-D"
    cmp asm, "D;JEQ"
    Push.push_d asm
  end

  def lt
    asm = op "D=A-D"
    cmp asm, "D;JLT"
    Push.push_d asm
  end

  def gt
    asm = op "D=A-D"
    cmp asm, "D;JGT"
    Push.push_d asm
  end
   
  def neg
    asm = pop "D"
    asm << "D=-D"
    Push.push_d asm
  end

  def not
    asm = pop "D"
    asm << "D=!D"
    Push.push_d asm
  end

  def pop reg
    asm = []
    asm << "@SP"
    asm << "AM=M-1"
    asm << "#{reg}=M"
  end

  def cmp asm, cmp
    label_suffix = @label_number+=1
    asm <<  "@TRUE#{label_suffix}"
    asm <<  cmp
    asm <<  "D=0"
    asm <<  "@END#{label_suffix}"
    asm <<  "0;JMP"
    asm <<  "(TRUE#{label_suffix})"
    asm <<  "D=-1"
    asm <<  "(END#{label_suffix})"
  end

  def op op
    popd = pop "D"
    popa = pop "A"
    popd.concat popa <<  op
  end
end
