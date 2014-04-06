gem "minitest"
require 'minitest/autorun'
require_relative '../lib/compilation_engine'

Token = Struct.new(:type, :value)

class TestCompilationEngine < Minitest::Test
  make_my_diffs_pretty!

  def setup
    @ce = CompilationEngine.new([])
  end

  def test_compile_var_dec
    @ce.tokens = [Token.new(:keyword, "var"),
                  Token.new(:identifier, "SquareGame"),
                  Token.new(:identifier, "game"),
                  Token.new(:symbol, ";"),
                  Token.new(:keyword, "let")]

    expected = <<-eos
<varDec>
 <keyword>var</keyword>
 <identifier>SquareGame</identifier>
 <identifier>game</identifier>
 <symbol>;</symbol>
</varDec>
    eos

    assert_equal expected, @ce.compile_var_dec
  end

  def test_compile_multiple_var_dec
    @ce.tokens = [Token.new(:keyword, "var"),
                  Token.new(:keyword, "int"),
                  Token.new(:identifier, "i"),
                  Token.new(:symbol, ","),
                  Token.new(:identifier, "sum"),
                  Token.new(:symbol, ";"),
                  Token.new(:keyword, "let")]

    expected = <<-eos
<varDec>
 <keyword>var</keyword>
 <keyword>int</keyword>
 <identifier>i</identifier>
 <symbol>,</symbol>
 <identifier>sum</identifier>
 <symbol>;</symbol>
</varDec>
    eos

    assert_equal expected, @ce.compile_var_dec
  end

  def test_compile_class_var_dec
    @ce.tokens = [Token.new(:keyword, "field"),
                  Token.new(:keyword, "int"),
                  Token.new(:identifier, "x"),
                  Token.new(:symbol, ","),
                  Token.new(:identifier, "y"),
                  Token.new(:symbol, ";"),
                  Token.new(:keyword, "field")]

    expected = <<-eos
<classVarDec>
 <keyword>field</keyword>
 <keyword>int</keyword>
 <identifier>x</identifier>
 <symbol>,</symbol>
 <identifier>y</identifier>
 <symbol>;</symbol>
</classVarDec>
    eos

    assert_equal expected, @ce.compile_class_var_dec
  end

  def test_compile_term_integer_constant
    @ce.tokens = [Token.new(:integer_constant, "254"),]

    expected = <<-eos
<term>
 <integerConstant>254</integerConstant>
</term>
    eos

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_string_constant
    @ce.tokens = [Token.new(:string_constant, "HIYA"),]

    expected = <<-eos
<term>
 <stringConstant>HIYA</stringConstant>
</term>
    eos

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_keyword_constant
    @ce.tokens = [Token.new(:keyword, "this"),]

    expected = <<-eos
<term>
 <keyword>this</keyword>
</term>
    eos

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_var_name
    @ce.tokens = [Token.new(:identifier, "Ax"),]

    expected = <<-eos
<term>
 <identifier>Ax</identifier>
</term>
    eos

    assert_equal expected, @ce.compile_term
  end

  def test_compile_term_var_name
    @ce.tokens = [Token.new(:identifier, "Ax"),
                  Token.new(:symbol, "["),
                  Token.new(:identifier, "i"),
                  Token.new(:symbol, "+"),
                  Token.new(:integer_constant, "10"),
                  Token.new(:symbol, "]"),]

    expected = <<-eos
<term>
 <identifier>Ax</identifier>
 <symbol>[</symbol>
 <expression>
  <term>
   <identifier>i</identifier>
  </term>
  <symbol>+</symbol>
  <term>
   <integerConstant>10</integerConstant>
  </term>
 </expression>
 <symbol>]</symbol>
</term>
    eos

    assert_equal expected, @ce.compile_term
  end


  def test_compile_expression_no_op
    @ce.tokens = [Token.new(:string_constant, "Ax"),]

    expected = <<-eos
<expression>
 <term>
  <stringConstant>Ax</stringConstant>
 </term>
</expression>
    eos

    assert_equal expected, @ce.compile_expression
  end

  def test_compile_expression_single_op
    @ce.tokens = [Token.new(:integer_constant, "35"),
                  Token.new(:symbol, "+"),
                  Token.new(:integer_constant, "5"),]

    expected = <<-eos
