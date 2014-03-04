gem "minitest"
require 'minitest/autorun'
require_relative '../lib/code'

class TestCode < Minitest::Test

  def test_dest
    assert_equal "000", Code.dest(nil)
    assert_equal "001", Code.dest("M")
    assert_equal "010", Code.dest("D")
    assert_equal "011", Code.dest("MD")
    assert_equal "100", Code.dest("A")
    assert_equal "101", Code.dest("AM")
    assert_equal "110", Code.dest("AD")
    assert_equal "111", Code.dest("AMD")
  end

  def test_comp
    assert_equal "0101010", Code.comp("0")
    assert_equal "0111111", Code.comp("1")
    assert_equal "0111010", Code.comp("-1")
    assert_equal "0001100", Code.comp("D")
    assert_equal "0110000", Code.comp("A")
    assert_equal "1110000", Code.comp("M")
    assert_equal "0001101", Code.comp("!D")
    assert_equal "0110001", Code.comp("!A")
    assert_equal "1110001", Code.comp("!M")
    assert_equal "0001111", Code.comp("-D")
    assert_equal "0110011", Code.comp("-A")
    assert_equal "1110011", Code.comp("-M")
    assert_equal "0011111", Code.comp("D+1")
    assert_equal "0110111", Code.comp("A+1")
    assert_equal "1110111", Code.comp("M+1")
    assert_equal "0001110", Code.comp("D-1")
    assert_equal "0110010", Code.comp("A-1")
    assert_equal "1110010", Code.comp("M-1")
    assert_equal "0000010", Code.comp("D+A")
    assert_equal "1000010", Code.comp("D+M")
    assert_equal "0010011", Code.comp("D-A")
    assert_equal "1010011", Code.comp("D-M")
    assert_equal "0000111", Code.comp("A-D")
    assert_equal "1000111", Code.comp("M-D")
    assert_equal "0000000", Code.comp("D&A")
    assert_equal "1000000", Code.comp("D&M")
    assert_equal "0010101", Code.comp("D|A")
    assert_equal "1010101", Code.comp("D|M")
  end

  def test_jump
    assert_equal "000", Code.jump(nil)
    assert_equal "001", Code.jump("JGT")
    assert_equal "010", Code.jump("JEQ")
    assert_equal "011", Code.jump("JGE")
    assert_equal "100", Code.jump("JLT")
    assert_equal "101", Code.jump("JNE")
    assert_equal "110", Code.jump("JLE")
    assert_equal "111", Code.jump("JMP")
  end


end
