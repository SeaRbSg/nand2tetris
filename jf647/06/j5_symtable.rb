module JohnnyFive

    class SymTable
    
        def initialize
            @table = {
                :SP => 0,
                :LCL => 1,
                :ARG => 2,
                :THIS => 3,
                :THAT => 4,
                :SCREEN => 16384,
                :KBD => 24576,
            }
            0.upto(15).each{|i| @table["R#{i}".to_sym] = i}
            @ptr = 0x0010
        end

        def get(k, final=false)
            if ! @table.key?(k)
                raise "symbol #{k} is not defined" if final
                @table[k] = @ptr
                @ptr += 1
            end
            @table[k]
        end
    
    end

end
