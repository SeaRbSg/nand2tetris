class Tokenizer
  def self.tokenize text
    new(sanitize(text)).tokenize
  end

  def self.sanitize text
    text.gsub(%r{//.*$}, "")
      .gsub(%r{/\*.*?\*/}m, "")
      .split("\n")
      .reject {|l| l.strip.empty? }
      .join("\n")
  end

  def initialize text
    @lexemes = text.split(/([\s"#{Regexp.escape(Symbol::SYMBOLS.join)}])/)
    @tokens = []
  end

  def tokenize
    until @lexemes.empty?
      lexeme = @lexemes.shift

      if lexeme == '"'
        split = @lexemes.index('"')
        string, @lexemes = @lexemes[0...split].join, @lexemes[split+1..-1]
        @tokens << Str.new(string).to_token
      else
        @tokens << TYPES.detect {|type| type.match? lexeme }.new(lexeme).to_token
      end
    end

    @tokens.compact!
    @tokens
  end

  class Blank
    def self.match? token
      token =~ /^\s*$/
    end

    def initialize *_
    end

    def to_token
      nil
    end
  end

  class Identifier
    def self.match? token
      /[a-zA-Z_]+\w*/
    end

    def initialize token
      @token = token
    end

    def to_token
      [:identifier, @token]
    end
  end

  class Int
    def self.match? token
      token =~ /\d+/
    end

    def initialize token
      @token = token
    end

    def to_token
      [:integerConstant, @token]
    end
  end

  class Str
    def self.match? token
      false
    end

    def initialize token
      @token = token
    end

    def to_token
      [:stringConstant, @token]
    end
  end

  class Keyword
    KEYWORDS = %w[class constructor function method field static var int char
      boolean void true false null this let do if else while return]

    def self.match? token
      KEYWORDS.include? token
    end

    def initialize token
      @token = token
    end

    def to_token
      [:keyword, @token]
    end
  end

  class Symbol
    SYMBOLS = %w[{ } ( ) [ ] . , ; + - * / & | < > = ~]

    def self.match? token
      SYMBOLS.include? token
    end

    def initialize token
      @token = token
    end

    def to_token
      token = case @token
      when '>' then '&gt;'
      when '<' then '&lt;'
      when '&' then '&amp;'
      else ;        @token
      end

      [:symbol, token]
    end
  end

  class Unknown
    def self.match? *_
      true
    end

    def initialize token
      @token = token
    end

    def to_token
      [:unknown, @token]
    end
  end

  TYPES = [Blank, Int, Str, Keyword, Symbol, Identifier, Unknown]
end

if $0 == __FILE__
  input = ARGV.first

  unless input && File.exists?(input)
    abort "Usage: #{$0} input"
  end

  puts [
    "<tokens>",
    Tokenizer.tokenize(File.read(input)).map {|type, token|
      "<%{type}> %{token} </%{type}>" % { type: type, token: token }
    },
    "</tokens>",
  ].join("\n")
end
