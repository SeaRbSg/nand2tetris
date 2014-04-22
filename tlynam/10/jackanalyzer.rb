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
    when /^[a-zA-Z_]/
      return "identifier"
    when /^\d/
      return "integerConstant"
    when /^"/
      line.gsub!(/["\n]/,"")
      return "stringConstant"
    else
      raise "Unhandled Line #{line}" 
    end
  end

  def tokenwrite(output,xml,val)
    output.write "<#{xml}> #{val} </#{xml}>\n"
  end

end

class CompilationEngine

  def compilewrite(output,xml,val)
    File.open(output, "a") { |f| f.write "<#{xml}> #{val} </#{xml}>\n" }
  end

 #Compile a complete class 
  def compileclass(output,classname)
    #File.open(output, "a") { |f| f.write "<class>\n  <" }
  end

#Compile a static declaration or a field declaration
  def compileclassvardec(token)


  end

#Compile a complete method, function, or constructor
  def compilesubroutine

  end

#Compile a possibly empty parameter list, not including the ()
  def compileparameterlist

  end

#Compile a var declaration
  def compilevardec

  end

#Compile a sequence of statements, not including the {}
  def compilestatement

  end

#Compile a do statement
  def compiledo

  end

#Compile a let statement
  def compilelet

  end

#Compile a while statement
  def compilewhile

  end

#Compile a return statement
  def compilereturn

  end

#Compile an if statement, possibly with trailing else clause
  def compileif

  end

#Compile an express
  def compileexpression

  end

#Compile a term.  Must determine if current token is an idenifier.  Must distinguish between a variable, an arrary, and subrouting call.  A single lookahead token, which may be of [ ( or . suffices to distinguish between the three possibilities.  Any other token is not part of this term and shouldn't be advanced over.
  def compileterm

  end

#Compile a possibly empty comma-separated list of expressions
  def compileexpressionlist

  end

end

inputfiles = []
ary = []
filefolder = ARGV[0]

if filefolder.nil?
  puts "Please pass file or folder name"
elsif !filefolder.nil?
  if Dir.exist?(filefolder)
    Dir.entries(filefolder).each {|file|
      inputfiles << filefolder + "/" + file[/^\w*.jack/] unless file[/^\w*.jack/].nil?
    }
  elsif File.exist?(filefolder)
    inputfiles << filefolder
  end
end

inputfiles.each { |inputfile|
  outputfile = inputfile.gsub(".jack","_tokens.xml")
  compileoutputfile = inputfile.gsub(".jack","_compile.xml")
  File.open(outputfile, "w") { |f| 
    f.write "<tokens>\n" 
    File.open(inputfile, "r") { |file|
      cleanfile = file.read
      cleanfile.gsub!(/\/\/.*/,"")
      cleanfile.gsub!(/\/\*(.|\n)*?\*\//,"")
      #How use \W instead of [\];\.{},+\-*&|<>=~()"]
      parts = cleanfile.scan(/[\[\];\.{},+\-\/*&|<>=~()]|"[^"\n]*"|\w+/)
      tokenfile = Tokenizer.new
      compilefile = CompilationEngine.new
      compilefile.compileclass(compileoutputfile,parts[1])
      parts.each {|part|
        puts part
        tokentype = tokenfile.tokentype(part)
        puts tokentype
        case part
        when /"/
          part = part[1..-2]
        when "<"
          part = "&lt;"
        when ">"
          part = "&gt;"
        when "&"
          part = "&amp;"
        else
          part = part
        end
        tokenfile.tokenwrite(f,tokentype,part)
      }
    }
    f.write "</tokens>\n" 
  }
}