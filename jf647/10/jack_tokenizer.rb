require 'jack_lexer'

module Jack

    class Tokenizer

        def tokenize(infname)
            path = Pathname.new(infname)
            begin
                tokens = Jack::Lexer::lex_file( path.to_s )
                tokens.each do |t|
                    next if :EOS == t.type
                    yield t if block_given?
                end
            rescue RLTK::LexingError => e
                puts "couldn't lex #{infname} at line #{e.line_number} position #{e.line_offset}, at #{e.remainder[0,50]}"
            end
        end

        # don't care too much for how pretty the token-to-xml bits are,
        # as it's a pointless intermediate step when using RLTK
        KEYWORDS = [
            :CLASS, :CONSTRUCTOR, :FUNCTION, :METHOD, :FIELD, :STATIC, :VAR,
            :INT, :CHAR, :BOOLEAN, :VOID, :TRUE, :FALSE, :NULL, :THIS, :LET,
            :DO, :IF, :ELSE, :WHILE, :RETURN
        ].map{|e| [e, e.downcase]}.to_h
        SYMBOLS = {
            :LBRACE => '{', :RBRACE => '}',
            :LPAREN => '(', :RPAREN => ')',
            :LBRACKET => '[', :RBRACKET => ']',
            :DOT => '.', :COMMA => ',', :SEMICOLON => ';',
            :PLUS => '+', :MINUS => '-', :MULT => '*', :DIV => '/',
            :AND => '&amp;', :OR => '|', :LT => '&lt;', :GT => '&gt;',
            :EQUALS => '=', :NEG => '~',
        }
        def to_xml(t)

            case
                when KEYWORDS.key?(t.type)
                    "<keyword> #{KEYWORDS[t.type]} </keyword>"
                when SYMBOLS.key?(t.type)
                    "<symbol> #{SYMBOLS[t.type]} </symbol>"
                when :IDENT == t.type
                    "<identifier> #{t.value} </identifier>"
                when :INTEGER == t.type
                    "<integerConstant> #{t.value} </integerConstant>"
                when :STRING == t.type
                    "<stringConstant> #{t.value} </stringConstant>"
            end

        end

    end

end
