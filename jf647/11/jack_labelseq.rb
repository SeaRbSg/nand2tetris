require 'singleton'

module Jack

    class LabelSeq

        include Singleton

        def initialize
            @seq = Hash.new(0)
        end

        def nextlabel(prefix = 'LABEL_%x')
            label = sprintf(prefix, @seq[prefix])
            @seq[prefix] += 1
            label
        end

    end
end
