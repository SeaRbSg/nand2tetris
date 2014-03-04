class Parser
  C_COMMAND_REGEX = /(?:(\w+)=)?([!&|\w+-]+)(?:;(\w+))?/
  A_COMMAND_REGEX = /@/
  L_COMMAND_REGEX = /\(.*\)/

  attr_accessor :current_command, :eof, :dest, :comp, :jump

  def initialize source
    @source = source
    @current_command = ''
  end

  def advance
    begin
      @current_command = @source.gets.gsub(/(\/\/.*$)/, '').gsub(/\s+/,'')
    end while @current_command.empty?

    command_type
  end

  def has_more_commands?
    !@source.eof
  end

  def reset
    @source.rewind
  end

  def command_type
    case @current_command
    when A_COMMAND_REGEX
      :a_command
    when L_COMMAND_REGEX
      :l_command
    when C_COMMAND_REGEX
      @dest, @comp, @jump = $~.captures
      :c_command
    end
  end

  def symbol
    @current_command =~ /([\w\.$:]+)/
    $1
  end
end
