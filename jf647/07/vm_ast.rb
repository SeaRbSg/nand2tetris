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
        value :offset, Fixnum
        def descr
            "push #{@segname} #{@offset}"
        end
        def to_asm
            asm = []
            # get the value into the D reg
            case @segname
                when :constant
                    # literal value of the offset
                    asm << "@#{offset}"
                    asm << 'D=A'
                when :local, :argument, :this, :that
                    # *(base[segment]+offset), base is symbolic
                    # store offset in D
                    asm << "@#{@offset}"
                    asm << "D=A"
                    # inc by the base addr
                    asm << "@#{VM::Helper::SEGBASE[@segname]}"
                    asm << "A=M+D"
                    # deref into D
                    asm << 'D=M'
                when :temp, :pointer
                    # *(base[segment]+offset), base is constant
                    asm << "@R#{VM::Helper::SEGBASE[@segname]+@offset}"
                    asm << 'D=M'
                else
                    raise "unhandled segment '#{@segname}'"
            end
            # push D to stack
            asm << VM::Helper.push_d
            return asm.flatten
        end
    end

    class PopCommand < Command
        value :segname, Symbol
        value :offset, Fixnum
        def descr
            "pop #{@segname} #{@offset}"
        end
        def to_asm
            asm = []
            case @segname
                when :constant
                    raise 'cannot pop into constant segment'
                when :local, :argument, :this, :that
                    # *(base[segment]+offset), base is symbolic
                    # store offset in D
                    asm << "@#{@offset}"
                    asm << "D=A"
                    # inc by the base addr
                    asm << "@#{VM::Helper::SEGBASE[@segname]}"
                    asm << "D=M+D"
                    # store dest in R13
                    asm << '@R13'
                    asm << 'M=D'
                    # pop stack to D
                    asm << VM::Helper.pop_d
                    # put *R13 into M
                    asm << '@R13'
                    asm << 'A=M'
                when :temp, :pointer
                    # *(base[segment]+offset), base is constant
                    # pop stack to R13
                    asm << VM::Helper.pop_d
                    asm << "@R#{VM::Helper::SEGBASE[@segname]+@offset}"
                else
                    raise "unhandled segment '#{@segname}'"
            end
            # set M to popped value
            asm << 'M=D'
            return asm.flatten
        end
    end
    
    class ArithmeticCommand < Command
        def to_asm(numops, calc)
            asm = []
            # pop stack elems
            case numops
                when 1
                    asm << VM::Helper.load_into_d
                when 2
                    asm << VM::Helper.load_into_d_a
                else
                    raise "unhandled number of arithmetic ops: #{numops}"
            end
            # perform the calculation
            asm << "D=#{calc}"
            # push D to stack
            asm << VM::Helper.push_d
            return asm.flatten
        end
    end
    
    class LogicalCommand < ArithmeticCommand
        # works the same as ArithmeticCommand, at least in Ch7
    end

    class AddCommand < ArithmeticCommand
        def descr
            "add"
        end
        def to_asm
            super(2, 'A+D')
        end
    end

    class SubCommand < ArithmeticCommand
        def descr
            "sub"
        end
        def to_asm
            super(2, 'A-D')
        end
    end
    
    class NegateCommand < ArithmeticCommand
        def descr
            "neg"
        end
        def to_asm
            super(1, '-D')
        end
    end
    
    class ComparisonCommand < Command
        def to_asm(jumptype)
            # we need two labels
            truelabel = VM::Helper.next_label
            endlabel = VM::Helper.next_label
            # pop top two stack elems into D and A
            asm = VM::Helper.load_into_d_a
            # calc A-D into D
            asm << 'D=A-D'
            # jump to truelabel if D is 0
            asm << "@#{truelabel}"
            asm << "D;#{jumptype}"
            # if we didn't jump, then the operands weren't equal,
            # so push false (0) to the stack and jump to endlabel
            asm << 'D=0'
            asm << VM::Helper.push_d
            asm << "@#{endlabel}"
            asm << '0;JMP'
            # otherwise, push true (-1) to the stack
            asm << "(#{truelabel})"
            asm << 'D=-1'
            asm << VM::Helper.push_d
            # mark endlabel
            asm << "(#{endlabel})"
            return asm.flatten
        end
    end

    class EqualsCommand < ComparisonCommand
        def descr
            "eq"
        end
        def to_asm
            super('JEQ')
        end
    end
    
    class LessThanCommand < ComparisonCommand
        def descr
            "lt"
        end
        def to_asm
            super('JLT')
        end
    end
    
    class GreaterThanCommand < ComparisonCommand
        def descr
            "gt"
        end
        def to_asm
            super('JGT')
        end
    end
    
    class AndCommand < LogicalCommand
        def descr
            "and"
        end
        def to_asm
            super(2, 'D&A')
        end
    end
    
    class OrCommand < LogicalCommand
        def descr
            "or"
        end
        def to_asm
            super(2, 'D|A')
        end
    end
    
    class NotCommand < LogicalCommand
        def descr
            "not"
        end
        def to_asm
            super(1, '!D')
        end
    end
    
    module Helper
    
        SEGBASE = {
            :argument => 'ARG',
            :this => 'THIS',
            :that => 'THAT',
            :local => 'LCL',
            :pointer => 3,
            :temp => 5,
        }
    
        # label generator sequence
        @@nextlabelnum = 0
        
        # gets the next usable label
        def self.next_label
            @@nextlabelnum += 1
            sprintf 'LABEL_%x', @@nextlabelnum
        end
    
        def self.inc_sp
            [ '@SP', 'M=M+1' ]
        end
        
        def self.dec_sp
            [ '@SP', 'M=M-1' ]
        end
        
        def self.push_d
            [ '@SP',  'A=M', 'M=D', self.inc_sp ]
        end

        def self.pop_d
            [ self.dec_sp, '@SP',  'A=M', 'D=M' ]
        end
        
        def self.load_into_d_a
            [ '@SP', 'AM=M-1', 'D=M', '@SP', 'AM=M-1', 'A=M' ]
        end

        def self.load_into_d
            [ '@SP', 'AM=M-1', 'D=M' ]
        end

    end

end
