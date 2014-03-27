module VM

    class ControlCommand < Command
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
        end
    end

end
