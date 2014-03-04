require 'minitest/autorun'
require 'minitest/pride'
require_relative 'assembler'

class AssemblerTest < Minitest::Test

  def test_assemble_assembles_correct_cinstruction
    instruction = ["D=D+M"]
    machine_code = Assembler.assemble instruction
    expected = "1111000010010000"
    assert_equal expected, machine_code[0]
  end

  def test_assemles_ainstruction
    instruction = ["@5345"]
    machine_code = Assembler.assemble instruction
    expected = "0001010011100001"
    assert_equal expected, machine_code[0]
  end

  def test_assembles_ainstruction_with_correct_rom_address
    instruction = ["D=D+M", "(init)", "@init"]
    machine_code = Assembler.assemble instruction
    expected = "0000000000000001"
    assert_equal expected, machine_code[1]
  end

end
