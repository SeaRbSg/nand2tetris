module VM

    class LabelCommand < Command

        value :sym, Symbol

        def descr
            "label #{@sym}"
        end

        def to_asm
            "(#{@sym})"
        end

    end

end