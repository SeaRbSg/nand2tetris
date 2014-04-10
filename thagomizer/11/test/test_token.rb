gem "minitest"
require 'minitest/autorun'
require_relative '../lib/token'

class TestToken < Minitest::Test
  def test_creation
    token = Token.new(:keyword, "class")
    refute_nil token
    assert_equal :keyword, token.type
    assert_equal "class",  token.value
  end
end
