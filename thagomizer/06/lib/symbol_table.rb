class SymbolTable
  attr_accessor :table

  def initialize
    @next_var = "15"
    @table = {}
    init_table
  end

  def add_entry symbol, address
    if @table.has_key?(symbol)
      @table[symbol]
    else
      @table[symbol] = address
    end
  end

  def add_var symbol
    if @table.has_key?(symbol)
      @table[symbol]
    else
      @next_var = @next_var.succ
      @table[symbol] = @next_var
    end
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
