require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative './tokenizer'

class ParserTests < Minitest::Test
  def test_tokenizes_empty_class
    tokenizer = Tokenizer.new "class Memory { }"

    tokens = tokenizer.first(4)

    assert_equal :keyword, tokens[0].type
    assert_equal 'class', tokens[0].value

    assert_equal :identifier, tokens[1].type
    assert_equal 'Memory', tokens[1].value

    assert_equal :symbol, tokens[2].type
    assert_equal '{', tokens[2].value

    assert_equal :symbol, tokens[3].type
    assert_equal '}', tokens[3].value
  end

  def test_igrores_single_line_comments
    tokenizer = Tokenizer.new "// comment\nclass Memory { }"

    token = tokenizer.first

    assert_equal :keyword, token.type
    assert_equal 'class', token.value
  end

  def test_igrores_end_of_line_comments
    tokenizer = Tokenizer.new "class Memory { } // ignore this\n"

    token = tokenizer.first

    assert_equal :keyword, token.type
    assert_equal 'class', token.value
  end
end
