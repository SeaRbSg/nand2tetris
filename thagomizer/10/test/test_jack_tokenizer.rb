gem "minitest"
require 'minitest/autorun'
require_relative '../lib/jack_tokenizer'

class TestJackTokenizer < Minitest::Test
  make_my_diffs_pretty!

  def setup
    @tokenizer = JackTokenizer.new
  end

  def test_has_more_tokens_when_more_tokens
    @tokenizer.input = "class Main {"

    assert @tokenizer.has_more_commands?
  end

  def test_has_more_tokens_when_no_more_tokens
    @tokenizer.input = ""

    refute @tokenizer.has_more_commands?
  end

  def test_advance
    @tokenizer.input = "class Main {"

    @tokenizer.advance

    assert_equal "class", @tokenizer.current_token.token
  end

  def test_advance_with_comments
    @tokenizer.input = "// This file is part of www.nand2tetris.org\nclass"

    @tokenizer.advance

    assert_equal "class", @tokenizer.current_token.token
  end

  def test_detection_of_string_constants
    @tokenizer.input = 'Keyboard.readInt("HOW MANY NUMBERS? ");'

    @tokenizer.advance
    assert_equal "Keyboard", @tokenizer.current_token.token
    assert_equal :identifier, @tokenizer.current_token.type

    @tokenizer.advance
    assert_equal ".", @tokenizer.current_token.token
    assert_equal :symbol, @tokenizer.current_token.type


    @tokenizer.advance
    assert_equal "readInt", @tokenizer.current_token.token
    assert_equal :identifier, @tokenizer.current_token.type

    @tokenizer.advance
    assert_equal "(", @tokenizer.current_token.token
    assert_equal :symbol, @tokenizer.current_token.type

    @tokenizer.advance
    assert_equal "HOW MANY NUMBERS? ", @tokenizer.current_token.token
    assert_equal :string_constant, @tokenizer.current_token.type

    @tokenizer.advance
    assert_equal ")", @tokenizer.current_token.token
    assert_equal :symbol, @tokenizer.current_token.type

    @tokenizer.advance
    assert_equal ";", @tokenizer.current_token.token
    assert_equal :symbol, @tokenizer.current_token.type
  end

end
