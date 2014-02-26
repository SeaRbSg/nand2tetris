require 'stringio'

class Parser
  attr_accessor :current_command

  def initialize(source)
    @source = source
    self.advance
  end

  def advance
    if has_more_commands?
      @current_command = @source.gets.strip
    end
  end

  def has_more_commands?
    !@source.eof?
  end

  def command_type
    case @current_command
    when /@/
      :a_command
    when /[=;]/
      :c_command
    when /\(.*\)/
      :l_command
    end
  end

  def symbol
    @current_command =~ /[@\(](\w+)\)?/
    $1
  end

  def dest
    @current_command =~ /(\w*)=/
    $1
  end
end
