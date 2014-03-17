require_relative './n2t_command'
require_relative './n2t_symbol_table'

class Assembler
  class Parser
    attr_reader :lines

    def initialize(file)
      @line_index = 0
      @lines = File.readlines(file).map(&:strip)
      clean_code
      generate_symbol_table
    end

    def more_commands?
      (@line_index + 1) <= lines.length
    end

    def advance
      @line_index += 1
    end

    def current_row
      lines[@line_index]
    end

    def command
      Command.new(lines[@line_index])
    end

    def translate_current_command
      case
      when command.a_command?
        if current_row.match(/^@\d+/)
          "%016b" % command.value
        else
          "%016b" % symbol_table.address_for(command.value)
        end
      else
        [111, Code.comp(command.comp), Code.dest(command.dest), Code.jump(command.jump)].join
      end
    rescue => e
      p "failed on line #{@line_index + 1} ('#{command.inspect}')"
      raise e
    end

    def symbol_table
      @table ||= Assembler::SymbolTable.new
    end

    private

    def clean_code
      @lines = lines.select {|line| Command.new(line).real? }
    end

    def generate_symbol_table
      # for each line, if it is a parens, add it and its location to the table
      while more_commands?
        if command.l_command?
          symbol_table.add_entry(command.value, @line_index)
          @lines.delete_at(@line_index)
        else
          advance
        end
      end

      @line_index = 0
    end
  end
end
