module VM

    class ControlCommand < Command
    end

    class GotoCommand < Command

        value :sym, Symbol

        def descr
            "goto #{@sym}"
        end

        def to_asm
            asm = []
            asm << "@#{sym}"
            asm << "0;JMP"
            return asm.flatten
        end

    end

    class IfGotoCommand < ControlCommand

        value :sym, Symbol

        def descr
            "if-goto #{@sym}"
        end

        def to_asm
            asm = VM::Helper.load_into_d
            asm << "@#{sym}"
            asm << "D;JNE"
            return asm.flatten
        end

    end

end
