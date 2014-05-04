require 'jack_lexer'
require 'jack_ast'
require 'jack_parser'
require 'jack_output_xml'

module Jack

    class Compiler

        def compile(infname)
            path = Pathname.new(infname)
            begin
                tokens = Jack::Lexer::lex_file( path.to_s )
                ast = Jack::Parser.new.parse( tokens, :verbose => ENV.key?('DEBUG_PARSER') )
                if ast.is_a?(Jack::Class)
                    yield ast if block_given?
                else
                    raise "unexpected parse result '#{ast.class}'"
                end
            rescue RLTK::LexingError => e
                raise "couldn't lex #{infname} at line #{e.line_number} position #{e.line_offset}, at #{e.remainder[0,50]}"
            rescue RLTK::NotInLanguage => e
                raise "couldn't parse #{e.current.position.file_name} at line #{e.current.position.line_number} position #{e.current.position.line_offset}; current token #{e.current}; parsed #{e.seen.size} tokens (#{e.seen.map{|e|e.type}.join(',')}), remaining #{e.remaining.size} tokens (#{e.remaining.map{|e|e.type}.join(',')})"
            end
        end

    end

end
