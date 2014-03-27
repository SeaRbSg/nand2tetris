module VM

    class PushCommand < Command
        value :segname, Symbol
        value :offset, Fixnum
        value :ns, String
        def descr
            "push #{@segname} #{@offset}"
        end
        def to_asm
            asm = []
            # get the value into the D reg
            case @segname
                when :constant
                    # literal value of the offset
                    asm << "@#{offset}"
                    asm << 'D=A'
                when :local, :argument, :this, :that
                    # *(base[segment]+offset), base is symbolic
                    # store offset in D
                    asm << "@#{@offset}"
                    asm << "D=A"
                    # inc by the base addr
                    asm << "@#{VM::Helper::SEGBASE[@segname]}"
                    asm << "A=M+D"
                    # deref into D
                    asm << 'D=M'
                when :temp, :pointer
                    # *(base[segment]+offset), base is constant
                    asm << "@R#{VM::Helper::SEGBASE[@segname]+@offset}"
                    asm << 'D=M'
                when :static
                    # *(Xxx.j), where Xxx is the current filename
                    asm << "@#{@ns}.#{@offset}"
                    asm << 'D=M'
                else
                    raise "unhandled segment '#{@segname}'"
            end
            # push D to stack
            asm << VM::Helper.push_d
            return asm.flatten
        end
    end

end
