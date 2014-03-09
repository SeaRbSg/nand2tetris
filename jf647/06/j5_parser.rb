module JohnnyFive
    
    class Parser

        def initialize(symtable)
            @syms = symtable
        end

        def parse(origline, nextinstr)
            # trim comments to end of line
            line = origline.gsub(/\/\/.*$/, '')
            # remove whitespace
            line.strip!
            # skip empty lines
            return nil if line.match(/^\s*$/)

            # parse commands
            if m = line.match(/^@(\d+)$/)
                # A command constant
                return ACommand.new(m[1], @syms)
            elsif m = line.match(/^@([a-zA-Z_\.\$\:][\w\.\$\:]*)$/)
                # A command symbol
                return ACommand.new(m[1].to_sym, @syms)
            elsif m = line.match(/^(?:([AMD]+)=)?([-+\!\&\|AMD01]+)(?:;(J[A-Z]{2}))?$/)
                # C command
                dest = @@dest_bits[m[1]] if m[1]
                comp = @@comp_bits[m[2]] if m[2]
                jump = @@jump_bits[m[3]] if m[3]
                return CCommand.new(dest, comp, jump)
            elsif m = line.match(/^\(([a-zA-Z_\.\$\:][\w\.\$\:]*)\)$/)
                # set symbol addr
                @syms.set m[1].to_sym, nextinstr
                return nil
            end

            # anything else is an error
            raise "unparseable line '#{origline}'"
        end
        
        # given the time I wasted trying to develop a CFG for Hack,
        # I've made no attempt to optimize the C-part parsers
        
        # turn dest specifications into bits
        @@dest_bits = Hash.new{ |h,k| raise "invalid dest specification '#{k}'" }.merge!({
            'M'   => 0b001,
            'D'   => 0b010,
            'MD'  => 0b011,
            'A'   => 0b100,
            'AM'  => 0b101,
            'AD'  => 0b110,
            'AMD' => 0b111,
        })
        
        # turn comp specifications into bits
        @@comp_bits = Hash.new{ |h,k| raise "invalid comp specification '#{k}'" }.merge!({
            '0'   => 0b0101010,
            '1'   => 0b0111111,
            '-1'  => 0b0111010,
            'D'   => 0b0001100,
            'A'   => 0b0110000,
            '!D'  => 0b0001101,
            '!A'  => 0b0110001,
            '-D'  => 0b0001111,
            '-A'  => 0b0110011,
            'D+1' => 0b0011111,
            'A+1' => 0b0110111,
            'D-1' => 0b0001110,
            'A-1' => 0b0110010,
            'D+A' => 0b0000010,
            'D-A' => 0b0010011,
            'A-D' => 0b0000111,
            'D&A' => 0b0000000,
            'D|A' => 0b0010101,
            'M'   => 0b1110000,
            '!M'  => 0b1110001,
            '-M'  => 0b1110011,
            'M+1' => 0b1110111,
            'M-1' => 0b1110010,
            'D+M' => 0b1000010,
            'D-M' => 0b1010011,
            'M-D' => 0b1000111,
            'D&M' => 0b1000000,
            'D|M' => 0b1010101,
        })
        
        # turn jump specifications into bits
        @@jump_bits = Hash.new{ |h,k| raise "invalid jump specification '#{k}'" }.merge!({
            'JGT' => 0b001,
            'JEQ' => 0b010,
            'JGE' => 0b011,
            'JLT' => 0b100,
            'JNE' => 0b101,
            'JLE' => 0b110,
            'JMP' => 0b111,
        })

    end

end
