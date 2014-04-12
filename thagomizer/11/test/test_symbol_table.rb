gem "minitest"
require 'minitest/autorun'
require_relative '../lib/symbol_table'

class TestSymbolTable < Minitest::Test
  def setup
    @symbol_table = SymbolTable.new()
  end

  def test_define_static
    @symbol_table.define("new_var", "int", :static)
    assert_equal 1, @symbol_table.var_count(:static)
  end

  def test_define_field
    @symbol_table.define("new_var", "int", :field)
    assert_equal 1, @symbol_table.var_count(:field)
  end

  def test_define_arg
    @symbol_table.define("new_var", "int", :arg)
    assert_equal 1, @symbol_table.var_count(:arg)
  end

  def test_define_two_vars
    @symbol_table.define("new_sub_var1", "int", :var)
    @symbol_table.define("new_sub_var2", "int", :var)

    assert_equal 2, @symbol_table.var_count(:var)
  end

  def test_getting_symbol_data
    @symbol_table.define("arg1", "int", :arg)
    @symbol_table.define("arg2", "string", :arg)
    @symbol_table.define("field1", "char", :field)

    assert_equal "int",    @symbol_table.type_of("arg1")
    assert_equal "string", @symbol_table.type_of("arg2")
    assert_equal "char",   @symbol_table.type_of("field1")
    assert_equal nil,      @symbol_table.type_of("missing")

    assert_equal :arg,     @symbol_table.kind_of("arg1")
    assert_equal :arg,     @symbol_table.kind_of("arg2")
    assert_equal :field,   @symbol_table.kind_of("field1")
    assert_equal nil,      @symbol_table.kind_of("missing")

    assert_equal 0,        @symbol_table.index_of("arg1")
    assert_equal 1,        @symbol_table.index_of("arg2")
    assert_equal 0,        @symbol_table.index_of("field1")
    assert_equal nil,      @symbol_table.index_of("missing")
  end

  def test_identifiers_with_same_name
    @symbol_table.define("foo", "int", :arg)
    @symbol_table.define("foo", "int", :static)

    assert_equal :arg, @symbol_table.kind_of("foo")
  end

  def test_start_subroutine
    @symbol_table.define("sub1_arg1", "int", :arg)
    @symbol_table.define("sub1_arg2", "string", :arg)

    @symbol_table.start_subroutine

    @symbol_table.define("sub2_arg1", "int", :arg)
    @symbol_table.define("sub2_arg2", "string", :arg)

    assert_equal 1, @symbol_table.index_of("sub2_arg2")
    assert_equal 0, @symbol_table.index_of("sub2_arg1")

    assert_equal nil, @symbol_table.index_of("sub1_arg1")
    assert_equal nil, @symbol_table.index_of("sub1_arg2")
  end
end

class TestEntry < Minitest::Test
  def test_creation
    entry = Entry.new("nAccounts", "int", :static, 0)
    refute_nil entry
  end

  def test_all_valid_kinds_supported
    static = Entry.new("s", "int", :static, 0)
    refute_nil static

    field  = Entry.new("f", "int", :field, 0)
    refute_nil field

    arg    = Entry.new("a", "int", :arg, 0)
    refute_nil arg

    var    = Entry.new("v", "int", :var, 0)
    refute_nil var
  end

  def test_argument_error_if_kind_invalid
    assert_raises(ArgumentError) do
      Entry.new("invalid", "int", :invalid, 0)
    end
  end
end
