require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative './tokenizer'

class ParserTests < Minitest::Test

  def test_tokenizes_empty_class
    tokenizer = Tokenizer.new "class Memory \n{ \n}"

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

  def test_tokenizes_class_with_instance_var
    tokenizer = Tokenizer.new "class Person\n{\nvar name;\}"

    binding.pry
    var_keyword = tokenizer.find {|token| token.value == "var"}
    var_identifier = tokenizer.find {|token| token.value == "name"}
    semicolon = tokenizer.find {|token| token.value == ";"}

    assert_equal :keyword, var_keyword.type
    assert_equal :identifier, var_identifier.type
    assert_equal :symbol, semicolon.type
  end

  def test_ignores_comments
    tokenizer = Tokenizer.new "// comment\nclass Memory { }"

    token = tokenizer.first

    assert_equal :keyword, token.type
    assert_equal 'class', token.value
  end

end
