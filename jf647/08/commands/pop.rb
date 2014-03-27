module VM

    class PopCommand < Command
        value :segname, Symbol
        value :offset, Fixnum
        value :ns, String
        def descr
            "pop #{@segname} #{@offset}"
        end
        def to_asm
            asm = []
            case @segname
                when :constant
                    raise 'cannot pop into constant segment'
                when :local, :argument, :this, :that
                    # *(base[segment]+offset), base is symbolic
                    # store offset in D
                    asm << "@#{@offset}"
                    asm << "D=A"
                    # inc by the base addr
                    asm << "@#{VM::Helper::SEGBASE[@segname]}"
                    asm << "D=M+D"
                    # store dest in R13
                    asm << '@R13'
                    asm << 'M=D'
                    # pop stack to D
                    asm << VM::Helper.pop_d
                    # put *R13 into M
                    asm << '@R13'
                    asm << 'A=M'
                when :temp, :pointer
                    # *(base[segment]+offset), base is constant
                    asm << VM::Helper.pop_d
                    asm << "@R#{VM::Helper::SEGBASE[@segname]+@offset}"
                when :static
                    # *(Xxx.j), where Xxx is the current filename
                    asm << VM::Helper.pop_d
                    asm << "@#{@ns}.#{@offset}"
                else
                    raise "unhandled segment '#{@segname}'"
            end
            # set M to popped value
            asm << 'M=D'
            return asm.flatten
        end
    end

end
