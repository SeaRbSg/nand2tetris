require 'rltk/ast'

module VM

    class VMLine < RLTK::ASTNode
    end
    
    class Comment < VMLine
    end

    class Blank < VMLine
    end
    
    class Command < VMLine
    end
    
    class PushCommand < Command
        value :segname, Symbol
        value :v, Fixnum
    end
    
    class AddCommand < Command
    end

end
