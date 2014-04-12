require_relative 'tokenizer'

class Compiler
  def self.compile text
    tokens = Tokenizer.tokenize(text)
    compiler = new(tokens)
    compiler.compiled
  end

  def initialize tokens
    @tokens = TokenStream.new(tokens)
  end

  def compiled
    return @compiled if @compiled
    compile
    @compiled
  end

  def compile
    me = [@tokens.consume(:class), @tokens.consume(:identifier), @tokens.consume('{')]
    me << compile_class_variable_declarations
    me << compile_subroutines
    me << @tokens.consume('}')
    @compiled = [:class, me]
  end

  def compile_class_variable_declarations
    me = []
    while @tokens.peek? %w[static field]
      me << compile_class_variable_declaration
    end
    me
  end

  def compile_class_variable_declaration
    types = %w[int char boolean identifier]
    me = [@tokens.consume(%w[static field]), @tokens.consume(types), @tokens.consume(:identifier)]

    while @tokens.peek? ","
      me << @tokens.consume(',')
      me << @tokens.consume(:identifier)
    end

    me << @tokens.consume(';')
    [:classVarDec, me]
  end

  def compile_subroutines
    me = []
    while @tokens.peek? %w[constructor function method]
      me << compile_subroutine
    end
    me
  end

  def compile_subroutine
    me = [@tokens.consume(%w[function constructor method]), @tokens.consume(%w[int char boolean identifier void]), @tokens.consume(:identifier), @tokens.consume('(')]
    me << compile_parameter_list
    me << @tokens.consume(')')
    me << compile_subroutine_body
    [:subroutineDec, me]
  end

  def compile_parameter_list
    types = %w[int char boolean]

    me = []

    if @tokens.peek?(types) || @tokens.peek?(:identifier)
      me << @tokens.consume(types)
      me << @tokens.consume(:identifier)
    end

    while @tokens.peek? ','
      me << @tokens.consume(',')
      me << @tokens.consume(types)
      me << @tokens.consume(:identifier)
    end

    [:parameterList, me]
  end

  def compile_subroutine_body
    me = [@tokens.consume('{')]
    me << compile_variable_declarations
    me << compile_statements
    me << @tokens.consume('}')
    [:subroutineBody, me]
  end

  def compile_variable_declarations
    me = []
    while @tokens.peek? "var"
      me << compile_variable_declaration
    end
    me
  end

  def compile_variable_declaration
    me = [@tokens.consume(:var), @tokens.consume(%w[int char boolean identifier]), @tokens.consume(:identifier)]

    while @tokens.peek? ","
      me << @tokens.consume(',')
      me << @tokens.consume(:identifier)
    end

    me << @tokens.consume(';')
    [:varDec, me]
  end

  def compile_statements
    me = []
    while @tokens.peek? %w[let if while do return]
      me << case @tokens.peek.last
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
    me = [@tokens.consume(:let), @tokens.consume(:identifier)]

    if @tokens.peek? '['
      me << @tokens.consume('[')
      me << compile_expression
      me << @tokens.consume(']')
    end

    me << @tokens.consume('=')
    me << compile_expression
    me << @tokens.consume(';')
    [:letStatement, me]
  end

  def compile_if
    me = [@tokens.consume(:if), @tokens.consume('(')]
    me << compile_expression
    me << @tokens.consume(')')
    me << @tokens.consume('{')
    me << compile_statements
    me << @tokens.consume('}')

    if @tokens.peek? 'else'
      me << @tokens.consume('else')
      me << @tokens.consume('{')
      me << compile_statements
      me << @tokens.consume('}')
    end

    [:ifStatement, me]
  end

  def compile_while
    me = [@tokens.consume(:while), @tokens.consume('(')]
    me << compile_expression
    me << @tokens.consume(')')
    me << @tokens.consume('{')
    me << compile_statements
    me << @tokens.consume('}')
    [:whileStatement, me]
  end

  def compile_do
    me = [@tokens.consume(:do)]
    me << compile_subroutine_call
    me << @tokens.consume(';')
    [:doStatement, me]
  end

  def compile_return
    me = [@tokens.consume(:return)]
    me << compile_expression
    me << @tokens.consume(';')
    [:returnStatement, me]
  end

  def compile_subroutine_call
    me = [@tokens.consume(:identifier)]

    if @tokens.peek? '.'
      me << @tokens.consume('.')
      me << @tokens.consume(:identifier)
    end

    me << @tokens.consume('(')
    me << compile_expression_list
    me << @tokens.consume(')')
    me
  end

  def compile_expression_list
    me = [compile_expression]

    while @tokens.peek? ","
      me << @tokens.consume(',')
      me << compile_expression
    end

    [:expressionList, me]
  end

  def compile_expression
    ops = %w[+ - * / & | < > =]
    me = [compile_term].compact

    return if me.empty?

    while @tokens.peek?(ops)
      me << @tokens.consume(ops)
      me << compile_term
    end

    [:expression, me]
  end

  def compile_term
    unary_ops = %w[- ~]
    me = []

    case @tokens.peek.first
    when :integerConstant, :stringConstant, :keyword
      me << @tokens.consume([:integerConstant, :stringConstant, :keyword])
    when :symbol
      if @tokens.peek? '('
        me << @tokens.consume('(')
        me << compile_expression
        me << @tokens.consume(')')
      elsif @tokens.peek? unary_ops
        me << @tokens.consume(unary_ops)
        me << compile_term
      end
    else
      if @tokens.peek? %w[( .], 1
        me << compile_subroutine_call
      elsif @tokens.peek? '[', 1
        me << @tokens.consume(:identifier)
        me << @tokens.consume('[')
        me << compile_expression
        me << @tokens.consume(']')
      else
        me << @tokens.consume(:identifier)
      end
    end

    return if me.empty?
    [:term, me]
  end

  class TokenStream
    def initialize tokens
      @tokens = tokens
    end

    TOKENS = {}
    Tokenizer::Symbol::SYMBOLS.each {|s| TOKENS[s] = Tokenizer::Symbol.new(s).to_token}
    Tokenizer::Keyword::KEYWORDS.each {|s| TOKENS[s] = Tokenizer::Keyword.new(s).to_token}

    def consume tokens=nil
      tokens = Array(tokens)
      unless tokens.empty?
        raise_error(tokens) unless peek?(tokens)
      end

      @tokens.shift
    end

    def peek? tokens, lookahead=0
      Array(tokens).map(&:to_s).any? do |token|
        @tokens[lookahead] == TOKENS[token] || @tokens[lookahead].first.to_s == token
      end
    end

    def peek lookahead=0
      @tokens[lookahead]
    end

    def raise_error tokens
      tokens = Array(tokens).map {|t| "'#{t}'" }.join(" | ")
      raise Error.new, "expected #{tokens}, found #{peek}"
    end

    class Error < StandardError ; end
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
