require 'rltk/ast'

module JohnnyFive

    class Statement < RLTK::ASTNode
    end
    
    class Command < Statement
    end
    
    class PartialC < RLTK::ASTNode
        value :bits, Integer
    end
    
    class Comp < PartialC
    end
    
    class Dest < PartialC
    end
    
    class Jump < PartialC
    end
    
    class ACommand < Command
        value :v, Fixnum
        def to_bin
            sprintf('%0.16b', @v)
        end
    end

    class CCommand < Command
        value :dest, Integer
        value :comp, Integer
        value :jump, Integer
        def to_bin
            sprintf(
                '%0.16b',
                0b111 << 13 | 
                @comp <<  6 |
                @dest <<  3 |
                @jump
            )
        end
    end
    
    class Program < RLTK::ASTNode
        child :statements, [ Statement ]
    end

end
