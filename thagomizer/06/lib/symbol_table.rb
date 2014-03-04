class SymbolTable
  attr_accessor :table

  def initialize
    @next_var = 1024
    @table = {}
    init_table
  end

  def add_entry symbol, address
    @table[symbol] = address
  end

  def add_var symbol
    @table[symbol] = @next_var
    @next_var += 1

    @table[symbol]
  end

  def contains symbol
    @table.keys.include? symbol
  end

  def get_address symbol
    @table[symbol]
  end


  def init_table
    @table["SP"]     = "0"
    @table["LCL"]    = "1"
    @table["ARG"]    = "2"
    @table["THIS"]   = "3"
    @table["THAT"]   = "4"
    @table["SCREEN"] = "16384"
    @table["KBD"]    = "24576"

    (0..15).each do |x|
      @table["R#{x}"] = "#{x}"
    end
  end
end
