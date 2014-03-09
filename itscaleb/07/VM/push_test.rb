require 'minitest/autorun'
require 'minitest/pride'
require_relative 'push'

class PushTests < Minitest::Test
  def test_push_constant
    push = Push.new "constant", 7
    asm = push.to_asm
    assert_equal "@7", asm[0]
    assert_equal "D=A", asm[1]
    assert_equal "@SP", asm[2]
    assert_equal "A=M", asm[3]
    assert_equal "M=D", asm[4]
    assert_equal "@SP", asm[5]
    assert_equal "M=M+1", asm[6]
  end
end
