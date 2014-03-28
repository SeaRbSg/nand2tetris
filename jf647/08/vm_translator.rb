require 'vm_lexer'
require 'vm_ast'
require 'vm_parser'

module VM

    class Translator

        def translate(infname, ns)
            path = Pathname.new(infname)
            parser = VM::Parser.new
            parser.env.ns = ns.to_s.downcase
            path.each_line.each_with_index do |line, num|
                line.chomp!
                begin
                    node = parser.parse( VM::Lexer::lex( line ), :verbose => ENV.key?('DEBUG_PARSER') )
                    if node.is_a?(VMLine)
                        yield node if block_given?
                    else
                        raise "unexpected parse result '#{node.class}'"
                    end
                rescue => ex
                    raise "failed to parse #{infname} line #{num+1} '#{line}': #{ex}"
                end
            end
        end

    end

end
