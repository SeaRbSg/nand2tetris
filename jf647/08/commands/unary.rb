module VM

    class UnaryCommand < Command
        def to_asm(numops, calc)
            asm = []
            # pop stack elems
            asm << VM::Helper.load_into_d
            # perform the calculation
            asm << "D=#{calc}"
            # push D to stack
            asm << VM::Helper.push_d
            return asm.flatten
        end
    end

    class NegateCommand < UnaryCommand
        def descr
            "neg"
        end
        def to_asm
            super('-D')
        end
    end

    class NotCommand < UnaryCommand
        def descr
            "not"
        end
        def to_asm
            super('!D')
        end
    end

end
