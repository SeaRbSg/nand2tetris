=begin
Break each assembly command into its underlying components as in fields and symbols
Reads assembly language command, parses, and provides access to the command's components as in fields and symbols.  Remove comments and white space.
=end
class Parser
=begin
  Method: Constructor/initializer
  Args: Input file/stream
  Returns: nil
  Function: Opens the input file/stream and gets ready to parse it.
=end
  attr_accessor :symbol_table
  def initialize 
    @symbol_table = {}
  end

=begin
  Method: hasMoreCommands
  Args: nil
  Returns: Boolean
  Function: Are there more commands in the input?
=end

=begin
  Method: advance
  Args: nil
  Returns: nil
  Function: Reads the next command from the input and makes it the current command.  Should be called only is hasMoreCommands() is true.  Initially there is no current command.
=end

=begin
  Method: commandType
  Args: nil
  Returns: A_COMMAND, C_COMMAND, or L_COMMAND
  Function: Returns the type of the current command.
  A_COMMAND for @Xxx where Xxx is either a symbol or a decimal number.
  C_COMMAND for dest=comp;jump comp;jump dest=comp
  L_COMMAND (actually pseudo-command) for (Xxx) where Xxx is a symbol
=end
  def commandtype(line)
    case line
    when /^@/
      return "A_COMMAND"
    when /^*=/
      return "C_COMMAND"
    when /^*;/
      return "C_COMMAND"
    when /^*\(/
      return "L_COMMAND"
    end
  end

=begin
  Method: symbol
  Args: nil
  Returns: string
  Function: Returns the symbol or decimal Xxx of the current command @Xxx or (Xxx).  Should be called only when commandType() is A_COMMAND or L_COMMAND
=end
  def symbol(line)
    return line[/^*\d+/].to_i
  end

=begin
  Method: dest
  Args: nil
  Returns: string
  Function: Returns the dest mnemonic in the current C-command (8 possibilities)  Should be called only when commandType() is C_COMMAND
=end
  def dest(line)
    if line[/[=]/]
      return line[/^\w/].to_s
    elsif line[/;/]
      return ""
    end

    return 
  end

=begin
  Method: comp
  Args: nil
  Returns: string
  Function: Returns the comp mnemonic in the current C-command (28 possibilities).  Should be called only when commandType() is C_COMMAND
=end
  def comp(line)
    str = ""
    
    if line[/[=]/]
      str = line.gsub(/^\w/,'')
      str = str[/^=\S+/]
      return str[1..3]
    elsif line[/;/]
      return line[/^\w/]
    end
  end

=begin
  Method: jump
  Args: nil
  Returns: string
  Function: Returns the jump mnemonic in the current C-command (8 possibilities).  
=end
  def jump(line)
    return line[/(JGT)|(JEQ)|(JGE)|(JLT)|(JNE)|(JLE)|(JMP)/]
  end

=begin
  Method: dest
  Args: mnemonic (string)
  Returns: 3 bits
  Function: Returns the binary code of the dest mnemonic
=end
  def write_dest(output, dest_mnemonic)
    case dest_mnemonic
    when ""
      File.open(output, "a") { |f| f.write "000"}
    when "M"
      File.open(output, "a") { |f| f.write "001"}
    when "D"
      File.open(output, "a") { |f| f.write "010"}
    when "MD"
      File.open(output, "a") { |f| f.write "011"}
    when "A"
      File.open(output, "a") { |f| f.write "100"}
    when "AM"
      File.open(output, "a") { |f| f.write "101"}
    when "AD"
      File.open(output, "a") { |f| f.write "110"}
    when "AMD"
      File.open(output, "a") { |f| f.write "111"}
    end
  end

=begin
  Method: comp
  Args: mnemonic (string)
  Returns: 7 bits
  Function: Returns the binary code of the comp mnemonic
=end
  def write_comp(output, comp_mnemonic)
    case comp_mnemonic
    when "0"
      File.open(output, "a") { |f| f.write "0101010"}
    when "1"
      File.open(output, "a") { |f| f.write "0111111"}
    when "-1"
      File.open(output, "a") { |f| f.write "0111010"}
    when "D"
      File.open(output, "a") { |f| f.write "0001100"}
    when "A"
      File.open(output, "a") { |f| f.write "0110000"}
    when "!D"
      File.open(output, "a") { |f| f.write "0001101"}
    when "!A"
      File.open(output, "a") { |f| f.write "0110001"}
    when "-D"
      File.open(output, "a") { |f| f.write "0001111"}
    when "-A"
      File.open(output, "a") { |f| f.write "0110011"}
    when "D+1"
      File.open(output, "a") { |f| f.write "0011111"}
    when "A+1"
      File.open(output, "a") { |f| f.write "0110111"}
    when "D-1"
      File.open(output, "a") { |f| f.write "0001110"}
    when "A-1"
      File.open(output, "a") { |f| f.write "0110010"}
    when "D+A"
      File.open(output, "a") { |f| f.write "0000010"}
    when "D-A"
      File.open(output, "a") { |f| f.write "0010011"}
    when "A-D"
      File.open(output, "a") { |f| f.write "0000111"}
    when "D&A"
      File.open(output, "a") { |f| f.write "0000000"}
    when "D|A"
      File.open(output, "a") { |f| f.write "0010101"}
    when "M"
      File.open(output, "a") { |f| f.write "1110000"}
    when "!M"
      File.open(output, "a") { |f| f.write "1110001"}
    when "-M"
      File.open(output, "a") { |f| f.write "1110011"}
    when "M+1"
      File.open(output, "a") { |f| f.write "1110111"}
    when "M-1"
      File.open(output, "a") { |f| f.write "1110010"}
    when "D+M"
      File.open(output, "a") { |f| f.write "1000010"}
    when "D-M"
      File.open(output, "a") { |f| f.write "1010011"}
    when "M-D"
      File.open(output, "a") { |f| f.write "1000111"}
    when "D&M"
      File.open(output, "a") { |f| f.write "1000000"}
    when "D|M"
      File.open(output, "a") { |f| f.write "1010101"}
    else
      File.open(output, "a") { |f| f.write "0000000"}
    end
  end

=begin 
  Method: jump
  Args: mnemonic (string)
  Returns: 3 bits
  Function: Returns the binary code of the jump mnemonic
=end
  def write_jump(output, jump_mnemonic)
    case jump_mnemonic
    when nil
      File.open(output, "a") { |f| f.write "000"}
    when "JGT"
      File.open(output, "a") { |f| f.write "001"}
    when "JEQ"
      File.open(output, "a") { |f| f.write "010"}
    when "JGE"
      File.open(output, "a") { |f| f.write "011"}
    when "JLT"
      File.open(output, "a") { |f| f.write "100"}
    when "JNE"
      File.open(output, "a") { |f| f.write "101"}
    when "JLE"
      File.open(output, "a") { |f| f.write "110"}
    when "JMP"
      File.open(output, "a") { |f| f.write "111"}
    end
  end
end