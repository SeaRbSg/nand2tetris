require_relative 'symbol_table'
require_relative 'cinstruction'
require 'pry'

class Assembler
  def self.assemble lines
    instructions = []
    line_num = 0
    lines.each do |instruction|
      if is_symbol?(instruction)
        SymbolTable.set_symbol(instruction, line_num)
      elsif is_a_instruction? instruction
        instructions << ->() { a_instruction(SymbolTable.get_variable(instruction)) }
        line_num += 1
      else
        instructions << ->() { CInstruction.assemble instruction }
        line_num += 1
      end
    end
    instructions.map do |lambda|
      lambda.()
    end
  end

  def self.is_symbol? instruction
    instruction.start_with?('(')
  end

  def self.is_a_instruction? instruction
    instruction.start_with? '@'
  end

  def self.a_instruction number
    ("%.16b" % number)
  end
end
