require_relative './n2t_code'

class Assembler
  class Parser
    class Command
      attr_reader :command

      def initialize(command)
        @command = command
        remove_comments
      end

      def value
        case command_type
        when 'A_COMMAND'
          address_value_or_label
        when 'L_COMMAND'
          command.match(/^\((.*)\)/)[1]
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

      def l_command?
        command_type == 'L_COMMAND'
      end

      def a_command?
        command_type == 'A_COMMAND'
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

      def address_value_or_label
        if command.match(/^@\d+/)
          command.match(/@(.*)/)[1].to_i
        else
          command.match(/@(.*)/)[1]
        end
      end

      def remove_comments
        @command = command.gsub(/\/\/.*/, '').strip
      end
    end
  end
end