<expression>
 <term>
  <integerConstant>35</integerConstant>
 </term>
 <symbol>+</symbol>
 <term>
  <integerConstant>5</integerConstant>
 </term>
</expression>
    eos

    assert_equal expected, @ce.compile_expression
  end

  def test_compile_expression_many_op
    @ce.tokens = [Token.new(:integer_constant, "35"),
                  Token.new(:symbol, "+"),
                  Token.new(:integer_constant, "5"),
                  Token.new(:symbol, "-"),
                  Token.new(:integer_constant, "10"),
                  Token.new(:symbol, "*"),
                  Token.new(:identifier, "abalone"),
                  Token.new(:symbol, ";"),
                  Token.new(:keyword, "let"),]

    expected = <<-eos
<expression>
 <term>
  <integerConstant>35</integerConstant>
 </term>
 <symbol>+</symbol>
 <term>
  <integerConstant>5</integerConstant>
 </term>
 <symbol>-</symbol>
 <term>
  <integerConstant>10</integerConstant>
 </term>
 <symbol>*</symbol>
 <term>
  <identifier>abalone</identifier>
 </term>
</expression>
    eos

    assert_equal expected, @ce.compile_expression
  end


  def test_compile_expression_many_op
    @ce.tokens = [Token.new(:integer_constant, "35"),
                  Token.new(:symbol, "+"),
                  Token.new(:integer_constant, "5"),
                  Token.new(:symbol, "-"),
                  Token.new(:integer_constant, "10"),
                  Token.new(:symbol, "*"),
                  Token.new(:identifier, "abalone"),
                  Token.new(:symbol, ";"),
                  Token.new(:keyword, "let"),]

    expected = <<-eos
<expression>
 <term>
  <integerConstant>35</integerConstant>
 </term>
 <symbol>+</symbol>
 <term>
  <integerConstant>5</integerConstant>
 </term>
 <symbol>-</symbol>
 <term>
  <integerConstant>10</integerConstant>
 </term>
 <symbol>*</symbol>
 <term>
  <identifier>abalone</identifier>
 </term>
