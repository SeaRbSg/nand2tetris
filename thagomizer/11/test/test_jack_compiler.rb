gem "minitest"
require 'minitest/autorun'

require_relative '../lib/jack_compiler'
require 'pp'

class TestJackCompiler < Minitest::Test
  make_my_diffs_pretty!

  def setup
    ENV["testing"] = "###"
    @compiler = JackCompiler.new
  end

  def test_compile_class
    ast = [:class,
           [:keyword, "class"],
           [:identifier, "Main"],
           [:symbol, "{"],
           [:symbol, "}"]]

    @compiler.generate_vm_code(ast)

    assert_equal "Main", @compiler.prefix
  end

end
