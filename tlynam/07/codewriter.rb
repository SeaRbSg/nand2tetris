class CodeWriter

=begin
  Method: Constructor/initializer
  Args: Output file/stream
  Returns: nil
  Function: Opens the output file/stream and gets ready to write it.
=end
  def initialize 

  end

=begin
 Method: setFileName
 Args: fileName (string)
 Function: Informs code writer that the translation of a new VM file is started
=end
  def setfilename

  end

=begin
 Method: writearithmetic
 Args: command (string)
 Function: Writes the assembly code that is the translation of the given arithmetic command.
=end
  def writearithmetic

  end

=begin
 Method: writepushpop
 Args: command (C_PUSH or C_POP), segment (string), index (int)
 Function: Writes the assembly code that is the translation of the given command, where command is either C_PUSH or C_POP.
=end
  def writepushpop(command)
    case command
    when "C_POP"
      return self.stack.last
    when "C_PUSH"
      
  end

=begin
 Method: close
 Args: -
 Returns: -
 Function: Closes the output file
=end
  def close

  end

end