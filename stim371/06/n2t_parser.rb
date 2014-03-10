require 'n2t_command'

class Assembler
  class Parser
    attr_reader :lines

    def initialize(file)
      @line_index = 0
      @lines = File.readlines(file).map(&:strip)
    end

    def more_commands?
      (@line_index + 1) <= lines.length
    end

    def advance
      @line_index += 1
    end

    def command
      Command.new(lines[@line_index])
    end

    def translate_current_command
      command.translate
    rescue => e
      p "failed on line #{@line_index + 1} ('#{command.inspect}')"
      raise e
    end
  end
end
