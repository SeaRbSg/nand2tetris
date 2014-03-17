class Assembler
  class SymbolTable
    attr_reader :table

    def initialize
      @table = {
        'SP' => 0,
        'LCL' => 1,
        'ARG' => 2,
        'THIS' => 3,
        'THAT' => 4,
        'SCREEN' => 16384,
        'KBD' => 24576
      }
      16.times {|n| @table["R#{n}"] = n }
      @next_spot = 16
    end

    def add_entry(key, value = nil)
      unless value
        value = @next_spot
        @next_spot += 1
      end
      @table[key] = value
    end

    def address_for(key)
      add_entry(key) unless contains?(key)
      table[key]
    end

    def contains?(key)
      table.has_key?(key)
    end
  end
end
