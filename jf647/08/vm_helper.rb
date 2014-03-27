module VM

    module Helper

        SEGBASE = {
            :argument => 'ARG',
            :this => 'THIS',
            :that => 'THAT',
            :local => 'LCL',
            :pointer => 3,
            :temp => 5,
        }

        # label generator sequence
        @@nextlabelnum = 0

        # gets the next usable label
        def self.next_label
            @@nextlabelnum += 1
            sprintf 'LABEL_%x', @@nextlabelnum
        end

        def self.inc_sp
            [ '@SP', 'M=M+1' ]
        end

        def self.dec_sp
            [ '@SP', 'M=M-1' ]
        end

        def self.push_d
            [ '@SP',  'A=M', 'M=D', self.inc_sp ]
        end

        def self.pop_d
            [ self.dec_sp, '@SP',  'A=M', 'D=M' ]
        end

        def self.load_into_d_a
            [ self.load_into_d, '@SP', 'AM=M-1', 'A=M' ]
        end

        def self.load_into_d
            [ '@SP', 'AM=M-1', 'D=M' ]
        end

    end

end
