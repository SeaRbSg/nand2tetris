require 'n2t_code'

class Assembler
  class Parser
    class Command
      attr_reader :command

      def initialize(command)
        @command = command
      end

      def value
        if command_type == 'A_COMMAND'
          command.match(/@(.*)/)[1].to_i
        else
          command
        end
      end

      def command_type
        case command
        when /^\/\//
          nil
        when /^\(.*\)/
          'L_COMMAND'
        when /(?:=|;)/
          'C_COMMAND'
        when /^@.*/
          'A_COMMAND'
        else
          nil
        end
      end

      def real?
        !!command_type
      end

      def dest
        (command.match(/^(.*)=/) || [])[1]
      end

      def comp
        (
          command.match(/=([^;]*)/) ||
          command.match(/([^;]*);/) ||
          []
        )[1]
      end

      def jump
        (command.match(/;(.*)/) || [])[1]
      end

      def symbol
        (
          command.match(/@(.*)/) ||
          command.match(/\((.*)\)/) ||
          []
        )[1]
      end

      def translate
        if command_type == 'A_COMMAND'
          "%016b" % value
        else
          [111, Code.comp(comp), Code.dest(dest), Code.jump(jump)].join
        end
      end
    end
  end
end
