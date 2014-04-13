gem "minitest"
require 'minitest/autorun'

require_relative '../lib/compilation_engine'
require 'token'

class TestCompilationEngine < Minitest::Test
  make_my_diffs_pretty!

  def setup
    @ce = CompilationEngine.new()
  end

  def set_tokens(tokens)
    @tokenizer    = StubTokenizer.new(tokens)
    @ce.tokenizer = @tokenizer
  end

  def test_output_token

    assert_equal [:keyword, "var"], @ce.output_token(Token.new(:keyword, "var"))
    assert_equal [:symbol, "+"], @ce.output_token(Token.new(:symbol, "+"))
  end

  def test_compile_var_dec

    set_tokens [Token.new(:keyword, "var"),
                Token.new(:identifier, "SquareGame"),
                Token.new(:identifier, "game"),
                Token.new(:symbol, ";"),
                Token.new(:keyword, "let")]

    expected = [:var_dec,
                [:keyword, "var"],
                [:identifier, "SquareGame"],
                [:identifier, "game"],
                [:symbol, ";"]
               ]

    assert_equal expected, @ce.compile_var_dec
  end

  def test_compile_multiple_var_dec

    set_tokens [Token.new(:keyword, "var"),
                Token.new(:keyword, "int"),
                Token.new(:identifier, "i"),
                Token.new(:symbol, ","),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, ";"),
                Token.new(:keyword, "let")]

    expected = [:var_dec,
                [:keyword, "var"],
                [:keyword, "int"],
                [:identifier, "i"],
                [:symbol, ","],
                [:identifier, "sum"],
                [:symbol, ";"]
               ]

    assert_equal expected, @ce.compile_var_dec
  end

  def test_compile_class_var_dec
    set_tokens [Token.new(:keyword, "field"),
                Token.new(:keyword, "int"),
                Token.new(:identifier, "x"),
                Token.new(:symbol, ","),
                Token.new(:identifier, "y"),
                Token.new(:symbol, ";"),
                Token.new(:keyword, "field")]

    expected = [:class_var_dec,
                [:keyword, "field"],
                [:keyword, "int"],
                [:identifier, "x"],
                [:symbol, ","],
                [:identifier, "y"],
                [:symbol, ";"],
               ]

    assert_equal expected, @ce.compile_class_var_dec
  end

  def test_compile_term_integer_constant

    set_tokens [Token.new(:integer_constant, "254"),]

    expected = [:term,
                [:integer_constant, "254"]]

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_string_constant

    set_tokens [Token.new(:string_constant, "HIYA"),]

    expected = [:term,
                [:string_constant, "HIYA"]]

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_keyword_constant

    set_tokens [Token.new(:keyword, "this"),]

    expected = [:term,
                [:keyword, "this"]]

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_var_name

    set_tokens [Token.new(:identifier, "Ax"),]

    expected = [:term,
                [:identifier, "Ax"]]

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_var_name
    set_tokens [Token.new(:identifier, "Ax"),
                Token.new(:symbol, "["),
                Token.new(:identifier, "i"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "10"),
                Token.new(:symbol, "]"),]

    expected = [:term,
                [:identifier, "Ax"],
                [:symbol, "["],
                [:expression,
                 [:term,
                  [:identifier, "i"],
                 ],
                 [:symbol, "+"],
                 [:term,
                  [:integer_constant, "10"]
                 ],
                ],
                [:symbol, "]"],
               ]

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_subroutine_call
    set_tokens [Token.new(:identifier, "Keyboard"),
                Token.new(:symbol, "."),
                Token.new(:identifier, "readInt"),
                Token.new(:symbol, "("),
                Token.new(:string_constant, "HOW MANY NUMBERS? "),
                Token.new(:symbol, ")"),]

    expected = [:term,
                [:identifier, "Keyboard"],
                [:symbol, "."],
                [:identifier, "readInt"],
                [:symbol, "("],
                [:expression_list,
                 [:expression,
                  [:term,
                   [:string_constant, "HOW MANY NUMBERS? "],
                  ],
                 ],
                ],
                [:symbol, ")"],
               ]

    assert_equal expected, @ce.compile_term
  end

  def test_compile_expression_no_op
    set_tokens [Token.new(:string_constant, "Ax"),]

    expected = [:expression,
                [:term,
                 [:string_constant, "Ax"],
                ]
               ]

    assert_equal expected, @ce.compile_expression
  end

  def test_compile_expression_single_op
    set_tokens [Token.new(:integer_constant, "35"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "5"),]

    expected = [:expression,
                [:term,
                 [:integer_constant, "35"],
                ],
                [:symbol, "+"],
                [:term,
                 [:integer_constant, "5"],
                ]
               ]

    assert_equal expected, @ce.compile_expression
  end

  def test_compile_expression_many_op
    set_tokens [Token.new(:integer_constant, "35"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "5"),
                Token.new(:symbol, "-"),
                Token.new(:integer_constant, "10"),
                Token.new(:symbol, "*"),
                Token.new(:identifier, "abalone"),
                Token.new(:symbol, ";"),
                Token.new(:keyword, "let"),]

    expected = [:expression,
                [:term,
                 [:integer_constant, "35"],
                ],
                [:symbol, "+"],
                [:term,
                 [:integer_constant, "5"],
                ],
                [:symbol, "-"],
                [:term,
                 [:integer_constant, "10"],
                ],
                [:symbol, "*"],
                [:term,
                 [:identifier, "abalone"],
                ],
               ]

    assert_equal expected, @ce.compile_expression
  end

  def test_expression_list
    set_tokens [Token.new(:identifier, "x"),
                Token.new(:symbol, ","),
                Token.new(:identifier, "y"),
                Token.new(:symbol, ","),
                Token.new(:identifier, "x"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "1"),
                Token.new(:symbol, ","),
                Token.new(:identifier, "y"),
                Token.new(:symbol, "+"),
                Token.new(:identifier, "size"),
                Token.new(:symbol, ")")]

    expected = [:expression_list,
                [:expression,
                 [:term,
                  [:identifier, "x"],
                 ],
                ],
                [:symbol, ","],
                [:expression,
                 [:term,
                  [:identifier, "y"],
                 ],
                ],
                [:symbol, ","],
                [:expression,
                 [:term,
                  [:identifier, "x"],
                 ],
                 [:symbol, "+"],
                 [:term,
                  [:integer_constant, "1"],
                 ],
                ],
                [:symbol, ","],
                [:expression,
                 [:term,
                  [:identifier, "y"],
                 ],
                 [:symbol, "+"],
                 [:term,
                  [:identifier, "size"],
                 ],
                ],
               ]

    assert_equal expected, @ce.compile_expression_list
  end

  def test_compile_local_subrountine
    set_tokens [Token.new(:identifier, "deAlloc"),
                  Token.new(:symbol, "("),
                  Token.new(:keyword, "this"),
                  Token.new(:symbol, ")")]
    expected = [[:identifier, "deAlloc"],
                [:symbol, "("],
                [:expression_list,
                 [:expression,
                  [:term,
                   [:keyword, "this"],
                  ],
                 ],
                ],
                [:symbol, ")"]]

    assert_equal expected, @ce.compile_subroutine_call
  end

  def test_compile_local_subrountine_with_dot
    set_tokens [Token.new(:identifier, "Memory"),
                Token.new(:symbol, "."),
                Token.new(:identifier, "deAlloc"),
                Token.new(:symbol, "("),
                Token.new(:keyword, "this"),
                Token.new(:symbol, ")")]

    expected = [[:identifier, "Memory"],
                [:symbol, "."],
                [:identifier, "deAlloc"],
                [:symbol, "("],
                [:expression_list,
                 [:expression,
                  [:term,
                   [:keyword, "this"],
                  ],
                 ],
                ],
                [:symbol, ")"]]

    assert_equal expected, @ce.compile_subroutine_call
  end

  def test_compile_return
    set_tokens [Token.new(:keyword, "return"),
                Token.new(:identifier, "A"),
                Token.new(:symbol, "/"),
                Token.new(:integer_constant, "5"),
                Token.new(:symbol, ";")]

    expected = [:return_statement,
                [:keyword, "return"],
                [:expression,
                 [:term,
                  [:identifier, "A"],
                 ],
                 [:symbol, "/"],
                 [:term,
                  [:integer_constant, "5"],
                 ],
                ],
                [:symbol, ";"],
               ]

    actual = @ce.compile_return

    assert_equal expected, actual
  end

  def test_compile_do
    set_tokens [Token.new(:keyword, "do"),
                Token.new(:identifier, "Memory"),
                Token.new(:symbol, "."),
                Token.new(:identifier, "deAlloc"),
                Token.new(:symbol, "("),
                Token.new(:keyword, "this"),
                Token.new(:symbol, ")"),
                Token.new(:symbol, ";"),
                Token.new(:keyword, "return"),
                Token.new(:symbol, ";"),]

    expected = [:do_statement,
                [:keyword, "do"],
                [:identifier, "Memory"],
                [:symbol, "."],
                [:identifier, "deAlloc"],
                [:symbol, "("],
                [:expression_list,
                 [:expression,
                  [:term,
                   [:keyword, "this"],
                  ],
                 ],
                ],
                [:symbol, ")"],
                [:symbol, ";"],
               ]
    assert_equal expected, @ce.compile_do
  end

  def test_compile_let
    set_tokens [Token.new(:keyword, "let"),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "="),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "+"),
                Token.new(:identifier, "a"),
                Token.new(:symbol, "["),
                Token.new(:identifier, "i"),
                Token.new(:symbol, "]"),
                Token.new(:symbol, ";"),]

    expected = [:let_statement,
                [:keyword, "let"],
                [:identifier, "sum"],
                [:symbol, "="],
                [:expression,
                 [:term,
                  [:identifier, "sum"],
                 ],
                 [:symbol, "+"],
                 [:term,
                  [:identifier, "a"],
                  [:symbol, "["],
                  [:expression,
                   [:term,
                    [:identifier, "i"],
                   ],
                  ],
                  [:symbol, "]"],
                 ],
                ],
                [:symbol, ";"],
               ]

    assert_equal expected, @ce.compile_let
  end

  def test_compile_statements
    set_tokens [Token.new(:keyword, "let"),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "="),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "+"),
                Token.new(:identifier, "a"),
                Token.new(:symbol, "["),
                Token.new(:identifier, "i"),
                Token.new(:symbol, "]"),
                Token.new(:symbol, ";"),
                Token.new(:keyword, "let"),
                Token.new(:identifier, "i"),
                Token.new(:symbol, "="),
                Token.new(:identifier, "i"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "1"),
                Token.new(:symbol, ";"),]

    expected = [:statements,
                [:let_statement,
                 [:keyword, "let"],
                 [:identifier, "sum"],
                 [:symbol, "="],
                 [:expression,
                  [:term,
                   [:identifier, "sum"],
                  ],
                  [:symbol, "+"],
                  [:term,
                   [:identifier, "a"],
                   [:symbol, "["],
                   [:expression,
                    [:term,
                     [:identifier, "i"],
                    ],
                   ],
                   [:symbol, "]"],
                  ],
                 ],
                 [:symbol, ";"],
                ],
                [:let_statement,
                 [:keyword, "let"],
                 [:identifier, "i"],
                 [:symbol, "="],
                 [:expression,
                  [:term,
                   [:identifier, "i"],
                  ],
                  [:symbol, "+"],
                  [:term,
                   [:integer_constant, "1"]
                  ],
                 ],
                 [:symbol, ";"],
                ],
               ]

    assert_equal expected, @ce.compile_statements
  end

  def test_compile_while
    set_tokens [Token.new(:keyword, "while"),
                Token.new(:symbol, "("),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "<"),
                Token.new(:integer_constant, "10"),
                Token.new(:symbol, ")"),
                Token.new(:symbol, "{"),
                Token.new(:keyword, "let"),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "="),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "1"),
                Token.new(:symbol, ";"),
                Token.new(:symbol, "}"),]

    expected = [:while_statement,
                [:keyword, "while"],
                [:symbol, "("],
                [:expression,
                 [:term,
                  [:identifier, "sum"],
                 ],
                 [:symbol, "<"],
                 [:term,
                  [:integer_constant, "10"],
                 ],
                ],
                [:symbol, ")"],
                [:symbol, "{"],
                [:statements,
                 [:let_statement,
                  [:keyword, "let"],
                  [:identifier, "sum"],
                  [:symbol, "="],
                  [:expression,
                   [:term,
                    [:identifier, "sum"],
                   ],
                   [:symbol, "+"],
                   [:term,
                    [:integer_constant, "1"],
                   ],
                  ],
                  [:symbol, ";"],
                 ],
                ],
                [:symbol, "}"],
               ]

    assert_equal expected, @ce.compile_while
  end

  def test_compile_if
    set_tokens [Token.new(:keyword, "if"),
                Token.new(:symbol, "("),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "<"),
                Token.new(:integer_constant, "10"),
                Token.new(:symbol, ")"),
                Token.new(:symbol, "{"),
                Token.new(:keyword, "let"),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "="),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "1"),
                Token.new(:symbol, ";"),
                Token.new(:symbol, "}"),
                Token.new(:keyword, "else"),
                Token.new(:symbol, "{"),
                Token.new(:keyword, "let"),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "="),
                Token.new(:identifier, "sum"),
                Token.new(:symbol, "+"),
                Token.new(:integer_constant, "1"),
                Token.new(:symbol, ";"),
                Token.new(:symbol, "}"),]

    expected = [:if_statement,
                [:keyword, "if"],
                [:symbol, "("],
                [:expression,
                 [:term,
                  [:identifier, "sum"],
                 ],
                 [:symbol, "<"],
                 [:term,
                  [:integer_constant, "10"]
                 ],
                ],
                [:symbol, ")"],
                [:symbol, "{"],
                [:statements,
                 [:let_statement,
                  [:keyword, "let"],
                  [:identifier, "sum"],
                  [:symbol, "="],
                  [:expression,
                   [:term,
                    [:identifier, "sum"],
                   ],
                   [:symbol, "+"],
                   [:term,
                    [:integer_constant, "1"],
                   ],
                  ],
                  [:symbol, ";"],
                 ],
                ],
                [:symbol, "}"],
                [:keyword, "else"],
                [:symbol, "{"],
                [:statements,
                 [:let_statement,
                  [:keyword, "let"],
                  [:identifier, "sum"],
                  [:symbol, "="],
                  [:expression,
                   [:term,
                    [:identifier, "sum"],
                   ],
                   [:symbol, "+"],
                   [:term,
                    [:integer_constant, "1"],
                   ],
                  ],
                  [:symbol, ";"],
                 ],
                ],
                [:symbol, "}"],
               ]

    assert_equal expected, @ce.compile_if
  end

  def test_compile_parameter_list
    set_tokens [Token.new(:keyword, "int"),
                Token.new(:identifier, "Ax"),
                Token.new(:symbol, ","),
                Token.new(:keyword, "int"),
                Token.new(:identifier, "Ay"),
                Token.new(:symbol, ","),
                Token.new(:keyword, "int"),
                Token.new(:identifier, "Asize"),
                Token.new(:symbol, ")"),]

    expected = [:parameter_list,
                [:keyword, "int"],
                [:identifier, "Ax"],
                [:symbol, ","],
                [:keyword, "int"],
                [:identifier, "Ay"],
                [:symbol, ","],
                [:keyword, "int"],
                [:identifier, "Asize"],
               ]

    assert_equal expected, @ce.compile_parameter_list
  end

  def test_keyword_constant?
    set_tokens [Token.new(:keyword, "true")]
    assert @ce.keyword_constant?

    set_tokens [Token.new(:keyword, "false")]
    assert @ce.keyword_constant?

    set_tokens [Token.new(:keyword, "null")]
    assert @ce.keyword_constant?

    set_tokens [Token.new(:keyword, "this")]
    assert @ce.keyword_constant?

    set_tokens [Token.new(:identifier, "Ax")]
    refute @ce.keyword_constant?

    set_tokens [Token.new(:keyword, "class")]
    refute @ce.keyword_constant?
  end

  def test_unary_op?
    set_tokens [Token.new(:symbol, "-")]
    assert @ce.unary_op?

    set_tokens [Token.new(:symbol, "~")]
    assert @ce.unary_op?

    set_tokens [Token.new(:symbol, "+")]
    refute @ce.unary_op?
  end

  def test_op?
    set_tokens [Token.new(:symbol, "+")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "-")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "*")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "/")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "&")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "|")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "<")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, ">")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "=")]
    assert @ce.op?

    set_tokens [Token.new(:symbol, "~")]
    refute @ce.op?
  end

  def test_statement?
    set_tokens [Token.new(:keyword, "let")]
    assert @ce.statement?

    set_tokens [Token.new(:keyword, "if")]
    assert @ce.statement?

    set_tokens [Token.new(:keyword, "while")]
    assert @ce.statement?

    set_tokens [Token.new(:keyword, "do")]
    assert @ce.statement?

    set_tokens [Token.new(:keyword, "return")]
    assert @ce.statement?

    set_tokens [Token.new(:symbol, "~")]
    refute @ce.statement?

    set_tokens [Token.new(:keyword, "class")]
    refute @ce.statement?

    set_tokens []
    refute @ce.statement?
  end

  def test_type?
    set_tokens [Token.new(:keyword, "int")]
    assert @ce.type?

    set_tokens [Token.new(:keyword, "char")]
    assert @ce.type?

    set_tokens [Token.new(:keyword, "boolean")]
    assert @ce.type?

    set_tokens [Token.new(:identifier, "Square")]
    assert @ce.type?

    set_tokens [Token.new(:keyword, "return")]
    refute @ce.type?

    set_tokens [Token.new(:symbol, "~")]
    refute @ce.type?

    set_tokens [Token.new(:keyword, "class")]
    refute @ce.type?

    set_tokens []
    refute @ce.type?
  end

  def test_subroutine?
    set_tokens [Token.new(:keyword, "constructor")]
    assert @ce.subroutine?

    set_tokens [Token.new(:keyword, "function")]
    assert @ce.subroutine?

    set_tokens [Token.new(:keyword, "method")]
    assert @ce.subroutine?

    set_tokens [Token.new(:keyword, "return")]
    refute @ce.subroutine?

    set_tokens [Token.new(:symbol, "~")]
    refute @ce.subroutine?

    set_tokens [Token.new(:keyword, "class")]
    refute @ce.subroutine?

    set_tokens []
    refute @ce.subroutine?
  end

  def test_subroutine_call?
    set_tokens [Token.new(:identifier, "Keyboard"),
                Token.new(:symbol, "."),
                Token.new(:identifier, "readInt"),
                Token.new(:symbol, "("),
                Token.new(:stringConstant, "HOW MANY NUMBERS? "),
                Token.new(:symbol, ")"),]

    assert @ce.subroutine_call?
  end
end

class StubTokenizer
  attr_accessor :tokens, :index

  def initialize(tokens = [], index = 0)
    @index = index
    @tokens = tokens
  end

  def advance
    @index += 1
    current_token
  end

  def current_token
    @tokens[@index]
  end

  def has_more_commands?
    @index < @tokens.length
  end

  def look_ahead(index)
    @tokens[@index + index]
  end
end
