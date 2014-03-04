gem "minitest"
require 'minitest/autorun'
require_relative '../lib/symbol_table'


class TestSymbolTable < Minitest::Test

  def setup
    @sym_table = SymbolTable.new
  end

  def test_predefined
    assert_equal "0", @sym_table.table["SP"]
    assert_equal "1", @sym_table.table["LCL"]
    assert_equal "2", @sym_table.table["ARG"]
    assert_equal "3", @sym_table.table["THIS"]
    assert_equal "4", @sym_table.table["THAT"]
    assert_equal "16384", @sym_table.table["SCREEN"]
    assert_equal "24576", @sym_table.table["KBD"]

    (0..15).each do |x|
      assert_equal "#{x}", @sym_table.table["R#{x}"]
    end
  end
end
