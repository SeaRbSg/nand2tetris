require 'rltk'

module VM

    class Lexer < RLTK::Lexer

        # ignore whitespace
        rule(/\s/)

        # ignore comments to end of line
        rule(/\/\/.*/)              { :COMMENT }

        # core commands
        rule(/push/)                { :PUSH }
        rule(/pop/)                 { :POP }
        rule(/label/)               { :LABEL }
        rule(/goto/)                { :GOTO }
        rule(/if-goto/)             { :IFGOTO }
        rule(/function/)            { :FUNCTION }
        rule(/call/)                { :CALL }
        rule(/return/)              { :RETURN }
        rule(/add/)                 { :ADD }
        rule(/sub/)                 { :SUB }
        rule(/neg/)                 { :NEG }
        rule(/eq/)                  { :EQ }
        rule(/gt/)                  { :GT }
        rule(/lt/)                  { :LT }
        rule(/and/)                 { :AND }
        rule(/or/)                  { :OR }
        rule(/not/)                 { :NOT }

        # segment names
        rule(/argument/)            { :SEG_ARGUMENT }
        rule(/local/)               { :SEG_LOCAL }
        rule(/static/)              { :SEG_STATIC }
        rule(/constant/)            { :SEG_CONSTANT }
        rule(/this/)                { :SEG_THIS }
        rule(/that/)                { :SEG_THAT }
        rule(/pointer/)             { :SEG_POINTER }
        rule(/temp/)                { :SEG_TEMP }

        # symbols
        rule(/[a-zA-Z_\.\:][\w\.\:]*/)  { |s| [ :SYMBOL, s.to_sym ] }

        # numeric
        rule(/\d+/)                 { |t| [ :NUMBER, t.to_i ] }

    end

end
