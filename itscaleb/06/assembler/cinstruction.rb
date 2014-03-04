class CInstruction
  def self.assemble instruction
    # next conditionals are an ugly hack because I can't figure out a regex for comp_pattern for the life of me.
    if instruction.split(';').length > 1
      comp = instruction.split(';')[0]
    end
    if instruction.split('=').length > 1
      comp = instruction.split('=')[1]
      comp = comp.split(';')[0] if comp.split(';').length > 1
    end

    dest = instruction[@@dest_pattern]
    jump = instruction[@@jump_pattern]
    "111" + @@comp_lookup[comp] + @@dest_lookup[dest] + @@jump_lookup[jump]
  end

  @@comp_lookup = {
    "0"   => "0101010",
    "1"   => "0111111",
    "-1"  => "0111010",
    "D"   => "0001100",
    "A"   => "0110000",
    "!D"  => "0001101",
    "!A"  => "0110001",
    "-D"  => "0001111",
    "-A"  => "0110011",
    "D+1" => "0011111",
    "A+1" => "0110111",
    "D-1" => "0001110",
    "A-1" => "0110010",
    "D+A" => "0000010",
    "D-A" => "0010011",
    "A-D" => "0000111",
    "D&A" => "0000000",
    "D|A" => "0010101",
    "M"   => "1110000",
    "!M"  => "1110001",
    "-M"  => "1110011",
    "M+1" => "1110111",
    "M-1" => "1110010",
    "D+M" => "1000010",
    "D-M" => "1010011",
    "M-D" => "1000111",
    "D&M" => "1000000",
    "D|M" => "1010101",
  }

  @@dest_lookup = {
    nil   => "000",
    "M"   => "001",
    "D"   => "010",
    "MD"  => "011",
    "A"   => "100",
    "AM"  => "101",
    "AD"  => "110",
    "AMD" => "111",
  }

  @@jump_lookup = {
    nil   => "000",
    "JGT" => "001",
    "JEQ" => "010",
    "JGE" => "011",
    "JLT" => "100",
    "JNE" => "101",
    "JLE" => "110",
    "JMP" => "111",
  }

  @@comp_pattern = /(?<==).*(?=;|$)/
  @@dest_pattern = /(?<=^).*(?==)/
  @@jump_pattern = /(?<=;).*(?=$)/

end
