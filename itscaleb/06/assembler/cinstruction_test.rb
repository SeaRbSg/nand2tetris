require 'minitest/autorun'
require 'minitest/pride'
require_relative 'cinstruction'

class CInstructionTest < Minitest::Test
  def test_cinst_assembles_cinst
    machine_code = CInstruction.assemble "D=D+M"
    expected = "1111000010010000"
    assert_equal expected, machine_code
  end

  def test_cinst_assembles_jump
    machine_code = CInstruction.assemble "0;JMP"
    expected = "1110101010000111"
    assert_equal expected, machine_code
  end

  def test_cinst_assembles_compdestandjump
    machine_code = CInstruction.assemble "AM=D|A;JGE"
    expected = "1110010101101011"
    assert_equal expected, machine_code
  end
end
