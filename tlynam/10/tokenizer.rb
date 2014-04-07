class Tokenizer

=begin
  Method: tokentype
  Args: -
  Returns: KEYWORD, SYMBOL, IDENTIFIER, INT_CONST, STRING_CONST
  Function: Returns the type of the current token
=end
  def tokentype(line)
    case line
    when "", "\n"
    when "class", "constructor", "function", "method", "field", "static", "var", "int", "char", "boolean", "void", "true", "false", "null", "this", "let", "do", "if", "else", "while", "return"
      return "keyword"
    when "{", "}", "(", ")", "[", "]", ".", ",", ";", "+", "-", "*", "/", "&", "|", "<", ">", "=", "~"
      return "symbol" 
    when /^[a-zA-Z_]\w*/
      return "identifier"
    when /^\d*/
      return "integerConstant"
    when /^"\w*"/
      line.gsub!(/["\n]/,"")
      return "stringConstant"
    else
      raise "Unhandled Line #{line}" 
    end
  end

  def tokenwrite(output,xml,val)
    File.open(output, "a") { |f| f.write "<#{xml}> #{val} </#{xml}>\n" }
  end

end