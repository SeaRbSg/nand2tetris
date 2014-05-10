require 'strscan'

class Tokenizer
  include Enumerable

  @@keyword = /(class)/
  @@symbol = /({|})/
  @@identifier = /[a-zA-Z_][a-zA-Z0-9]*/
  @@comment = /\/\/.*$/

  def initialize input
    @scanner = StringScanner.new input
  end

  def each
    while !@scanner.eos?
      yield next_token
    end
  end

  def next_token
    case
    when @scanner.scan(@@comment)
      next_token
    when @scanner.scan(@@keyword)
      Token.new(:keyword, @scanner.matched)
    when @scanner.scan(@@symbol)
      Token.new(:symbol, @scanner.matched)
    when @scanner.scan(@@identifier)
      Token.new(:identifier, @scanner.matched)
    when @scanner.scan(/(\s+|\n)/)
      next_token
    else
      raise "couldn't tokenize next terminal"
    end
  end
end

class Token
  attr_accessor :type, :value
  
  def initialize type, value
    @type = type
    @value = value
  end

end
