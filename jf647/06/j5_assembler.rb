require 'j5_lexer'
require 'j5_ast'
require 'j5_parser'

module JohnnyFive

    class Assembler

        def assemble(infname)
            File.open(infname).each_line.each_with_index do |line, num|
                begin
                    puts "parsing #{line}"
                    node = JohnnyFive::Parser::parse(JohnnyFive::Lexer::lex(line), :verbose => ENV.key?('VERBOSE'))
                    case
                        when node.is_a?(Command)
                            puts "saw a #{node.class}: #{node.inspect}"
                            yield node if block_given?
                        when node.is_a?(Comment)
                            puts "saw a Comment"
                        when node.is_a?(Blank)
                            puts "saw a Blank"
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
