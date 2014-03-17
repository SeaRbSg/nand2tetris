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
        def to_asm
            asm = []
            # put value into D reg
            case @segname
                when :constant
                    asm << "@#{v}"
                else
                    raise "unhandled segment '#{segname}'"
            end
            asm << 'D=A'
            # push D to stack
            asm << VM::Helper.push_d
            return asm.flatten
        end
    end
    
    class AddCommand < Command
        def to_asm
            # pop top two stack elems into D and A
            asm = VM::Helper.load_into_d_a
            # calc A+D into D
            asm << 'D=A+D'
            # push D to stack
            asm << VM::Helper.push_d
            return asm.flatten
        end
    end
    
    module Helper
    
        def self.inc_sp
            [ '@SP', 'M=M+1' ]
        end
        
        def self.dec_sp
            [ '@SP', 'M=M-1' ]
        end
        
        def self.push_d
            [ '@SP',  'A=M', 'M=D', self.inc_sp ]
        end
        
        def self.load_into_d_a
            [ '@SP', 'AM=M-1', 'D=M', '@SP', 'AM=M-1', 'A=M' ]
        end

    end

end
