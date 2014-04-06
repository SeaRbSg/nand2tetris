require 'strscan'

Token = Struct.new(:type, :value)

class JackTokenizer
  KEYWORDS = Regexp.union(%w(class constructor function method field static var int char boolean void true false null this let do if else while return))

  SYMBOLS = Regexp.union("{}()[].,;+-*/&|<>=~".split(''))

  INT_CONST      = /\d+/

  STR_CONST      = /"(.*?)"/

  IDENTIFIER     = /[a-zA-Z_]\w*/

  SINGLE_COMMENT = /\/\/.*$/
  MULTI_COMMENT = /\/\*.*?\*\//m

  attr_accessor :scanner, :current_token
  attr_reader :input

  def initialize
    @tokens = []
  end


  def self.from_string(string)
    tokenizer = JackTokenizer.new
    tokenizer.input = string
    tokenizer
  end

  def self.from_file(path)
    tokenizer = JackTokenizer.new
    tokenizer.input = File.read path
    tokenizer
  end

  def input=(string)
    @input = string
    @scanner = StringScanner.new(string)

    string
  end

  def has_more_commands?
    !@scanner.eos?
  end

  def advance
    return unless has_more_commands?

    @current_token = nil

    case
    when @scanner.scan(SINGLE_COMMENT)
    when @scanner.scan(MULTI_COMMENT)
      # no-op
    when @scanner.scan(KEYWORDS)
      @current_token = Token.new(:keyword, @scanner.matched)
    when @scanner.scan(SYMBOLS)
      @current_token = Token.new(:symbol, @scanner.matched)
    when @scanner.scan(STR_CONST)
      @current_token = Token.new(:string_constant,
                                 @scanner.matched.gsub('"',''))
    when @scanner.scan(INT_CONST)
      @current_token = Token.new(:integer_constant, @scanner.matched.to_i)
    when @scanner.scan(IDENTIFIER)
      @current_token = Token.new(:identifier, @scanner.matched)
    when @scanner.scan(/\s/m)
      # no-op
    else
      raise "NO SUCH TOKEN #{@scanner.peek(30)}"
    end

    advance unless @current_token
  end
end
