require 'j5_lexer'
require 'j5_ast'
require 'j5_parser'

module JohnnyFive

    class Assembler

        def assemble(infname)
            File.open(infname).each_line.each_with_index do |line, num|
                line.chomp!
                begin
                    node = JohnnyFive::Parser::parse(JohnnyFive::Lexer::lex(line), :verbose => ENV.key?('VERBOSE'))
                    case
                        when node.is_a?(Command)
                            puts "saw a #{node.class}: #{node.inspect}"
                            yield node if block_given?
                        when (node.is_a?(Comment) or node.is_a?(Blank))
                            # no-op
                    else
                        raise "unexpected parse result '#{node.class}'"
                    end
                rescue => ex
                    raise "failed to parse line #{num+1} '#{line}': #{ex}"
                end
            end
        end
        
    end

end
