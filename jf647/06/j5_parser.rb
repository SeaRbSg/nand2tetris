require 'rltk'

module JohnnyFive
    
    class Parser < RLTK::Parser

        p(:program) do
            c('statement+')             { |s| Program.new(s) }
        end
        
        p(:statement) do
            c('acommand')               { |a| a }
        end
        
        p(:acommand) do
            # @12345
            c('AT NUMBER NL')          { |_,n,_| ACommand.new(n) }
        end

        finalize
        
    end

end
