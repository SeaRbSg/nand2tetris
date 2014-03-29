module VM

    class FunctionCommand < Command

        value :name, Symbol
        value :numloc, Fixnum

        def descr
            "declare function #{@name} with #{@numloc} local variables"
        end

        def to_asm
            asm = [ "(#{@name})" ]
            @numloc.times do
                asm << PushCommand.new(:constant, 0, nil)
            end
            return asm.map{|e| e.is_a?(Command) ? e.to_asm : e }.flatten
        end

    end

    class CallCommand < Command

        value :name, Symbol
        value :numloc, Fixnum

        def initialize(a,b)
            super
            @return_label = "return-#{VM::LabelSeq.instance.seq}".to_sym
        end

        def descr
            "call function #{@name} with #{@numloc} local variables"
        end

        def to_asm
            asm = []
            # push return address
            asm << "@#{@return_label}"
            asm << "D=A"
            asm << VM::Helper.push_d
            # push LCL, ARG, THIS, THAT
            %w(LCL ARG THIS THAT).each do |e|
                asm << "@#{e}"
                asm << "D=M"
                asm << VM::Helper.push_d
            end
            # set ARG to SP-n-5
            asm << '@SP'
            asm << 'D=M'
            asm << "@#{numloc}"
            asm << "D=D-A"
            asm << '@5'
            asm << 'D=D-A'
            asm << '@ARG'
            asm << 'M=D'
            # set LCL to SP
            asm << '@SP'
            asm << 'D=M'
            asm << '@LCL'
            asm << 'M=D'
            # goto the function
            asm << GotoCommand.new(@name)
            # declare a label that return will send us to
            asm << LabelCommand.new(@return_label)
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
            # set *ARG to the value on the top of the stack
            asm << VM::Helper.load_into_d
            asm << '@ARG'
            asm << 'A=M'
            asm << 'M=D'
            # set SP to ARG+1
            asm << '@ARG'
            asm << 'D=M+1'
            asm << '@SP'
            asm << 'M=D'
            # set THAT to *(FRAME-1)
            asm << '@R13'
            asm << 'D=M'
            asm << '@1'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@THAT'
            asm << 'M=D'
            # set THIS to *(FRAME-2)
            asm << '@R13'
            asm << 'D=M'
            asm << '@2'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@THIS'
            asm << 'M=D'
            # set ARG to *(FRAME-3)
            asm << '@R13'
            asm << 'D=M'
            asm << '@3'
            asm << 'A=D-A'
            asm << 'D=M'
            asm << '@ARG'
            asm << 'M=D'
            # set LCL to *(FRAME-4)
            asm << '@R13'
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
            return asm.flatten
        end

    end

end
