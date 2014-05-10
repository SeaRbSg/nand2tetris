require 'strscan'

class Tokenizer
  include Enumerable

  @@keyword = /(class|var)/
  @@symbol = /({|}|;)/
  @@identifier = /[a-zA-Z_][a-zA-Z0-9]*/
  @@comment = /\/\/.*$/
  @@whitespace = /(\s+|\n)/

  def initialize input
    @scanner = StringScanner.new input
  end

  def each
    scan_next = ->() {
      case 
      when @scanner.scan(@@comment)
        scan_next.()
      when @scanner.scan(@@keyword)
        Token.new(:keyword, @scanner.matched)
      when @scanner.scan(@@symbol)
        Token.new(:symbol, @scanner.matched)
      when @scanner.scan(@@identifier)
        Token.new(:identifier, @scanner.matched)
      when @scanner.scan(@@whitespace)
        scan_next.()
      else
        raise "couldn't tokenize " + @scanner.matched
      end
    }

    while !@scanner.eos?
      yield scan_next.()
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
