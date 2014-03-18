gem "minitest"
require 'minitest/autorun'
require_relative '../lib/code_writer'

class TestCodeWriter < Minitest::Test
  make_my_diffs_pretty!

  def setup
    @cw = CodeWriter.new
    @cw.file_name = "test"
  end

  def test_write_push_constant
    # push constant 7
    @cw.write_push_pop(:c_push, "constant", 7)

    expected = ["// push constant 7",
                "@7",
                "D=A",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_push_local
    # push local 7
    @cw.write_push_pop(:c_push, "local", 7)

    expected = ["// push local 7",
                "@7",
                "D=A",
                "@LCL",
                "A=M+D",
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_push_argument
    # push argument 8
    @cw.write_push_pop(:c_push, "argument", 8)

    expected = ["// push argument 8",
                "@8",
                "D=A",
                "@ARG",
                "A=M+D",
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_push_this
    # push argument 5
    @cw.write_push_pop(:c_push, "this", 5)

    expected = ["// push this 5",
                "@5",
                "D=A",
                "@THIS",
                "A=M+D",
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_push_that
    # push argument 6
    @cw.write_push_pop(:c_push, "that", 6)

    expected = ["// push that 6",
                "@6",
                "D=A",
                "@THAT",
                "A=M+D",
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_push_temp
    # push temp 2
    @cw.write_push_pop(:c_push, "temp", 2)

    expected = ["// push temp 2",
                "@R7",
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_push_pointer
    # push pointer 1
    @cw.write_push_pop(:c_push, "pointer", 1)

    expected = ["// push pointer 1",
                "@4",
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_push_static
    # push static 3
    @cw.write_push_pop(:c_push, "static", 3)

    expected = ["// push static 3",
                "@test.3",
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_pop_local
    # pop local 4
    @cw.write_push_pop(:c_pop, "local", 4)

    expected = ["// pop local 4",
                "@4",
                "D=A",
                "@LCL",
                "D=M+D",
                "@R13",
                "M=D",
                "@SP",
                "AM=M-1",
                "D=M",
                "@R13",
                "A=M",
                "M=D",]
    assert_equal expected, @cw.asm
  end

  def test_write_pop_argument
    # pop argument 1
    @cw.write_push_pop(:c_pop, "argument", 1)

    expected = ["// pop argument 1",
                "@1",
                "D=A",
                "@ARG",
                "D=M+D",
                "@R13",
                "M=D",
                "@SP",
                "AM=M-1",
                "D=M",
                "@R13",
                "A=M",
                "M=D",]
    assert_equal expected, @cw.asm
  end

  def test_write_pop_this
    # pop this 2
    @cw.write_push_pop(:c_pop, "this", 2)

    expected = ["// pop this 2",
                "@2",
                "D=A",
                "@THIS",
                "D=M+D",
                "@R13",
                "M=D",
                "@SP",
                "AM=M-1",
                "D=M",
                "@R13",
                "A=M",
                "M=D",]
    assert_equal expected, @cw.asm
  end

  def test_write_pop_that
    # pop that 3
    @cw.write_push_pop(:c_pop, "that", 3)

    expected = ["// pop that 3",
                "@3",
                "D=A",
                "@THAT",
                "D=M+D",
                "@R13",
                "M=D",
                "@SP",
                "AM=M-1",
                "D=M",
                "@R13",
                "A=M",
                "M=D",]
    assert_equal expected, @cw.asm
  end

  def test_write_pop_temp
    # pop temp 7
    @cw.write_push_pop(:c_pop, "temp", 7)

    expected = ["// pop temp 7",
                "@SP",
                "AM=M-1",
                "D=M",
                "@R12",
                "M=D",]
    assert_equal expected, @cw.asm
  end

  def test_write_pop_pointer_0
    # pop pointer 0
    @cw.write_push_pop(:c_pop, "pointer", 0)

    expected = ["// pop pointer 0",
                "@SP",
                "AM=M-1",
                "D=M",
                "@3",
                "M=D",]
    assert_equal expected, @cw.asm
  end

  def test_write_pop_static_4
    # pop pointer 4
    @cw.write_push_pop(:c_pop, "static", 4)

    expected = ["// pop static 4",
                "@SP",
                "AM=M-1",
                "D=M",
                "@test.4",
                "M=D",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_add
    @cw.write_arithmetic("add")

    expected = ["// add",
                "@SP",
                "AM=M-1",
                "D=M",
                "@SP",
                "AM=M-1",
                "A=M",
                "D=A+D",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_sub
    @cw.write_arithmetic("sub")

    expected = ["// sub",
                "@SP",
                "AM=M-1",
                "D=M",
                "@SP",
                "AM=M-1",
                "A=M",
                "D=A-D",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_neg
    @cw.write_arithmetic("neg")

    expected = ["// neg",
                "@SP",
                "A=M-1",
                "M=-M",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_eq
    @cw.write_arithmetic("eq")

    expected = ["// eq",
                "@SP",
                "AM=M-1",
                "D=M",
                "@SP",
                "AM=M-1",
                "A=M",
                "D=A-D",
                "@TRUE0001",
                "D;JEQ",
                "D=0",
                "@PUSHD0002",
                "0;JMP",
                "(TRUE0001)",
                "D=-1",
                "(PUSHD0002)",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_gt
    @cw.write_arithmetic("gt")

    expected = ["// gt",
                "@SP",
                "AM=M-1",
                "D=M",
                "@SP",
                "AM=M-1",
                "A=M",
                "D=A-D",
                "@TRUE0001",
                "D;JGT",
                "D=0",
                "@PUSHD0002",
                "0;JMP",
                "(TRUE0001)",
                "D=-1",
                "(PUSHD0002)",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_lt
    @cw.write_arithmetic("lt")

    expected = ["// lt",
                "@SP",
                "AM=M-1",
                "D=M",
                "@SP",
                "AM=M-1",
                "A=M",
                "D=A-D",
                "@TRUE0001",
                "D;JLT",
                "D=0",
                "@PUSHD0002",
                "0;JMP",
                "(TRUE0001)",
                "D=-1",
                "(PUSHD0002)",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_not
    @cw.write_arithmetic("not")

    expected = ["// not",
                "@SP",
                "A=M-1",
                "M=!M",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_and
    @cw.write_arithmetic("and")

    expected = ["// and",
                "@SP",
                "AM=M-1",
                "D=M",
                "@SP",
                "AM=M-1",
                "A=M",
                "D=D&A",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_arithmetic_or
    @cw.write_arithmetic("or")

    expected = ["// or",
                "@SP",
                "AM=M-1",
                "D=M",
                "@SP",
                "AM=M-1",
                "A=M",
                "D=D|A",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_write_label
    @cw.write_label("LOOP_START")

    expected = ["// label",
                "(LOOP_START)",]
    assert_equal expected, @cw.asm
  end

  def test_write_goto
    @cw.write_goto("LOOP_START")

    expected = ["// goto",
                "@LOOP_START",
                "0;JMP",]
    assert_equal expected, @cw.asm
  end

  def test_write_if
    @cw.write_if("LOOP_START")

    expected = ["// if-goto",
                "@SP",
                "AM=M-1",
                "D=M",
                "@LOOP_START",
                "D;JNE",]
    assert_equal expected, @cw.asm
  end

  def test_write_return
    @cw.write_return

    expected = ["// return",
                "@LCL",
                "D=M",
                "@R14",
                "M=D",
                "@5",
                "AD=D-A",
                "D=M",
                "@R15",
                "M=D",
                "@SP",
                "AM=M-1",
                "D=M",
                "@ARG",
                "A=M",
                "M=D",
                "@ARG",
                "D=M+1",
                "@SP",
                "M=D",
                "@R14",
                "AMD=M-1",
                "D=M",
                "@THAT",
                "M=D",
                "@R14",
                "AMD=M-1",
                "D=M",
                "@THIS",
                "M=D",
                "@R14",
                "AMD=M-1",
                "D=M",
                "@ARG",
                "M=D",
                "@R14",
                "AMD=M-1",
                "D=M",
                "@LCL",
                "M=D",
                "@R15",
                "A=M",
                "0;JMP",]
    assert_equal expected, @cw.asm
  end

  def test_write_function
    # function SimpleFunction.test 2

    @cw.write_function("SimpleFunction.test", 2)

    expected = ["// function SimpleFunction.test 2",
                "(SimpleFunction.test)",
                "@0",
                "D=A",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",]
    assert_equal expected, @cw.asm
  end

  def test_call
    @cw.write_call("Main.fibonacci", 1)

    expected = ["// call Main.fibonacci 1",
                "@RET0001",        # Push return-address
                "D=A",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@LCL",            # Push LCL
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@ARG",            # Push ARG
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@THIS",           # Push THIS
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@THAT",           # Push THAT
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@SP",             # ARG = SP-n-5
                "D=M",
                "@6",              # 1+5
                "D=D-A",
                "@ARG",
                "M=D",
                "@SP",             # LCL = SP
                "D=M",
                "@LCL",
                "M=D",
                "@Main.fibonacci", # goto f
                "0;JMP",
                "(RET0001)",]
    assert_equal expected, @cw.asm
  end

  def test_write_bootstrap
    @cw.write_bootstrap

    expected = ["// bootstrap",
                "@256",
                "D=A",
                "@SP",
                "M=D",
                "@RET0001",  # Push return-address
                "D=A",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@LCL",      # Push LCL
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@ARG",      # Push ARG
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@THIS",      # Push THIS
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@THAT",      # Push THAT
                "D=M",
                "@SP",
                "A=M",
                "M=D",
                "@SP",
                "M=M+1",
                "@SP",        # ARG = SP-n-5
                "D=M",
                "@5",         # 1+5
                "D=D-A",
                "@ARG",
                "M=D",
                "@SP",        # LCL = SP
                "D=M",
                "@LCL",
                "M=D",
                "@Sys.init",  # goto Sys.init
                "0;JMP",
                "(RET0001)",] # (return-address)
    assert_equal expected, @cw.asm
  end
end
