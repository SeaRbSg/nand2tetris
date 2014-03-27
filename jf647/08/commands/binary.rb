module VM

    class BinaryCommand < Command
        def to_asm(calc)
            asm = []
            # pop stack elems
            asm << VM::Helper.load_into_d_a
            # perform the calculation
            asm << "D=#{calc}"
            # push D to stack
            asm << VM::Helper.push_d
            return asm.flatten
        end
    end

    class AddCommand < BinaryCommand
        def descr
            "add"
        end
        def to_asm
            super('A+D')
        end
    end

    class SubCommand < BinaryCommand
        def descr
            "sub"
        end
        def to_asm
            super('A-D')
        end
    end

    class AndCommand < BinaryCommand
        def descr
            "and"
        end
        def to_asm
            super('D&A')
        end
    end

    class OrCommand < BinaryCommand
        def descr
            "or"
        end
        def to_asm
            super('D|A')
        end
    end

end
