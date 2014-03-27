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

end

require 'vm_commands'