</expression>
    eos

    assert_equal expected, @ce.compile_expression
  end

  def test_expression_list
    @ce.tokens = [Token.new(:identifier, "x"),
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

    expected = <<-eos
<expressionList>
 <expression>
  <term>
   <identifier>x</identifier>
  </term>
 </expression>
 <symbol>,</symbol>
 <expression>
  <term>
   <identifier>y</identifier>
  </term>
 </expression>
 <symbol>,</symbol>
 <expression>
  <term>
   <identifier>x</identifier>
  </term>
  <symbol>+</symbol>
  <term>
   <integerConstant>1</integerConstant>
  </term>
 </expression>
 <symbol>,</symbol>
 <expression>
  <term>
   <identifier>y</identifier>
  </term>
  <symbol>+</symbol>
  <term>
   <identifier>size</identifier>
  </term>
 </expression>
</expressionList>
    eos

    assert_equal expected, @ce.compile_expression_list
  end

  def test_compile_local_subrountine
    @ce.tokens = [Token.new(:identifier, "deAlloc"),
                  Token.new(:symbol, "("),
                  Token.new(:keyword, "this"),
                  Token.new(:symbol, ")")]
    expected = <<-eos
<identifier>deAlloc</identifier>
<symbol>(</symbol>
<expressionList>
 <expression>
  <term>
   <keyword>this</keyword>
  </term>
 </expression>
</expressionList>
<symbol>)</symbol>
    eos

    assert_equal expected, @ce.compile_subroutine_call
  end

  def test_compile_local_subrountine_with_dot
    @ce.tokens = [Token.new(:identifier, "Memory"),
                  Token.new(:symbol, "."),
                  Token.new(:identifier, "deAlloc"),
                  Token.new(:symbol, "("),
                  Token.new(:keyword, "this"),
                  Token.new(:symbol, ")")]

    expected = <<-eos
<identifier>Memory</identifier>
<symbol>.</symbol>
<identifier>deAlloc</identifier>
<symbol>(</symbol>
<expressionList>
 <expression>
  <term>
   <keyword>this</keyword>
  </term>
 </expression>
</expressionList>
<symbol>)</symbol>
    eos

    assert_equal expected, @ce.compile_subroutine_call
  end


  def test_compile_return
    @ce.tokens = [Token.new(:keyword, "return"),
                  Token.new(:identifier, "A"),
                  Token.new(:symbol, "/"),
                  Token.new(:integer_constant, "5"),
                  Token.new(:symbol, ";")]

    expected = <<-eos
<returnStatement>
 <keyword>return</keyword>
 <expression>
  <term>
   <identifier>A</identifier>
  </term>
  <symbol>/</symbol>
  <term>
   <integerConstant>5</integerConstant>
  </term>
 </expression>
 <symbol>;</symbol>
</returnStatement>
    eos

    assert_equal expected, @ce.compile_return
  end

  def test_compile_do
    @ce.tokens = [Token.new(:keyword, "do"),
                  Token.new(:identifier, "Memory"),
                  Token.new(:symbol, "."),
                  Token.new(:identifier, "deAlloc"),
                  Token.new(:symbol, "("),
                  Token.new(:keyword, "this"),
                  Token.new(:symbol, ")"),
                  Token.new(:symbol, ";"),
                  Token.new(:keyword, "return"),
                  Token.new(:symbol, ";"),]

    expected = <<-eos
<doStatement>
 <keyword>do</keyword>
 <identifier>Memory</identifier>
 <symbol>.</symbol>
 <identifier>deAlloc</identifier>
 <symbol>(</symbol>
 <expressionList>
  <expression>
   <term>
    <keyword>this</keyword>
   </term>
  </expression>
 </expressionList>
 <symbol>)</symbol>
 <symbol>;</symbol>
</doStatement>
    eos

    assert_equal expected, @ce.compile_do
  end

  def test_compile_let
    @ce.tokens = [Token.new(:keyword, "let"),
                  Token.new(:identifier, "sum"),
                  Token.new(:symbol, "="),
                  Token.new(:identifier, "sum"),
                  Token.new(:symbol, "+"),
                  Token.new(:identifier, "a"),
                  Token.new(:symbol, "["),
                  Token.new(:identifier, "i"),
                  Token.new(:symbol, "]"),
                  Token.new(:symbol, ";"),]

    expected = <<-eos
<letStatement>
 <keyword>let</keyword>
 <identifier>sum</identifier>
 <symbol>=</symbol>
 <expression>
  <term>
   <identifier>sum</identifier>
  </term>
  <symbol>+</symbol>
  <term>
   <identifier>a</identifier>
   <symbol>[</symbol>
   <expression>
    <term>
     <identifier>i</identifier>
    </term>
   </expression>
   <symbol>]</symbol>
  </term>
 </expression>
 <symbol>;</symbol>
</letStatement>
    eos

    assert_equal expected, @ce.compile_let
  end

  def test_compile_statements
    @ce.tokens = [Token.new(:keyword, "let"),
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

    expected = <<-eos
<statements>
 <letStatement>
  <keyword>let</keyword>
  <identifier>sum</identifier>
  <symbol>=</symbol>
  <expression>
   <term>
    <identifier>sum</identifier>
   </term>
   <symbol>+</symbol>
   <term>
    <identifier>a</identifier>
    <symbol>[</symbol>
    <expression>
     <term>
      <identifier>i</identifier>
     </term>
    </expression>
    <symbol>]</symbol>
   </term>
  </expression>
  <symbol>;</symbol>
 </letStatement>
 <letStatement>
  <keyword>let</keyword>
  <identifier>i</identifier>
  <symbol>=</symbol>
  <expression>
   <term>
    <identifier>i</identifier>
   </term>
   <symbol>+</symbol>
   <term>
    <integerConstant>1</integerConstant>
   </term>
  </expression>
  <symbol>;</symbol>
 </letStatement>
</statements>
    eos

    assert_equal expected, @ce.compile_statements
  end

  def test_compile_while
    @ce.tokens = [Token.new(:keyword, "while"),
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

    expected = <<-eos
<whileStatement>
 <keyword>while</keyword>
 <symbol>(</symbol>
 <expression>
  <term>
   <identifier>sum</identifier>
  </term>
  <symbol>&lt;</symbol>
  <term>
   <integerConstant>10</integerConstant>
  </term>
 </expression>
 <symbol>)</symbol>
 <symbol>{</symbol>
 <statements>
  <letStatement>
   <keyword>let</keyword>
   <identifier>sum</identifier>
   <symbol>=</symbol>
   <expression>
    <term>
     <identifier>sum</identifier>
    </term>
    <symbol>+</symbol>
    <term>
     <integerConstant>1</integerConstant>
    </term>
   </expression>
   <symbol>;</symbol>
  </letStatement>
 </statements>
 <symbol>}</symbol>
</whileStatement>
    eos

    assert_equal expected, @ce.compile_while
  end

  def test_compile_if
    @ce.tokens = [Token.new(:keyword, "if"),
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

    expected = <<-eos
<ifStatement>
 <keyword>if</keyword>
 <symbol>(</symbol>
 <expression>
  <term>
   <identifier>sum</identifier>
  </term>
  <symbol>&lt;</symbol>
  <term>
   <integerConstant>10</integerConstant>
  </term>
 </expression>
 <symbol>)</symbol>
 <symbol>{</symbol>
 <statements>
  <letStatement>
   <keyword>let</keyword>
   <identifier>sum</identifier>
   <symbol>=</symbol>
   <expression>
    <term>
     <identifier>sum</identifier>
    </term>
    <symbol>+</symbol>
    <term>
     <integerConstant>1</integerConstant>
    </term>
   </expression>
   <symbol>;</symbol>
  </letStatement>
 </statements>
 <symbol>}</symbol>
 <keyword>else</keyword>
 <symbol>{</symbol>
 <statements>
  <letStatement>
   <keyword>let</keyword>
   <identifier>sum</identifier>
   <symbol>=</symbol>
   <expression>
    <term>
     <identifier>sum</identifier>
    </term>
    <symbol>+</symbol>
    <term>
     <integerConstant>1</integerConstant>
    </term>
   </expression>
   <symbol>;</symbol>
  </letStatement>
 </statements>
 <symbol>}</symbol>
</ifStatement>
    eos

    assert_equal expected, @ce.compile_if
  end

  def test_keyword_constant?
    @ce.tokens = [Token.new(:keyword, "true")]
    assert @ce.keyword_constant?

    @ce.tokens = [Token.new(:keyword, "false")]
    assert @ce.keyword_constant?

    @ce.tokens = [Token.new(:keyword, "null")]
    assert @ce.keyword_constant?

    @ce.tokens = [Token.new(:keyword, "this")]
    assert @ce.keyword_constant?

    @ce.tokens = [Token.new(:identifier, "Ax")]
    refute @ce.keyword_constant?

    @ce.tokens = [Token.new(:keyword, "class")]
    refute @ce.keyword_constant?
  end

  def test_unary_op?
    @ce.tokens = [Token.new(:symbol, "-")]
    assert @ce.unary_op?

    @ce.tokens = [Token.new(:symbol, "~")]
    assert @ce.unary_op?

    @ce.tokens = [Token.new(:symbol, "+")]
    refute @ce.unary_op?
  end

  def test_op?
    @ce.tokens = [Token.new(:symbol, "+")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "-")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "*")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "/")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "&")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "|")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "<")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, ">")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "=")]
    assert @ce.op?

    @ce.tokens = [Token.new(:symbol, "~")]
    refute @ce.op?
  end

  def test_statement?
    @ce.tokens = [Token.new(:keyword, "let")]
    assert @ce.statement?

    @ce.tokens = [Token.new(:keyword, "if")]
    assert @ce.statement?

    @ce.tokens = [Token.new(:keyword, "while")]
    assert @ce.statement?

    @ce.tokens = [Token.new(:keyword, "do")]
    assert @ce.statement?

    @ce.tokens = [Token.new(:keyword, "return")]
    assert @ce.statement?

    @ce.tokens = [Token.new(:symbol, "~")]
    refute @ce.op?

    @ce.tokens = [Token.new(:keyword, "class")]
    refute @ce.op?

    @ce.tokens = []
    refute @ce.op?
  end

  # compile_class
  # compile_subroutine
  # compile_parameter_list


end
