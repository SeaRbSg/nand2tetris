module VM

    class LabelCommand < Command

        value :label, Symbol

        def descr
            "label #{@label}"
        end

        def to_asm
            "(#{@label})"
        end

    end

end