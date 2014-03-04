require 'stringio'

class Parser
  C_COMMAND_REGEX = /(?:(\w+)=)?([\w+-]+)(?:;(\w+))?/
  A_COMMAND_REGEX = /@/
  L_COMMAND_REGEX = /\(.*\)/

  attr_accessor :current_command

  def initialize(source)
    @source = source
    self.advance
  end

  def advance
    if has_more_commands?
      begin
        @current_command = @source.gets.gsub(/\/\/.*/, '').gsub(/\s+/,'')
      end while @current_command.empty?
    end
  end

  def has_more_commands?
    !@source.eof?
  end

  def command_type
    case @current_command
    when A_COMMAND_REGEX
      :a_command
    when L_COMMAND_REGEX
      :l_command
    when C_COMMAND_REGEX
      :c_command
    end
  end

  def symbol
    @current_command =~ /([\w_\.$:][\w_\.$:]*)/
    $1
  end

  def dest
    @current_command =~ C_COMMAND_REGEX
    $1
  end

  def comp
    @current_command =~ C_COMMAND_REGEX
    $2
  end

  def jump
    @current_command =~ C_COMMAND_REGEX
    $3
  end
end
