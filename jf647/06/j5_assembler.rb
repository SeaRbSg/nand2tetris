require 'j5_types'
require 'j5_parser'
require 'j5_symtable'

module JohnnyFive

    class Assembler

        def assemble(infname)
            statements = []
            parser = Parser.new(SymTable.new)
            File.open(infname).each_line.each_with_index do |line, num|
                begin
                    line.chomp!
                    statement = parser.parse(line, statements.size)
                    case
                        when statement.is_a?(Command)
                            statements << statement
                        when statement.nil?
                            # non-statement line (comment, blank or symbol set)
                        else
                            raise "unexpected parse result '#{statement.class}'"
                    end
                rescue => ex
                    raise "failed to parse line #{num+1} '#{line}': #{ex.class}"
                end
            end
            statements.each { |s| yield s } if block_given?
        end
        
    end

end
