module VM

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

end
