class SymbolTable
  attr_accessor :table

  def initialize
    @table = {}
    init_table
  end

  def add_entry symbol, address
    @table[symbol] = address
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
