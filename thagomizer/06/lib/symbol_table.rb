class SymbolTable
  attr_accessor :table

  def initialize
    @next_var = 1024
    @table = {}
    init_table
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
