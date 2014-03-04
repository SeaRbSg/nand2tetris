require 'stringio'

class Parser
  C_COMMAND_REGEX = /(?:(\w+)=)?([!&|\w+-]+)(?:;(\w+))?/
  A_COMMAND_REGEX = /@/
  L_COMMAND_REGEX = /\(.*\)/

  attr_accessor :current_command, :eof

  def initialize(source)
    @source = source
    @eof = @source.eof?
    @current_command = ''
  end

  def advance
    begin
      x = @source.gets
      @current_command = x.gsub(/\/\/.*/, '').gsub(/\s+/,'')

      if @source.eof
        @eof = true
        break
      end
    end while @current_command.empty?
  end

  def has_more_commands?
    !self.eof
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
    @current_command =~ /([\w\.$:]+)/
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
