require 'j5_lexer'
require 'j5_parser'

class JohnnyFive

    def assemble(infname, outfname)
        JohnnyFiveLexer.lex_file(infname)
    end

end
