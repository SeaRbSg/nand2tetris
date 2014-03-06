gem "minitest"
require 'minitest/autorun'
require_relative '../lib/code_writer'

class TestCodeWriter < Minitest::Test
  def setup
    @cw = CodeWriter.new
  end

  def test_write_push_constant
    # push constant 7
    @cw.write_push_pop(:c_push, "constant", 7)

    asm = @cw.asm
    assert_equal 8, asm.length
    assert_equal "// push constant 7", asm[0]
    assert_equal "@7",                 asm[1]
    assert_equal "D=A",                asm[2]
    assert_equal "@SP",                asm[3]
    assert_equal "A=M",                asm[4]
    assert_equal "M=D",                asm[5]
    assert_equal "@SP",                asm[6]
    assert_equal "M=M+1",              asm[7]
  end

  def test_write_pop_local
    # pop local 4
    @cw.write_push_pop(:c_pop, "local", 4)

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// pop local 4", asm[0]
    assert_equal "@4",             asm[1]
    assert_equal "D=A",            asm[2]
    assert_equal "@LCL",           asm[3]
    assert_equal "D=A+D",          asm[4]
    assert_equal "@R13",           asm[5]
    assert_equal "M=D",            asm[6]
    assert_equal "@SP",            asm[7]
    assert_equal "AM=M-1",         asm[8]
    assert_equal "D=M",            asm[9]
    assert_equal "@R13",           asm[10]
    assert_equal "A=M",            asm[11]
    assert_equal "M=D",            asm[12]
  end

  def test_write_arithmetic_add
    # add
    @cw.write_arithmetic("add")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// add", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=D+A",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",    asm[12]
  end
end
