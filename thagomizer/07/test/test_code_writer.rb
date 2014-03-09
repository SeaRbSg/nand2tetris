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
    assert_equal "D=A+D",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",  asm[12]
  end

  def test_write_arithmetic_sub
    @cw.write_arithmetic("sub")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// sub", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=A-D",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",  asm[12]
  end

  def test_write_arithmetic_neg
    @cw.write_arithmetic("neg")

    asm = @cw.asm
    assert_equal 7, asm.length
    assert_equal "// neg", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "MD=-D",  asm[4]
    assert_equal "@SP",    asm[5]
    assert_equal "M=M+1",  asm[6]
  end

  def test_write_arithmetic_eq
    @cw.write_arithmetic("eq")

    asm = @cw.asm
    assert_equal 22, asm.length
    assert_equal "// eq",       asm[0]
    assert_equal "@SP",         asm[1]
    assert_equal "AM=M-1",      asm[2]
    assert_equal "D=M",         asm[3]
    assert_equal "@SP",         asm[4]
    assert_equal "AM=M-1",      asm[5]
    assert_equal "A=M",         asm[6]
    assert_equal "D=A-D",       asm[7]
    assert_equal "@TRUE0001",   asm[8]
    assert_equal "D;JEQ",       asm[9]

    assert_equal "(FALSE0002)", asm[10]
    assert_equal "D=0",         asm[11]
    assert_equal "@PUSHD0003",  asm[12]
    assert_equal "0;JMP",       asm[13]

    assert_equal "(TRUE0001)",  asm[14]
    assert_equal "D=-1",        asm[15]

    assert_equal "(PUSHD0003)", asm[16]
    assert_equal "@SP",         asm[17]
    assert_equal "A=M",         asm[18]
    assert_equal "M=D",         asm[19]
    assert_equal "@SP",         asm[20]
    assert_equal "M=M+1",       asm[21]
  end

  def test_write_arithmetic_gt
    @cw.write_arithmetic("gt")

    asm = @cw.asm
    assert_equal 22, asm.length
    assert_equal "// gt",       asm[0]
    assert_equal "@SP",         asm[1]
    assert_equal "AM=M-1",      asm[2]
    assert_equal "D=M",         asm[3]
    assert_equal "@SP",         asm[4]
    assert_equal "AM=M-1",      asm[5]
    assert_equal "A=M",         asm[6]
    assert_equal "D=A-D",       asm[7]
    assert_equal "@TRUE0001",   asm[8]
    assert_equal "D;JGT",       asm[9]

    assert_equal "(FALSE0002)", asm[10]
    assert_equal "D=0",         asm[11]
    assert_equal "@PUSHD0003",  asm[12]
    assert_equal "0;JMP",       asm[13]

    assert_equal "(TRUE0001)",  asm[14]
    assert_equal "D=-1",        asm[15]

    assert_equal "(PUSHD0003)", asm[16]
    assert_equal "@SP",         asm[17]
    assert_equal "A=M",         asm[18]
    assert_equal "M=D",         asm[19]
    assert_equal "@SP",         asm[20]
    assert_equal "M=M+1",       asm[21]
  end

  def test_write_arithmetic_lt
    @cw.write_arithmetic("lt")

    asm = @cw.asm
    assert_equal 22, asm.length
    assert_equal "// lt",       asm[0]
    assert_equal "@SP",         asm[1]
    assert_equal "AM=M-1",      asm[2]
    assert_equal "D=M",         asm[3]
    assert_equal "@SP",         asm[4]
    assert_equal "AM=M-1",      asm[5]
    assert_equal "A=M",         asm[6]
    assert_equal "D=A-D",       asm[7]
    assert_equal "@TRUE0001",   asm[8]
    assert_equal "D;JLT",       asm[9]

    assert_equal "(FALSE0002)", asm[10]
    assert_equal "D=0",         asm[11]
    assert_equal "@PUSHD0003",  asm[12]
    assert_equal "0;JMP",       asm[13]

    assert_equal "(TRUE0001)",  asm[14]
    assert_equal "D=-1",        asm[15]

    assert_equal "(PUSHD0003)", asm[16]
    assert_equal "@SP",         asm[17]
    assert_equal "A=M",         asm[18]
    assert_equal "M=D",         asm[19]
    assert_equal "@SP",         asm[20]
    assert_equal "M=M+1",       asm[21]
  end

  def test_write_arithmetic_not
    @cw.write_arithmetic("not")

    asm = @cw.asm
    assert_equal 7, asm.length
    assert_equal "// not", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "MD=!D",  asm[4]
    assert_equal "@SP",    asm[5]
    assert_equal "M=M+1",  asm[6]
  end

  def test_write_arithmetic_and
    @cw.write_arithmetic("and")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// and", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=D&A",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",    asm[12]
  end

  def test_write_arithmetic_or
    @cw.write_arithmetic("or")

    asm = @cw.asm
    assert_equal 13, asm.length
    assert_equal "// or", asm[0]
    assert_equal "@SP",    asm[1]
    assert_equal "AM=M-1", asm[2]
    assert_equal "D=M",    asm[3]
    assert_equal "@SP",    asm[4]
    assert_equal "AM=M-1", asm[5]
    assert_equal "A=M",    asm[6]
    assert_equal "D=D|A",  asm[7]
    assert_equal "@SP",    asm[8]
    assert_equal "A=M",    asm[9]
    assert_equal "M=D",    asm[10]
    assert_equal "@SP",    asm[11]
    assert_equal "M=M+1",    asm[12]
  end

end
