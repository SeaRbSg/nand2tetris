require 'rltk'

module JohnnyFive
    
    class Parser < RLTK::Parser
    
        p(:node) do
            c('a_command')                    { |a| a }
            c('c_command')                    { |c| c }
            c('COMMENT')                    { |_| Comment.new }
            c('')                           { Blank.new }
        end
        
        p(:a_command) do
            # @12345
            c('ACONSTANT')          { |n| ACommand.new(n) }
            c('ASYMBOL')            { |n| DeferredACommand.new(n) }
        end
        
        p(:numeric) do
            c('NUMBER')             { |n| n }
            c('ZERO')               { |_| 0 }
            c('ONE')                { |_| 1 }
        end
        
        p(:c_command) do
            # comp
            c('comp')                       { |c| CCommand.new(0b0, c.bits, 0b0) }
            # dest=comp
            c('dest comp')           { |d,c| CCommand.new(d.bits, c.bits, 0b0) }
            # comp;jump
            c('comp SEMI jump')             { |c,_,j| CCommand.new(0b0, c.bits, j.bits) }
            # dest=comp;jump
            c('dest comp SEMI jump') { |d,c,_,j| CCommand.new(d.bits, c.bits, j.bits) }
        end

        # refactor using enviroments to reduce the number of clauses
        p(:dest) do
            c('REG_M')           { |_| Dest.new(0b001) }
            c('REG_D')           { |_| Dest.new(0b010) }
            c('REG_MD')      { |_| Dest.new(0b011) }
            c('REG_A')           { |_| Dest.new(0b100) }
            c('REG_AM')      { |_| Dest.new(0b101) }
            c('REG_AD')      { |_| Dest.new(0b110) }
            c('REG_AMD') { |_| Dest.new(0b111) }
        end
        
        # refactor using enviroments to reduce the number of clauses
        p(:comp) do
            # 0 or 1
            c('ONE')            { |_| Comp.new(0b0111111) }
            c('ZERO')           { |_| Comp.new(0b0101010) }
            # -1
            c('MINUS ONE')      { |_,_| Comp.new(0b0111010) }
            # D
            c('REG_D')           { |_| Comp.new(0b0001100) }
            # A
            c('REG_A')           { |_| Comp.new(0b0110000) }
            # !D
            c('NOT REG_D')       { |_,_| Comp.new(0b0001101) }
            # !A
            c('NOT REG_A')       { |_,_| Comp.new(0b0110001) }
            # -D
            c('MINUS REG_D')     { |_,_| Comp.new(0b0001111) }
            # -A
            c('MINUS REG_A')     { |_,_| Comp.new(0b0110011) }
            # D+1
            c('REG_D PLUS ONE')  { |_,_,_| Comp.new(0b0011111) }
            # A+1
            c('REG_A PLUS ONE')  { |_,_,_| Comp.new(0b0110111) }
            # D-1
            c('REG_D MINUS ONE') { |_,_,_| Comp.new(0b0001110) }
            # A-1
            c('REG_A MINUS ONE') { |_,_,_| Comp.new(0b0110010) }
            # D+A
            c('REG_D PLUS REG_A') { |_,_,_| Comp.new(0b0000010) }
            # D-A
            c('REG_D MINUS REG_A') { |_,_,_| Comp.new(0b0010011) }
            # A-D
            c('REG_A MINUS REG_D') { |_,_,_| Comp.new(0b0000111) }
            # D&A
            c('REG_D AND REG_A')  { |_,_,_| Comp.new(0b0000000) }
            # D|A
            c('REG_D OR REG_A')   { |_,_,_| Comp.new(0b0010101) }
            # M
            c('REG_M')           { |_| Comp.new(0b1110000) }
            # !M
            c('NOT REG_M')       { |_,_| Comp.new(0b1110001) }
            # -M
            c('MINUS REG_M')     { |_,_| Comp.new(0b1110011) }
            # M+1
            c('REG_M PLUS ONE')  { |_,_,_| Comp.new(0b1110111) }
            # M-1
            c('REG_M MINUS ONE') { |_,_,_| Comp.new(0b1110010) }
            # D+M
            c('REG_D PLUS REG_M')  { |_,_,_| Comp.new(0b1000010) }
            # D-M
            c('REG_D MINUS REG_M') { |_,_,_| Comp.new(0b1010011) }
            # M-D
            c('REG_M MINUS REG_D') { |_,_,_| Comp.new(0b1000111) }
            # D&M
            c('REG_D AND REG_M')  { |_,_,_| Comp.new(0b1000000) }
            # D|M
            c('REG_D OR REG_M')   { |_,_,_| Comp.new(0b1010101) }
        end
        
        p(:jump) do
            c('JGT')            { |_| Jump.new(0b001) }
            c('JEQ')            { |_| Jump.new(0b010) }
            c('JGE')            { |_| Jump.new(0b011) }
            c('JLT')            { |_| Jump.new(0b100) }
            c('JNE')            { |_| Jump.new(0b101) }
            c('JLE')            { |_| Jump.new(0b110) }
            c('JMP')            { |_| Jump.new(0b111) }
        end
        
        finalize :explain => ENV.key?('EXPLAIN')
        
    end

end
