require 'rltk'

module JohnnyFive

    class Lexer < RLTK::Lexer

        match_first

        # whitespace
        rule(/\n/)              { :NL }
        rule(/\s/)

        # ignore comments to end of line
        rule(/\/\//)            { push_state :comment }
        rule(/./, :comment)
        rule(/\n/, :comment)    { pop_state; :COMMENT }
        
        # assignment destinations
        rule(/D/)               { :DREG }
        rule(/A/)               { :AREG }
        rule(/M/)               { :MREG }
        
        # jump conditions
        rule(/JGT/)             { :JGT }
        rule(/JEQ/)             { :JEQ }
        rule(/JGE/)             { :JGE }
        rule(/JLT/)             { :JLT }
        rule(/JNE/)             { :JNE }
        rule(/JLE/)             { :JLE }
        rule(/JMP/)             { :JMP }
        
        # numeric constants
        rule(/0/)               { :ZERO }
        rule(/1/)               { :ONE }
        rule(/\d+/)             { |t| [ :NUMBER, t.to_i ] }
        # symbol names
        rule(/[a-zA-Z_\.\$\:][\w\.\$\:]*/)  { |t| [ :SYMBOL, t.to_sym ] }

        # sigils and other punctuation
        rule(/\(/)              { :LPAREN }
        rule(/\)/)              { :RPAREN }
        rule(/\@/)              { :AT }
        rule(/=/)               { :ASSIGN }
        rule(/\+/)              { :PLUS }
        rule(/-/)               { :MINUS }
        rule(/!/)               { :NOT }
        rule(/&/)               { :AND }
        rule(/\|/)              { :OR }
        rule(/;/)               { :SEMI }
        
    end
    
end
