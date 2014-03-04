gem "minitest"
require 'minitest/autorun'
require_relative '../lib/parser'
require 'stringio'


class TestParser < Minitest::Test

  def test_has_more_commands_when_more_commands
    source = "Test One\nTest Two"
    parser = Parser.new(StringIO.new(source))

    assert parser.has_more_commands?
  end

  def test_has_more_commands_when_no_more_commands
    source = ""
    parser = Parser.new(StringIO.new(source))

    refute parser.has_more_commands?
  end

  def test_advance
    source = "@3\nD = M"
    parser = Parser.new(StringIO.new(source))

    parser.advance

    assert_equal "@3", parser.current_command

    parser.advance

    assert_equal "D=M", parser.current_command
  end

  def test_advance_comments
    source = "@3 // My comment\n//My full line comment\nD = M"
    parser = Parser.new(StringIO.new(source))

    parser.advance

    assert_equal "@3", parser.current_command

    parser.advance

    assert_equal "D=M", parser.current_command
  end

  # command_type

  def test_command_type_a_command_symbol
    source = "@foo"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal :a_command, parser.command_type
  end

  def test_command_type_a_command_number
    source = "@42"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal :a_command, parser.command_type
  end

  def test_command_type_c_command_calculation
    source = "AM=M-1"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal :c_command, parser.command_type
  end

  def test_command_type_c_command_jump
    source = "D;JNE"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal :c_command, parser.command_type
  end

  def test_command_type_l_command
    source = "(LOOP)"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal :l_command, parser.command_type
  end

  # symbol

  def test_symbol_a_command_number
    source = "@42"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal "42", parser.symbol
  end

  def test_symbol_a_command_symbol
    source = "@foo._$:43"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal "foo._$:43", parser.symbol
  end

  def test_symbol_l_command
    source = "(LOOP)"
    parser = Parser.new(StringIO.new(source))
    parser.advance

    assert_equal "LOOP", parser.symbol
  end

  def test_dest
    source = "D=M\nAMD=M+1;JMP\nD;JEQ"
    parser = Parser.new(StringIO.new(source))

    parser.advance

    assert_equal "D", parser.dest

    parser.advance

    assert_equal "AMD", parser.dest

    parser.advance

    assert_equal nil, parser.dest
  end

  def test_comp
    source = "D=M\nAMD=M+1;JMP\nD;JEQ"
    parser = Parser.new(StringIO.new(source))

    parser.advance

    assert_equal "M", parser.comp

    parser.advance

    assert_equal "M+1", parser.comp

    parser.advance

    assert_equal "D", parser.comp
  end

  def test_jump
    source = "D=M\nAMD=M+1;JMP\nD;JEQ"
    parser = Parser.new(StringIO.new(source))

    parser.advance

    assert_equal nil, parser.jump

    parser.advance

    assert_equal "JMP", parser.jump

    parser.advance

    assert_equal "JEQ", parser.jump
  end

  def test_pong_problems
    source = "M=!M\nM=D&M\nM=D|M"
    parser = Parser.new(StringIO.new(source))

    parser.advance   # M=!M

    assert_equal "M", parser.dest
    assert_equal "!M", parser.comp
    assert_equal nil, parser.jump

    parser.advance   # M=D&M

    assert_equal "M", parser.dest
    assert_equal "D&M", parser.comp
    assert_equal nil, parser.jump

    parser.advance   # M=D|M

    assert_equal "M", parser.dest
    assert_equal "D|M", parser.comp
    assert_equal nil, parser.jump
  end

end
