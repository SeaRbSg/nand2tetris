require 'promise'

module JohnnyFive

    class Command
    end
    
    class ACommand < Command
        attr_reader :unresolved
        def initialize(v, st=nil)
            if Symbol == v.class
                @v = promise { st.get(v) }
            else
                @v = v.to_i
            end
        end
        def to_bin
            sprintf('%0.16b', @v)
        end
    end
    
    class CCommand < Command
        attr_reader :dest, :comp, :jump
        def initialize(dest, comp, jump)
            @dest = dest || 0
            @comp = comp || 0
            @jump = jump || 0
        end
        def to_bin
            sprintf(
                '%0.16b',
                0b111 << 13 | 
                @comp <<  6 |
                @dest <<  3 |
                @jump
            )
        end
    end

end
