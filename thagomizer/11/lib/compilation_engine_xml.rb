require 'builder'

class CompilationEngineXml
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

  def output_next_token
    output_token @tokens.shift
  end

  def compile_var_dec
    @builder.varDec do
      begin
        token = @tokens.shift
        output_token token
      end while (token.value != ";")
    end
  end

  def compile_var_decs
    next_var = peek_val == "var" && peek_type == :keyword
    while(next_var) do
      compile_var_dec
      next_var = peek_val == "var" && peek_type == :keyword
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

  def compile_class_var_decs
    next_token = peek
    next_var = next_token.type == :keyword &&
      (next_token.value == "field" || next_token.value == "static")

    while(next_var) do
      compile_class_var_dec
      next_token = peek
      next_var = next_token.type == :keyword &&
        (next_token.value == "field" || next_token.value == "static")
    end
  end

  def compile_term
    @builder.term do
      case
      when integer_constant? || string_constant? || keyword_constant?
        output_next_token
      when subroutine_call?
        compile_subroutine_call
      when var_name?
        output_next_token
        if !@tokens.empty? && peek_val == "["
          output_next_token
          compile_expression
          output_next_token
        end
      when peek_val == "("
        output_next_token
        compile_expression
        output_next_token
      when unary_op?
        output_next_token
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
          output_next_token
        else
          break # no symbol so no more of the while loop
        end
      end
    end
  end

  def compile_expression_list
    @builder.expressionList do
      while term?
        compile_expression
        if peek_val == ","
          output_next_token
        else
          break # no comma so no more of the while loop
        end
      end
    end
  end

  def compile_subroutine_call
    return unless peek_type == :identifier
    output_next_token
    if peek_val == "."
      output_next_token
      raise "Invalid subroutine name" unless peek_type == :identifier
      output_next_token
    end
    output_next_token               # (
    compile_expression_list
    output_next_token               # )
  end

  def compile_return
    return unless peek_val == "return"
    @builder.returnStatement do
      output_next_token             # return
      compile_expression
      output_next_token             # ;
    end
  end

  def compile_do
    return unless peek_val == "do"
    @builder.doStatement do
      output_next_token             # do
      compile_subroutine_call
      output_next_token             # ;
    end
  end

  def compile_let
    return unless peek_val == "let"

    @builder.letStatement do
      output_next_token             # let
      output_next_token             # varName (identifier)
      if peek_val == "["
        output_next_token           # [
        compile_expression
        output_next_token           # ]
      end
      output_next_token             # =
      compile_expression
      output_next_token             # ;
    end
  end

  def compile_while
    return unless peek_val == "while"
    @builder.whileStatement do
      output_next_token             # while
      output_next_token             # (
      compile_expression
      output_next_token             # )
      output_next_token             # {
      compile_statements
      output_next_token             # }
    end
  end

  def compile_if
    return unless peek_val == "if"
    @builder.ifStatement do
      output_next_token             # if
      output_next_token             # (
      compile_expression
      output_next_token             # )
      output_next_token             # {
      compile_statements
      output_next_token             # }
      if peek_val == "else"
        output_next_token             # else
        output_next_token             # {
        compile_statements
        output_next_token             # }
      end
    end
  end

  def compile_statements
    @builder.statements do
      while(statement?)
        case peek_val
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
          raise "Unknown statement type #{peek_val}"
        end
      end
    end
  end

  def compile_parameter_list
    @builder.parameterList do
      while(type?) do
        output_next_token   # type
        output_next_token   # varName
        if peek_val == ","   # ,
          output_next_token
        else
          break  # No, comma don't iterate
        end
      end
    end
  end

  def compile_subroutine
    raise "Not a subroutine starting token #{peek}" unless subroutine?
    @builder.subroutineDec do
      # constructor | function | method
      output_next_token

      # void | type
      raise "Not a valid return type #{peek}" unless return_type?
      output_next_token

      raise "Not a valid subroutine name #{peek}" unless subroutine_name?
      output_next_token

      raise "Expected (, got #{peek}" unless peek_val == "("
      output_next_token

      compile_parameter_list

      raise "Expected ), got #{peek}" unless peek_val == ")"
      output_next_token

      compile_subroutine_body
    end
  end

  def compile_subroutine_body
    raise "Expected {, got #{peek}" unless peek_val == "{"
    @builder.subroutineBody do
      output_next_token     # {

      compile_var_decs

      compile_statements

      raise "Expected }, got #{peek}" unless peek_val == "}"
      output_next_token
    end
  end

  def compile_class
    raise "Expected class, got #{peek}" unless peek_val == "class"
    @builder.class do
      output_next_token    # class

      raise "Expected className, got #{peek}" unless class_name?
      output_next_token    # className

      raise "Expected {, got #{peek}" unless peek_val == "{"
      output_next_token    # {

      compile_class_var_decs

      while(subroutine?)
        compile_subroutine
      end

      raise "Expected }, got #{peek}" unless peek_val == "}"
      output_next_token    # }
    end
  end

  ## FUNCTIONS FOR FIGURING OUT WHAT THE NEXT THING IS

  def keyword_constant?
    token = peek
    return false unless token

    token.value == "true" ||
      token.value == "false" ||
      token.value == "null" ||
      token.value == "this"
  end

  def integer_constant?
    return false if @tokens.empty?
    peek_type == :integer_constant
  end

  def string_constant?
    return false if @tokens.empty?
    peek_type == :string_constant
  end

  def identifier?
    return false if @tokens.empty?
    peek_type == :identifier
  end
  alias :var_name?        :identifier?
  alias :subroutine_name? :identifier?
  alias :class_name?      :identifier?

  def unary_op?
    token = peek
    return false unless token

    token.value == "-" || token.value == "~"
  end

  def op?
    return false if @tokens.empty?
    ["+", "-", "*", "/", "&", "|", "<", ">", "="].include?(peek_val)
  end

  def term?
    return false if @tokens.empty?
    integer_constant? ||
      string_constant? ||
      keyword_constant? ||
      var_name? ||
      subroutine_call? ||
      peek_val == "(" ||
      unary_op?
  end

  def statement?
    return unless peek && peek_type == :keyword
    %w[let if while do return].include?(peek_val)
  end

  def type?
    return false if @tokens.empty?
    return true if class_name?
    peek_type == :keyword &&
      %w[int char boolean].include?(peek_val)
  end

  def subroutine?
    return false if @tokens.empty?
    peek_type == :keyword &&
      %w[constructor method function].include?(peek_val)
  end

  def return_type?
    return false if @tokens.empty?
    return true if peek_type == :keyword && peek_val == "void"
    return true if type?
  end

  def subroutine_call?
    return false unless subroutine_name?
    second_token = @tokens[1]

    return second_token.value == "." || second_token.value == "("
  end

  def peek_val
    peek.value
  end

  def peek_type
    peek.type
  end

  def peek
    @tokens[0]
  end
end
