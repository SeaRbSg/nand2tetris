require_relative 'push'
require_relative 'pop'
require 'pry'


class Add
  def self.to_asm
    Op.stack_operation "D=D+A"
  end
end

class Sub
  def self.to_asm
    Op.stack_operation "D=A-D"
  end
end

class And
  def self.to_asm
    Op.stack_operation "D=A&D"
  end
end

class Or
  def self.to_asm
    Op.stack_operation "D=A|D"
  end
end

class Eq
  def self.to_asm
    Op.conditional_operation "D=A-D", "D;JEQ"
  end
end

class Lt
  def self.to_asm
    Op.conditional_operation "D=A-D", "D;JLT"
  end
end

class Gt
  def self.to_asm
    Op.conditional_operation "D=A-D", "D;JGT"
  end
end

class Neg
  def self.to_asm
    asm = Pop.pop "D"
    asm << "D=-D"
    Push.push_d asm
  end
end

class Not
  def self.to_asm
    asm = Pop.pop "D"
    asm << "D=!D"
    Push.push_d asm
  end
end

class Op
  def self.stack_operation comp
    popd = Pop.pop "D"
    popa = Pop.pop "A"
    Push.push_d popd.concat popa << comp
  end

  def self.conditional_operation computation, conditional
    popd = Pop.pop "D"
    popa = Pop.pop "A"
    asm = popd.concat(popa) << computation
    cond = Cond.to_asm(conditional)
    Push.push_d(asm.concat(cond))
  end
end

class Cond
  @@label_count = 0; # don't really like this
  def self.to_asm cmp
    @@label_count = @@label_count += 1
    asm = []
    asm <<  "@TRUE#{@@label_count}"
    asm <<  cmp
    asm <<  "D=0"
    asm <<  "@END#{@@label_count}"
    asm <<  "0;JMP"
    asm <<  "(TRUE#{@@label_count})"
    asm <<  "D=-1"
    asm <<  "(END#{@@label_count})"
  end
end
