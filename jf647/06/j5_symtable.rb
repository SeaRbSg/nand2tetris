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
            @next = 0x0010
        end

        def get(s)
            # if the symbol isn't in the table, assign it the
            # next available memory slot
            # return the (possibly new) addr for the symbol
            if ! @table.key?(s)
                @table[s] = @next
                @next += 1
            end
            @table[s]
        end
        
        def set(s, v)
            if @table.key(s)
                raise "symbol #{s} is already defined"
            end
            @table[s] = v.to_i
        end
    
    end

end
