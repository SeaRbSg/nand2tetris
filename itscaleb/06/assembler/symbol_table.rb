class SymbolTable

  def self.set_symbol symbol, line_number
    @@symbol_table[symbol.delete('()')] = line_number
  end

  def self.get_variable var
    var.delete!('@')
    if var.integer?
      return var
    end
    if !@@symbol_table.has_key? var
      @@symbol_table[var] = @@curr_ram_location += 1
    end
    @@symbol_table[var]
  end

  @@curr_ram_location = 15
  @@symbol_table = {
    "SP" => 0,
    "LCL" => 1,
    "ARG" => 2,
    "THIS" => 3,
    "THAT" => 4,
    "R0" => 0,
    "R1" => 1,
    "R2" => 2,
    "R3" => 3,
    "R4" => 4,
    "R5" => 5,
    "R6" => 6,
    "R7" => 7,
    "R8" => 8,
    "R9" => 9,
    "R10" => 10,
    "R11" => 11,
    "R12" => 12,
    "R13" => 13,
    "R14" => 14,
    "R15" => 15,
    "SCREEN" => 16384,
    "KBD" => 24576,
  }

end

class String
  def integer?
    self.to_i.to_s == self
  end
end
