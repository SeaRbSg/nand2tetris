require 'j5_lexer'
require 'j5_ast'
require 'j5_parser'

module JohnnyFive

    class Assembler

        def assemble(infname, outfname)
            JohnnyFive::Parser::parse(JohnnyFive::Lexer::lex_file(infname), :verbose => ENV.key?('VERBOSE'))
        end
        
    end

end
