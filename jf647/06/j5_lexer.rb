require 'rltk'

module JohnnyFive

    class Lexer < RLTK::Lexer

        # ignore whitespace
        rule(/\s/)

        # ignore comments to end of line
        rule(/\/\/.*/)            { :COMMENT }
        
        # assignment destinations
        rule(/M/)                   { |_| push_state :m_maybe_dest }
        rule(/D=/, :m_maybe_dest)   { |_| pop_state; :REG_MD }
        rule(/=/, :m_maybe_dest)    { |_| pop_state; :REG_M }
        rule(/./, :m_maybe_dest)    { |t| pop_state; t }
        rule(/D=/)                  { :REG_D }
        rule(/A/)                   { |_| push_state :a_maybe_dest }
        rule(/M/, :a_maybe_dest)    { |_| push_state :am_maybe_dest }
        rule(/D=/, :am_maybe_dest)  { |_| pop_state; pop_state; :REG_AMD }
        rule(/=/, :am_maybe_dest)   { |_| pop_state; pop_state; :REG_AM }
        rule(/./, :am_maybe_dest)   { |t| pop_state; t }
        rule(/D=/, :a_maybe_dest)   { |_| pop_state; :REG_AD }
        rule(/=/, :a_maybe_dest)    { |_| pop_state; REG_A }
        rule(/./, :a_maybe_dest)    { |t| pop_state; t }
        
        # jump conditions
        rule(/JGT/)             { :JGT }
        rule(/JEQ/)             { :JEQ }
        rule(/JGE/)             { :JGE }
        rule(/JLT/)             { :JLT }
        rule(/JNE/)             { :JNE }
        rule(/JLE/)             { :JLE }
        rule(/JMP/)             { :JMP }
        
        # A command
        rule(/\@(\d+)/)           { |c| [ :ACONSTANT, c[1].to_i ] }
        rule(/\@([a-zA-Z_\.\$\:][\w\.\$\:]*)/)  { |s| [ :ASYMBOL, s[1].to_sym ] }
        
        # numeric constants
        rule(/0/)               { :ZERO }
        rule(/1/)               { :ONE }
        rule(/\d+/)             { |t| [ :NUMBER, t.to_i ] }

        # symbols
        rule(/[a-zA-Z_\.\$\:][\w\.\$\:]*/)  { |t| [ :SYMBOL, t.to_sym ] }

        # sigils and other punctuation
        rule(/\(/)              { :LPAREN }
        rule(/\)/)              { :RPAREN }
        rule(/=/)               { :ASSIGN }
        rule(/\+/)              { :PLUS }
        rule(/-/)               { :MINUS }
        rule(/!/)               { :NOT }
        rule(/&/)               { :AND }
        rule(/\|/)              { :OR }
        rule(/;/)               { :SEMI }
        
    end
    
end
