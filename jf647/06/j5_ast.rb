require 'rltk/ast'

module JohnnyFive

    class Statement < RLTK::ASTNode
    end
    
    class Command < Statement
    end
    
    class ACommand < Command
        value :v, Fixnum
        def to_bin
            sprintf('%0.16b', @v)
        end
    end
    
    class Program < RLTK::ASTNode
        child :statements, [ Statement ]
    end

end
