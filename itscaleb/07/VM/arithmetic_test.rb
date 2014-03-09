require 'minitest/autorun'
require 'minitest/pride'
require_relative 'arithmetic'

class ArithmeticTests < Minitest::Test
  def test_add
    asm = Arithmetic.add
    assert_equal "@SP", asm[0]
    assert_equal "AM=M-1", asm[1]
    assert_equal "D=M", asm[2]
    assert_equal "@SP", asm[3]
    assert_equal "AM=M-1", asm[4]
    assert_equal "A=M", asm[5]
    assert_equal "D=D+A", asm[6]
    assert_equal "@SP", asm[7]
    assert_equal "A=M", asm[8]
    assert_equal "M=D", asm[9]
    assert_equal "@SP", asm[10]
    assert_equal "M=M+1", asm[11]
  end

  def test_sub
    asm = Arithmetic.sub
    assert_equal "@SP", asm[0]
    assert_equal "AM=M-1", asm[1]
    assert_equal "D=M", asm[2]
    assert_equal "@SP", asm[3]
    assert_equal "AM=M-1", asm[4]
    assert_equal "A=M", asm[5]
    assert_equal "D=A-D", asm[6]
    assert_equal "@SP", asm[7]
    assert_equal "A=M", asm[8]
    assert_equal "M=D", asm[9]
    assert_equal "@SP", asm[10]
    assert_equal "M=M+1", asm[11]
  end
end
