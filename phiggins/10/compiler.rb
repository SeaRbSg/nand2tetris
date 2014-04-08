require_relative 'tokenizer'

class Compiler
  def self.compile text
    tokens = Tokenizer.tokenize(text)
    compiler = new(tokens)
    compiler.compiled
  end

  def initialize tokens
    @tokens = tokens
  end

  def compiled
    return @compiled if @compiled
    compile
    @compiled
  end

  def compile
    me = [@tokens.shift, @tokens.shift, @tokens.shift] # class Foo {
    me << compile_class_variable_declarations
    me << compile_subroutines
    me << @tokens.shift # }
    @compiled = [:class, me]
  end

  def compile_class_variable_declarations
    me = []
    while peek.first == :keyword && %[static field].include?(peek.last)
      me << compile_class_variable_declaration
    end
    me
  end

  def compile_class_variable_declaration
    # field int foo
    me = [@tokens.shift, @tokens.shift, @tokens.shift]

    while peek.first == :symbol && peek.last == ","
      me << @tokens.shift # ,
      me << @tokens.shift # varName
    end

    me << @tokens.shift # ;
    [:classVarDec, me]
  end

  def compile_subroutines
    me = []
    while peek.first == :keyword && %w[constructor function method].include?(peek.last)
      me << compile_subroutine
    end
    me
  end

  def compile_subroutine
    # function void main (
    me = [@tokens.shift, @tokens.shift, @tokens.shift, @tokens.shift]
    me << compile_parameter_list
    me << @tokens.shift # )
    me << compile_subroutine_body
    [:subroutineDec, me]
  end

  def compile_parameter_list
    me = []

    if ((peek.first == :keyword && %w[int char boolean].include?(peek.last)) || peek.first == :identifier)
      me << @tokens.shift # type
      me << @tokens.shift # varName
    end

    while peek.first == :symbol && peek.last == ','
      me << @tokens.shift # ,
      me << @tokens.shift # type
      me << @tokens.shift # varName
    end

    [:parameterList, me]
  end

  def compile_subroutine_body
    me = [@tokens.shift] # {
    me << compile_variable_declarations
    me << compile_statements
    me << @tokens.shift # }
    [:subroutineBody, me]
  end

  def compile_variable_declarations
    me = []
    while peek.first == :keyword && peek.last == "var"
      me << compile_variable_declaration
    end
    me
  end

  def compile_variable_declaration
    me = [@tokens.shift, @tokens.shift, @tokens.shift] # var int foo

    while peek.first == :symbol && peek.last == ","
      me << @tokens.shift # ,
      me << @tokens.shift # varName
    end

    me << @tokens.shift # ;
    [:varDec, me]
  end

  def compile_statements
    me = []
    while peek.first == :keyword && %w[let if while do return].include?(peek.last)
      me << case peek.last
        when 'let'    ; compile_let
        when 'if'     ; compile_if
        when 'while'  ; compile_while
        when 'do'     ; compile_do
        when 'return' ; compile_return
      end
    end
    [:statements, me]
  end

  def compile_let
    me = [@tokens.shift, @tokens.shift] # let foo

    if peek.first == :symbol && peek.last == '['
      me << @tokens.shift # [
      me << compile_expression
      me << @tokens.shift # ]
    end

    me << @tokens.shift # =
    me << compile_expression
    me << @tokens.shift # ;
    [:letStatement, me]
  end

  def compile_if
    me = [@tokens.shift, @tokens.shift] # if (
    me << compile_expression
    me << @tokens.shift # )
    me << @tokens.shift # {
    me << compile_statements
    me << @tokens.shift # }

    if peek.first == :keyword && peek.last == 'else'
      me << @tokens.shift # else
      me << @tokens.shift # {
      me << compile_statements
      me << @tokens.shift # }
    end

    [:ifStatement, me]
  end

  def compile_while
    me = [@tokens.shift, @tokens.shift] # while (
    me << compile_expression
    me << @tokens.shift # )
    me << @tokens.shift # {
    me << compile_statements
    me << @tokens.shift # }
    [:whileStatement, me]
  end

  def compile_do
    me = [@tokens.shift] # do
    me << compile_subroutine_call
    me << @tokens.shift # ;
    [:doStatement, me]
  end

  def compile_return
    me = [@tokens.shift] # return
    me << compile_expression
    me << @tokens.shift # ;
    [:returnStatement, me]
  end

  def compile_subroutine_call
    me = [@tokens.shift] # subroutineName | className | varName

    if peek.first == :symbol && peek.last == '.'
      me << @tokens.shift # .
      me << @tokens.shift # subroutineName
    end

    me << @tokens.shift # (
    me << compile_expression_list
    me << @tokens.shift # )
    me
  end

  def compile_expression_list
    me = [compile_expression]

    while peek.first == :symbol && peek.last == ","
      me << @tokens.shift # ,
      me << compile_expression
    end

    [:expressionList, me]
  end

  def compile_expression
    me = [compile_term].compact

    return if me.empty?

    while peek.first == :symbol && %w[+ - * / & | < > =].include?(peek.last)
      me << @tokens.shift # op
      me << compile_term
    end

    [:expression, me]
  end

  def compile_term
    me = []

    case peek.first
    when :integerConstant, :stringConstant, :keyword
      me << @tokens.shift
    when :symbol
      if peek.last == '('
        me << @tokens.shift # (
        me << compile_expression
        me << @tokens.shift # )
      elsif peek.last == "-" || peek.last == "~"
        me << @tokens.shift # unaryOp
        me << compile_term
      end
    else
      peek_peek = @tokens[1]

      if peek_peek.first == :symbol && %w[( .].include?(peek_peek.last)
        me << compile_subroutine_call
      elsif peek_peek.first == :symbol && peek_peek.last == '['
        me << @tokens.shift # varName
        me << @tokens.shift # [
        me << compile_expression
        me << @tokens.shift # ]
      else
        me << @tokens.shift # varName
      end
    end

    return if me.empty?
    [:term, me]
  end

  def peek
    @tokens.first
  end
end


if $0 == __FILE__
  input = ARGV.first

  unless input && File.exists?(input)
    abort "Usage: #{$0} input"
  end

  def dump_xml things, indent=0
    return if things.nil?
    head, rest = things.first, things.last

    case
    when Symbol === head && String === rest
      if head == :symbol
        rest = case rest
        when '>' then '&gt;'
        when '<' then '&lt;'
        when '&' then '&amp;'
        else ;        rest
        end
      end

      puts "#{" " * indent}<#{head}> #{rest} </#{head}>"
    when Symbol === head && Array === rest
      puts "#{" " * indent}<#{head}>"
      dump_xml rest, indent + 2
      puts "#{" " * indent}</#{head}>"
    when Array
      things.each {|t| dump_xml t, indent }
    end
  end

  dump_xml(Compiler.compile(File.read(input)))
end
