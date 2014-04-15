class CompilationEngineAst
  attr_accessor :tokenizer

  def initialize(tokenizer = nil)
    @tokenizer = tokenizer
  end

  def output_token token
    case token.type
    when :keyword
      [token.type, token.value]
    when :symbol
      [token.type, token.value]
    when :identifier
      [token.type, token.value]
    when :string_constant
      [token.type, token.value]
    when :integer_constant
      [token.type, token.value]
    else
      raise "Unknown token type #{token.type}"
    end
  end

  def output_next_token
    ast = output_token(@tokenizer.current_token)
    @tokenizer.advance
    ast
  end

  def compile_var_dec
    ast = [:var_dec]

    ast << output_token(@tokenizer.current_token)

    begin
      token = @tokenizer.advance
      ast << output_token(token)
    end while (token.value != ";")

    ast
  end

  def compile_var_decs
    ast = []
    next_var = current_val == "var" && current_type == :keyword
    while(next_var) do
      ast << compile_var_dec
      @tokenizer.advance
      next_var = current_val == "var" && current_type == :keyword
    end

    ast
  end

  def compile_class_var_dec
    ast = [:class_var_dec]

    ast << output_token(@tokenizer.current_token)

    begin
      token = @tokenizer.advance
      ast << output_token(token)
    end while (token.value != ";")

    ast
  end

  def compile_class_var_decs
    ast = []

    next_token = current_token
    next_var = next_token.type == :keyword &&
      (next_token.value == "field" || next_token.value == "static")

    while(next_var) do
      ast << compile_class_var_dec
      @tokenizer.advance
      next_token = current_token
      next_var = next_token.type == :keyword &&
        (next_token.value == "field" || next_token.value == "static")
    end

    ast unless ast.empty?
  end

  def compile_term
    ast = [:term]

    case
    when integer_constant? || string_constant? || keyword_constant?
      ast << output_next_token
    when subroutine_call?
      ast += compile_subroutine_call
    when var_name?
      ast << output_next_token
      if @tokenizer.has_more_commands? && current_val == "["
        ast << output_next_token
        ast << compile_expression
        ast << output_next_token
      end
    when current_val == "("
      ast << output_next_token
      ast << compile_expression
      ast << output_next_token
    when unary_op?
      ast << output_next_token
      ast << compile_term
    else
      raise "UNKNOWN TERM"
    end
    ast
  end

  def compile_expression
    ast = [:expression]
    while term?
      ast << compile_term
      if op?
        ast << output_next_token
      else
        break # no symbol so no more of the while loop
      end
    end
    ast
  end

  def compile_expression_list
    ast = [:expression_list]
    while term?
      ast << compile_expression
      if current_val == ","
        ast << output_next_token
      else
        break # no comma so no more of the while loop
      end
    end
    ast
  end

  def compile_subroutine_call
    ast = []

    raise_unless_type :identifier
    ast << output_next_token
    if current_val == "."
      ast << output_next_token
      raise "Invalid subroutine name" unless current_type == :identifier
      ast << output_next_token
    end

    raise_unless_value "("
    ast << output_next_token               # (

    ast << compile_expression_list

    raise_unless_value ")"
    ast << output_next_token               # )
    ast
  end

  def compile_return
    ast = [:return_statement]

    raise_unless_value "return"
    ast << output_next_token               # return

    ast << compile_expression

    raise_unless_value ";"
    ast << output_next_token               # ;

    ast
  end

  def compile_do
    ast = [:do_statement]

    raise_unless_value "do"
    ast << output_next_token

    ast += compile_subroutine_call

    raise_unless_value ";"
    ast << output_next_token

    ast
  end

  def compile_let
    ast = [:let_statement]

    raise_unless_value "let"
    ast << output_next_token             # let

    raise_unless_type :identifier
    ast << output_next_token             # varName (identifier)

    if current_val == "["
      ast << output_next_token           # [
      ast << compile_expression

      raise_unless_value "]"
      ast << output_next_token           # ]
    end

    raise_unless_value "="
    ast << output_next_token             # =

    ast << compile_expression

    raise_unless_value ";"
    ast << output_next_token             # ;

    ast
  end

  def compile_while
    ast = [:while_statement]

    raise_unless_value "while"
    ast << output_next_token             # while

    raise_unless_value "("
    ast << output_next_token             # (

    ast << compile_expression

    raise_unless_value ")"
    ast << output_next_token             # )

    raise_unless_value "{"
    ast << output_next_token             # {

    ast << compile_statements

    raise_unless_value "}"
    ast << output_next_token             # }
    ast
  end

  def compile_if
    ast = [:if_statement]

    raise_unless_value "if"
    ast << output_next_token             # if

    raise_unless_value "("
    ast << output_next_token             # (

    ast << compile_expression

    raise_unless_value ")"
    ast << output_next_token             # )

    raise_unless_value "{"
    ast << output_next_token             # {

    ast << compile_statements

    raise_unless_value "}"
    ast << output_next_token             # }

    if current_val == "else"
      raise_unless_value "else"
      ast << output_next_token             # else

      raise_unless_value "{"
      ast << output_next_token             # {

      ast << compile_statements

      raise_unless_value "}"
      ast << output_next_token             # }
    end

    ast
  end

  def compile_statements
    ast = [:statements]

    while(statement?)
      ast << case current_val
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
               raise "Unknown statement type #{current_val}"
             end
    end

    ast
  end

  def compile_parameter_list
    ast = [:parameter_list]

    while(type?) do
      ast << output_next_token   # type

      raise_unless_type :identifier
      ast << output_next_token   # varName

      if current_val == ","
        ast << output_next_token
      else
        break  # No, comma don't iterate
      end
    end

    ast
  end

  def compile_subroutine
    ast = [:subroutine_dec]

    raise "Not a subroutine starting token #{current_token}" unless subroutine?

    # constructor | function | method
    ast <<  output_next_token

    # void | type
    raise "Not a valid return type #{current_token}" unless return_type?
    ast <<  output_next_token

    raise "Not a valid subroutine name #{current_token}" unless subroutine_name?
    ast << output_next_token

    raise_unless_value "("
    ast << output_next_token

    ast << compile_parameter_list

    raise_unless_value ")"
    ast << output_next_token

    ast << compile_subroutine_body

    ast
  end

  def compile_subroutine_body
    ast = [:subroutine_body]

    raise_unless_value "{"
    ast << output_next_token     # {

    var_decs = compile_var_decs
    ast += var_decs if var_decs

    ast << compile_statements

    raise_unless_value "}"
    ast << output_next_token

    ast
  end

  def compile_class
    ast = [:class]

    raise_unless_value "class"
    ast << output_next_token    # class

    raise "Expected className, got #{current_token}" unless class_name?
    ast << output_next_token    # className

    raise_unless_value "{"
    ast << output_next_token    # {

    var_decs = compile_class_var_decs
    ast += var_decs if var_decs

    while(subroutine?)
      ast << compile_subroutine
    end

    raise_unless_value "}"
    ast << output_next_token    # }

    ast.compact
  end

  # ## FUNCTIONS FOR FIGURING OUT WHAT THE NEXT THING IS

  def keyword_constant?
    token = current_token
    return false unless token

    token.value == "true" ||
      token.value == "false" ||
      token.value == "null" ||
      token.value == "this"
  end

  def integer_constant?
    return false unless @tokenizer.has_more_commands?
    current_type == :integer_constant
  end

  def string_constant?
    return false unless @tokenizer.has_more_commands?
    current_type == :string_constant
  end

  def identifier?
    return false unless @tokenizer.has_more_commands?
    current_type == :identifier
  end
  alias :var_name?        :identifier?
  alias :subroutine_name? :identifier?
  alias :class_name?      :identifier?

  def unary_op?
    token = current_token
    return false unless token

    token.value == "-" || token.value == "~"
  end

  def op?
    return false unless @tokenizer.has_more_commands?
    ["+", "-", "*", "/", "&", "|", "<", ">", "="].include?(current_val)
  end

  def term?
    return false unless @tokenizer.has_more_commands?
    integer_constant? ||
      string_constant? ||
      keyword_constant? ||
      var_name? ||
      subroutine_call? ||
      current_val == "(" ||
      unary_op?
  end

  def statement?
    return unless current_token && current_type == :keyword
    %w[let if while do return].include?(current_val)
  end

  def type?
    return false unless @tokenizer.has_more_commands?
    return true if class_name?
    current_type == :keyword &&
      %w[int char boolean].include?(current_val)
  end

  def subroutine?
    return false unless @tokenizer.has_more_commands?
    current_type == :keyword &&
      %w[constructor method function].include?(current_val)
  end

  def return_type?
    return false unless @tokenizer.has_more_commands?
    return true if current_type == :keyword && current_val == "void"
    return true if type?
  end

  def subroutine_call?
    return false unless subroutine_name?
    second_token = @tokenizer.look_ahead

    return false unless second_token
    return second_token.value == "." || second_token.value == "("
  end

  def current_val
    current_token.value
  end

  def current_type
    current_token.type
  end

  def current_token
    @tokenizer.current_token
  end

  def raise_unless_value(expected)
    raise "Expected #{expected}, got #{current_token}" unless current_val == expected
  end

  def raise_unless_type(expected)
    raise "Expected #{expected}, got #{current_token}" unless current_type == expected
  end
end
