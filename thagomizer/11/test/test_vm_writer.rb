gem "minitest"
require 'minitest/autorun'

require_relative '../lib/vm_writer'
require 'stringio'

class TestVmWriter < Minitest::Test
  make_my_diffs_pretty!

  def setup
    @output = StringIO.new
    @vm_writer = VmWriter.new(@output)
  end

  def test_creation
    setup
    refute_nil @vm_writer
  end

  def test_write_push_constant
    @vm_writer.write_push(:const, 1)
    assert_equal "push constant 1\n", @output.string
  end

  def test_write_push_arg
    @vm_writer.write_push(:arg, 2)
    assert_equal "push argument 2\n", @output.string
  end

  def test_write_push_local
    @vm_writer.write_push(:local, 3)
    assert_equal "push local 3\n", @output.string
  end

  def test_write_push_static
    @vm_writer.write_push(:static, 3)
    assert_equal "push static 3\n", @output.string
  end

  def test_write_push_this
    @vm_writer.write_push(:this, 3)
    assert_equal "push this 3\n", @output.string
  end

  def test_write_push_that
    @vm_writer.write_push(:that, 2)
    assert_equal "push that 2\n", @output.string
  end

  def test_write_push_pointer
    @vm_writer.write_push(:pointer, 1)
    assert_equal "push pointer 1\n", @output.string
  end

  def test_write_push_temp
    @vm_writer.write_push(:temp, 3)
    assert_equal "push temp 3\n", @output.string
  end


  def test_write_pop_constant
    @vm_writer.write_pop(:const, 1)
    assert_equal "pop constant 1\n", @output.string
  end

  def test_write_pop_arg
    @vm_writer.write_pop(:arg, 2)
    assert_equal "pop argument 2\n", @output.string
  end

  def test_write_pop_local
    @vm_writer.write_pop(:local, 3)
    assert_equal "pop local 3\n", @output.string
  end

  def test_write_pop_static
    @vm_writer.write_pop(:static, 3)
    assert_equal "pop static 3\n", @output.string
  end

  def test_write_pop_this
    @vm_writer.write_pop(:this, 3)
    assert_equal "pop this 3\n", @output.string
  end

  def test_write_pop_that
    @vm_writer.write_pop(:that, 2)
    assert_equal "pop that 2\n", @output.string
  end

  def test_write_pop_pointer
    @vm_writer.write_pop(:pointer, 1)
    assert_equal "pop pointer 1\n", @output.string
  end

  def test_write_pop_temp
    @vm_writer.write_pop(:temp, 3)
    assert_equal "pop temp 3\n", @output.string
  end

  def test_write_arithmetic
    @vm_writer.write_arithmetic(:add)
    @vm_writer.write_arithmetic(:sub)
    @vm_writer.write_arithmetic(:neg)
    @vm_writer.write_arithmetic(:eq)
    @vm_writer.write_arithmetic(:gt)
    @vm_writer.write_arithmetic(:lt)
    @vm_writer.write_arithmetic(:and)
    @vm_writer.write_arithmetic(:or)
    @vm_writer.write_arithmetic(:not)

    expected = <<-eos
add
sub
neg
eq
gt
lt
and
or
not
    eos

    assert_equal expected, @output.string
  end

  def test_write_arithmetic_unknown
    assert_raises(RuntimeError) do
      @vm_writer.write_arithmetic(:bad)
    end
  end

  def test_write_label
    @vm_writer.write_label("MyLabel")

    assert_equal "label MyLabel\n", @output.string
  end

  def test_write_goto
    @vm_writer.write_goto("MyGoto")

    assert_equal "goto MyGoto\n", @output.string
  end

  def test_write_if
    @vm_writer.write_if("MyIf")

    assert_equal "if-goto MyIf\n", @output.string
  end

  def test_write_call
    @vm_writer.write_call("methodName", 3)

    assert_equal "call methodName 3\n", @output.string
  end

  def test_write_function
    @vm_writer.write_function("functionName", 2)

    assert_equal "function functionName 2\n", @output.string
  end

  def test_return
    @vm_writer.write_return

    assert_equal "return\n", @output.string
  end
end
