class Parser
  PUSH_COMMAND     = /^push(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  POP_COMMAND      = /^pop(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  LABEL_COMMAND    = /^label(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  GOTO_COMMAND     = /^goto(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  IF_COMMAND       = /^if-goto(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  FUNCTION_COMMAND = /^function(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  RETURN_COMMAND   = /^return(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  CALL_COMMAND     = /^call(?:\s+([\w.]+))?(?:\s+(\w+))?$/
  ARTH_COMMAND     = /^(add|sub|neg|eq|gt|lt|and|or|not)(?:\s+([\w.]+))?(?:\s+(\w+))?$/

  attr_accessor :current_command, :arg1, :arg2, :command_type

  def initialize source
    @source = source
    @current_command = ''
  end

  def has_more_commands?
    !@source.eof
  end

  def advance
    begin
      @current_command = @source.gets.gsub(/(\/\/.*$)/, '').gsub(/\s*\n/, '').strip
    end while @current_command.empty?

    @command_type = case @current_command
                    when PUSH_COMMAND
                      :c_push
                    when POP_COMMAND
                      :c_pop
                    when LABEL_COMMAND
                      :c_label
                    when GOTO_COMMAND
                      :c_goto
                    when IF_COMMAND
                      :c_if
                    when FUNCTION_COMMAND
                      :c_function
                    when RETURN_COMMAND
                      :c_return
                    when CALL_COMMAND
                      :c_call
                    when ARTH_COMMAND
                      :c_arithmetic
                    end

    @arg1, @arg2 = $~.captures
    @arg2 = @arg2.to_i
  end
end
