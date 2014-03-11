gem "minitest"
require 'minitest/autorun'
require_relative '../lib/parser'
require 'stringio'

class TestParser < Minitest::Test

  def test_has_more_commands_when_more_commands
    source = "Test One\nTest Two"
    parser = Parser.new StringIO.new(source)

    assert parser.has_more_commands?
  end

  def test_has_more_commands_when_no_more_commands
    source = ""
    parser = Parser.new StringIO.new(source)

    refute parser.has_more_commands?
  end

  def test_advance
    source = "push constant 7\npush constant 8"
    parser = Parser.new StringIO.new(source)

    parser.advance

    assert_equal "push constant 7", parser.current_command

    parser.advance

    assert_equal "push constant 8", parser.current_command
  end

  def test_advance_comments
    source = "push constant 7 // My comment\n//My full line comment\npush constant 8"
    parser = Parser.new StringIO.new(source)

    parser.advance

    assert_equal "push constant 7", parser.current_command

    parser.advance

    assert_equal "push constant 8", parser.current_command
  end

  def test_command_type_push
    source = "push argument 0"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_push, parser.command_type
  end

  def test_command_type_pop
    source = "pop this 6"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_pop, parser.command_type
  end

  def test_command_type_label
    source = "label IF_TRUE"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_label, parser.command_type
  end

  def test_command_type_goto
    source = "goto IF_FALSE"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_goto, parser.command_type
  end

  def test_command_type_if
    source = "if-goto IF_TRUE"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_if, parser.command_type
  end

  def test_command_type_function
    source = "function Main.fibonacci 0"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_function, parser.command_type
  end

  def test_command_type_return
    source = "return"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_return, parser.command_type
  end

  def test_command_type_call
    source = "call Main.fibonacci 1"
    parser = Parser.new StringIO.new(source)
    parser.advance

    assert_equal :c_call, parser.command_type
  end

  def test_arg1
    source = "call Main.fibonacci 1\npush argument 0\nfunction Main.fibonacci 0\ngoto IF_FALSE\nif-goto IF_TRUE\npop this 6"
    parser = Parser.new StringIO.new(source)

    parser.advance
    assert_equal "Main.fibonacci", parser.arg1

    parser.advance
    assert_equal "argument", parser.arg1

    parser.advance
    assert_equal "Main.fibonacci", parser.arg1

    parser.advance
    assert_equal "IF_FALSE", parser.arg1

    parser.advance
    assert_equal "IF_TRUE", parser.arg1

    parser.advance
    assert_equal "this", parser.arg1
  end

  def test_arg2
    source = "push argument 0\nfunction Main.fibonacci 0\npop this 6\ncall Main.fibonacci 1"
    parser = Parser.new StringIO.new(source)

    parser.advance
    assert_equal 0, parser.arg2

    parser.advance
    assert_equal 0, parser.arg2

    parser.advance
    assert_equal 6, parser.arg2

    parser.advance
    assert_equal 1, parser.arg2
  end
end
