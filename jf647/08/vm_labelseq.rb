require 'singleton'

module VM

    class LabelSeq

        include Singleton

        def initialize
            @seq = 0
        end

        def seq
            ret = @seq
            @seq += 1
            ret
        end

    end
end