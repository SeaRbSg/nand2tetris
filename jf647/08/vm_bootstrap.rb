module VM

    class Bootstrap

        def descr
            "bootstrap stack"
        end

        def to_asm
            asm = []
            asm << '@256'
            asm << 'D=A'
            asm << '@SP'
            asm << 'M=D'
            asm << VM::CallCommand.new('Sys.init'.to_sym, 0, VM::LabelSeq.instance.seq)
            return asm.map{|e| e.is_a?(Command) ? e.to_asm : e }.flatten
        end
    end

end