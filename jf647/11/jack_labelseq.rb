require 'singleton'

module Jack

    class LabelSeq

        include Singleton

        def initialize
            @seq = 0
        end

        def nextlabel(prefix = 'LABEL_%x')
            label = sprintf(prefix, @seq)
            @seq += 1
            label
        end

    end
end
