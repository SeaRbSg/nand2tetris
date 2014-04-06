require 'builder'

class CompilationEngine
  attr_accessor :tokens, :output

  def initialize(tokens)
    @tokens = tokens
    @output = ""
    @builder = Builder::XmlMarkup.new(:target => @output, :indent => 1)
  end

  def output_token token
    case token.type
    when :keyword
      @builder.keyword token.value
    when :symbol
      @builder.symbol token.value
    when :identifier
      @builder.identifier token.value
    when :string_constant
      @builder.stringConstant token.value
    when :integer_constant
      @builder.integerConstant token.value
    else
      raise "Unknown token type #{token.type}"
    end
  end

  def compile_var_dec
    @builder.varDec do
      begin
        token = @tokens.shift
        output_token token
      end while (token.value != ";")
    end
  end

  def compile_class_var_dec
    @builder.classVarDec do
      begin
        token = @tokens.shift
        output_token token
      end while (token.value != ";")
    end
  end

  def compile_term
    @builder.term do
      case
      when integer_constant? || string_constant? || keyword_constant?
        output_token @tokens.shift
      when var_name?
        output_token @tokens.shift
        if !@tokens.empty? && @tokens[0].value == "["
          output_token @tokens.shift
          compile_expression
          output_token @tokens.shift
        end
      when @tokens[0].value == "("
        output_token @tokens.shift
        compile_expression
        output_token @tokens.shift
      when unary_op?
        output_token @tokens.shift
        compile_term
      else
        raise "UNKNOWN TERM"
      end
    end
  end

  def compile_expression
    return unless term?
    @builder.expression do
      while term?
        compile_term
        if op?
          output_token @tokens.shift
        else
          break # no symbol so no more of the while loop
        end
      end
    end
  end

  def compile_expression_list
    return unless term?
    @builder.expressionList do
      while term?
        compile_expression
        if @tokens[0].value == ","
          output_token @tokens.shift
        else
          break # no comma so no more of the while loop
        end
      end
    end
  end

  def compile_subroutine_call
    return unless @tokens[0].type == :identifier
    output_token @tokens.shift
    if @tokens[0].value == "."
      output_token @tokens.shift
      raise "Invalid subroutine name" unless @tokens[0].type == :identifier
      output_token @tokens.shift
    end
    output_token @tokens.shift               # (
    compile_expression_list
    output_token @tokens.shift               # )
  end

  def compile_return
    return unless @tokens[0].value == "return"
    @builder.returnStatement do
      output_token @tokens.shift             # return
      compile_expression
      output_token @tokens.shift             # ;
    end
  end

  def compile_do
    return unless @tokens[0].value == "do"
    @builder.doStatement do
      output_token @tokens.shift             # do
      compile_subroutine_call
      output_token @tokens.shift             # ;
    end
  end

  def compile_let
    return unless @tokens[0].value == "let"

    @builder.letStatement do
      output_token @tokens.shift             # let
      output_token @tokens.shift             # varName (identifier)
      if @tokens[0].value == "["
        output_token @tokens.shift           # [
        compile_expression
        output_token @tokens.shift           # ]
      end
      output_token @tokens.shift             # =
      compile_expression
      output_token @tokens.shift             # ;
    end
  end

  def compile_while
    return unless @tokens[0].value == "while"
    @builder.whileStatement do
      output_token @tokens.shift             # while
      output_token @tokens.shift             # (
      compile_expression
      output_token @tokens.shift             # )
      output_token @tokens.shift             # {
      compile_statements
      output_token @tokens.shift             # }
    end
  end

  def compile_if
    return unless @tokens[0].value == "if"
    @builder.ifStatement do
      output_token @tokens.shift             # if
      output_token @tokens.shift             # (
      compile_expression
      output_token @tokens.shift             # )
      output_token @tokens.shift             # {
      compile_statements
      output_token @tokens.shift             # }
      if @tokens[0].value == "else"
        output_token @tokens.shift             # else
        output_token @tokens.shift             # {
        compile_statements
        output_token @tokens.shift             # }
      end
    end
  end

  def compile_statements
    @builder.statements do
      while(statement?)
        case @tokens[0].value
        when "let"
          compile_let
        when "if"
          compile_if
        when "while"
          compile_while
        when "do"
          compile_do
        when "return"
          compile_return
        else
          raise "Unknown statement type #{@tokens[0].value}"
        end
      end
    end
  end

  ## FUNCTIONS FOR FIGURING OUT WHAT THE NEXT THING IS

  def keyword_constant?
    token = @tokens[0]
    return false unless token

    token.value == "true" ||
      token.value == "false" ||
      token.value == "null" ||
      token.value == "this"
  end

  def integer_constant?
    return false if @tokens.empty?
    @tokens[0].type == :integer_constant
  end

  def string_constant?
    return false if @tokens.empty?
    @tokens[0].type == :string_constant
  end

  def identifier?
    return false if @tokens.empty?
    @tokens[0].type == :identifier
  end
  alias :var_name?        :identifier?
  alias :subroutine_name? :identifier?
  alias :class_name?      :identifier?

  def unary_op?
    token = @tokens[0]
    return false unless token

    token.value == "-" || token.value == "~"
  end

  def op?
    return false if @tokens.empty?
    ["+", "-", "*", "/", "&", "|", "<", ">", "="].include?(@tokens[0].value)
  end

  def term?
    return false if @tokens.empty?
    integer_constant? ||
      string_constant? ||
      keyword_constant? ||
      var_name? ||
      @tokens[0].value == "(" ||
      unary_op?
  end

  def statement?
    return unless @tokens[0] && @tokens[0].type == :keyword
    %w[let if while do return].include?(@tokens[0].value)
  end
end
