gem "minitest"
require 'minitest/autorun'
require_relative '../lib/code'

class TestCode < Minitest::Test

  def test_dest
    assert_equal "000", Code::DEST[nil]
    assert_equal "001", Code::DEST["M"]
    assert_equal "010", Code::DEST["D"]
    assert_equal "011", Code::DEST["MD"]
    assert_equal "100", Code::DEST["A"]
    assert_equal "101", Code::DEST["AM"]
    assert_equal "110", Code::DEST["AD"]
    assert_equal "111", Code::DEST["AMD"]
  end

  def test_comp
    assert_equal "0101010", Code::COMP["0"]
    assert_equal "0111111", Code::COMP["1"]
    assert_equal "0111010", Code::COMP["-1"]
    assert_equal "0001100", Code::COMP["D"]
    assert_equal "0110000", Code::COMP["A"]
    assert_equal "1110000", Code::COMP["M"]
    assert_equal "0001101", Code::COMP["!D"]
    assert_equal "0110001", Code::COMP["!A"]
    assert_equal "1110001", Code::COMP["!M"]
    assert_equal "0001111", Code::COMP["-D"]
    assert_equal "0110011", Code::COMP["-A"]
    assert_equal "1110011", Code::COMP["-M"]
    assert_equal "0011111", Code::COMP["D+1"]
    assert_equal "0110111", Code::COMP["A+1"]
    assert_equal "1110111", Code::COMP["M+1"]
    assert_equal "0001110", Code::COMP["D-1"]
    assert_equal "0110010", Code::COMP["A-1"]
    assert_equal "1110010", Code::COMP["M-1"]
    assert_equal "0000010", Code::COMP["D+A"]
    assert_equal "1000010", Code::COMP["D+M"]
    assert_equal "0010011", Code::COMP["D-A"]
    assert_equal "1010011", Code::COMP["D-M"]
    assert_equal "0000111", Code::COMP["A-D"]
    assert_equal "1000111", Code::COMP["M-D"]
    assert_equal "0000000", Code::COMP["D&A"]
    assert_equal "1000000", Code::COMP["D&M"]
    assert_equal "0010101", Code::COMP["D|A"]
    assert_equal "1010101", Code::COMP["D|M"]
  end

  def test_jump
    assert_equal "000", Code::JUMP[nil]
    assert_equal "001", Code::JUMP["JGT"]
    assert_equal "010", Code::JUMP["JEQ"]
    assert_equal "011", Code::JUMP["JGE"]
    assert_equal "100", Code::JUMP["JLT"]
    assert_equal "101", Code::JUMP["JNE"]
    assert_equal "110", Code::JUMP["JLE"]
    assert_equal "111", Code::JUMP["JMP"]
  end

  def test_c_command
    assert_equal "1111110000010000", Code.c_command("D",  "M",   nil)
    assert_equal "1111010011010000", Code.c_command("D",  "D-M", nil)
    assert_equal "1110001100000001", Code.c_command(nil,  "D",   "JGT")
    assert_equal "1111110000010000", Code.c_command("D",  "M",   nil)
    assert_equal "1110101010000111", Code.c_command(nil,  "0",   "JMP")
    assert_equal "1110110000010000", Code.c_command("D",  "A",   nil)
    assert_equal "1110000010010000", Code.c_command("D",  "D+A", nil)
    assert_equal "1111110010011000", Code.c_command("MD", "M-1", nil)
    assert_equal "1111110001001000", Code.c_command("M",  "!M",  nil)

  end

  def test_a_literal
    assert_equal "0000000000000010", Code.a_command("2")
    assert_equal "0000000000000011", Code.a_command("3")
    assert_equal "0000000000001010", Code.a_command("10")
    assert_equal "0000000000001100", Code.a_command("12")
  end

end
