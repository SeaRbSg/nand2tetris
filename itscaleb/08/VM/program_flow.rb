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
