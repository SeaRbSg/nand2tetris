require 'minitest/autorun'
require 'minitest/pride'
require_relative 'symbol_table'

class SymbolTableTest < Minitest::Test
  def test_adding_symbol_then_getting_var_returns_correct_line_no
    #st = SymbolTable.new
    SymbolTable.set_symbol "hello", 5
    line_no = SymbolTable.get_variable "hello"
    assert_equal 5, line_no
  end

  def test_get_variable_manages_address
    #st = SymbolTable.new
    address1 = SymbolTable.get_variable "symbol"
    address2 = SymbolTable.get_variable "goodbye"
    address3 = SymbolTable.get_variable "symbol"
    assert_equal address1, 16
    assert_equal address3, 16
    assert_equal address2, 17
  end
end
