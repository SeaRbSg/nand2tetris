class Code
  def self.dest(mnemonic)
    case mnemonic
    when nil
      "000"
    when "M"
      "001"
    when "D"
      "010"
    when "MD"
      "011"
    when "A"
      "100"
    when "AM"
      "101"
    when "AD"
      "110"
    when "AMD"
      "111"
    end
  end

  def self.jump(mnemonic)
    case mnemonic
    when nil
      "000"
    when "JGT"
      "001"
    when "JEQ"
      "010"
    when "JGE"
      "011"
    when "JLT"
      "100"
    when "JNE"
      "101"
    when "JLE"
      "110"
    when "JMP"
      "111"
    end
  end

  def self.comp(mnemonic)
    case mnemonic
    when "0"
      "0101010"
    when "1"
      "0111111"
    when "-1"
      "0111010"
    when "D"
      "0001100"
    when "A"
      "0110000"
    when "M"
      "1110000"
    when "!D"
      "0001101"
    when "!A"
      "0110001"
    when "!M"
      "1110001"
    when "-D"
      "0001111"
    when "-A"
      "0110011"
    when "-M"
      "1110011"
    when "D+1"
      "0011111"
    when "A+1"
      "0110111"
    when "M+1"
      "1110111"
    when "D-1"
      "0001110"
    when "A-1"
      "0110010"
    when "M-1"
      "1110010"
    when "D+A"
      "0000010"
    when "D+M"
      "1000010"
    when "D-A"
      "0010011"
    when "D-M"
      "1010011"
    when "A-D"
      "0000111"
    when "M-D"
      "1000111"
    when "D&A"
      "0000000"
    when "D&M"
      "1000000"
    when "D|A"
      "0010101"
    when "D|M"
      "1010101"
    end
  end

  def self.c_command(dest, comp, jump)
    inst = "111"

    inst << Code.comp(comp)
    inst << Code.dest(dest)
    inst << Code.jump(jump)
  end

  def self.a_command(literal)
    inst = "0"
    inst << literal.to_i.to_s(2).rjust(15, "0")
  end
end
