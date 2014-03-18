require_relative 'pop'

class Label
  def self.to_asm label_name
    "(#{label_name})"
  end
end

class IfGoto
  def self.to_asm label_name
    asm = Pop.pop "D"
    asm << "@#{label_name}"
    asm << "D;JNE"
  end
end

class Goto
  def self.to_asm label_name
    asm = []
    asm << "@#{label_name}"
    asm << "0;JMP"
  end
end
