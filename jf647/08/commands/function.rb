module VM

    class FunctionCommand < Command

        value :name, Symbol
        value :numloc, Fixnum

        def descr
            "function #{@name} with #{@numloc} local variables"
        end

        def to_asm
            asm = [ "(#{@name})" ]
            @numloc.times do
                asm << PushCommand.new(:constant, 0, nil)
            end
            return asm.map{|e| e.is_a?(Command) ? e.to_asm : e }.flatten
        end

    end

    class ReturnCommand < Command

        def descr
            "return from function"
        end

        def to_asm
            asm = []
            # set R13 to the value of LCL
            asm << '@LCL'
            asm << 'D=M'
            asm << '@R13'
            asm << 'M=D'
            # set R14 to the value of FRAME-5
            asm << '@5'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@R14'
            asm << 'M=D'
            # set *ARG to the top of the stack
            asm << VM::Helper.load_into_d
            asm << '@ARG'
            asm << 'A=M'
            asm << 'M=D'
            # set SP to ARG+1
            asm << '@SP'
            asm << 'M=D+1'
            # set THAT to the value of FRAME-1
            asm << '@R14'
            asm << 'D=M'
            asm << '@1'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@THAT'
            asm << 'M=D'
            # set THIS to the value of FRAME-1
            asm << '@R14'
            asm << 'D=M'
            asm << '@2'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@THIS'
            asm << 'M=D'
            # set THIS to the value of FRAME-1
            asm << '@R14'
            asm << 'D=M'
            asm << '@2'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@THIS'
            asm << 'M=D'
            # set ARG to the value of FRAME-3
            asm << '@R14'
            asm << 'D=M'
            asm << '@3'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@THIS'
            asm << 'M=D'
            # set LCL to the value of FRAME-4
            asm << '@R14'
            asm << 'D=M'
            asm << '@4'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@LCL'
            asm << 'M=D'
            # goto RET
            asm << '@R14'
            asm << 'A=M'
            asm << '0;JMP'
            return asm.map{|e| e.is_a?(Command) ? e.to_asm : e }.flatten
        end

    end

end
