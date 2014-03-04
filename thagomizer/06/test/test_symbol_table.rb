gem "minitest"
require 'minitest/autorun'
require_relative '../lib/symbol_table'


class TestSymbolTable < Minitest::Test

  def setup
    @sym_table = SymbolTable.new
  end

  def test_predefined
    assert_equal "0",     @sym_table.get_address("SP")
    assert_equal "1",     @sym_table.get_address("LCL")
    assert_equal "2",     @sym_table.get_address("ARG")
    assert_equal "3",     @sym_table.get_address("THIS")
    assert_equal "4",     @sym_table.get_address("THAT")
    assert_equal "16384", @sym_table.get_address("SCREEN")
    assert_equal "24576", @sym_table.get_address("KBD")

    (0..15).each do |x|
      assert_equal "#{x}", @sym_table.get_address("R#{x}")
    end
  end

  def test_add_entry
    @sym_table.add_entry "NEWSYM", 1234

    assert_equal 1234, @sym_table.get_address("NEWSYM")
  end

  def test_add_entry_duplicate
    @sym_table.add_entry("NEWSYM", 1234)

    assert_equal 1234, @sym_table.get_address("NEWSYM")

    result = @sym_table.add_entry "NEWSYM", 1236

    assert_equal 1234, result
  end

  def test_add_var
    @sym_table.add_var "VAR1"
    assert_equal "16", @sym_table.get_address("VAR1")

    @sym_table.add_var "VAR2"
    assert_equal "17", @sym_table.get_address("VAR2")
  end

  def test_add_var_duplicate
    @sym_table.add_var "VAR1"
    @sym_table.add_var "VAR1"

    assert_equal "16", @sym_table.get_address("VAR1")
    assert_equal ["VAR1"], @sym_table.table.keys.find_all { |k| k == "VAR1"}
  end

  def test_get_address
    assert_equal "0", @sym_table.get_address("SP")
    assert_equal nil, @sym_table.get_address("FOO")
  end
end
