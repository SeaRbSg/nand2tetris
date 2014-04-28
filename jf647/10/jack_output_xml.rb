require 'jack_ast'
require 'builder'

module Jack

    class Class

        def render
            out = Builder::XmlMarkup.new( :indent=> 2 )
            out.class do |xml_c|
                xml_c.keyword 'class'
                xml_c.identifier @klass.to_s
                xml_c.symbol '{'
                if ! @cvars.empty?
                    raise "NYI: @cvars"
                end
                subs.each do |sub|
                    sub.render xml_c
                end
                xml_c.symbol '}'
            end
            out.target!
        end

    end

    class Sub

        def render xml

            xml.subroutineDec do |xml_sd|
                xml_sd.keyword @klass.keyword
                xml_sd.keyword @rettype.to_s
                xml_sd.identifier @name.to_s
                xml_sd.symbol '('
                xml_sd.parameterList do
                    @params.each do |param|
                        raise 'NYI: subparams'
                    end
                end
                xml_sd.symbol ')'
                @body.render xml_sd
            end

        end
    end

    class SubBody

        def render xml

            xml.subroutineBody do |xml_sb|
                xml_sb.symbol '{'
                @vardec.each do |var|
                    var.render xml_sb
                end
                xml_sb.statements do |xml_stmts|
                    @statements.each do |stmt|
                        stmt.render xml_stmts
                    end
                end
                xml_sb.symbol '}'
            end

        end

    end

    class VarDec

        def render xml

            xml.varDec do |xml_vd|
                xml_vd.keyword 'var'
                xml_vd.identifier @type.to_s
                xml_vd.identifier @name.to_s
                xml_vd.symbol ';'
            end

        end

    end

    class LetStatement

        def render xml
            xml.letStatement do |xml_let|
                xml_let.keyword 'let'
                xml_let.identifier @var.name.to_s
                xml_let.symbol '='
                @expr.render xml_let
                xml_let.symbol ';'
            end
        end

    end

    class IfStatement

        def render xml

            xml.ifStatement do |xml_if|
                xml_if.keyword 'if'
                xml_if.symbol ';'
            end

        end

    end

    class WhileStatement

        def render xml

            xml.whileStatement do |xml_while|
                xml_while.keyword 'while'
                xml_while.symbol ';'
            end

        end

    end

    class DoStatement

        def render xml

            xml.doStatement do |xml_do|
                xml_do.keyword 'do'
                @subcall.render xml_do
                xml_do.symbol ';'
            end

        end

    end

    class ReturnStatement

        def render xml

            xml.returnStatement do |xml_return|
                xml_return.keyword 'return'
                xml_return.symbol ';'
            end

        end

    end

    class Expression

        def render xml

            xml.expression do |xml_expr|
                @expr.each do |e|
                    xml_expr.term do |xml_term|
                        xml_term.identifier e.name.to_s
                    end
                end
            end

        end

    end

    class SubCall

        def render xml

            if @prefix
                xml.identifier @prefix.to_s
                xml.symbol '.'
            end
            xml.identifier @name.to_s
            xml.symbol '('
            xml.expressionList do |xml_exprlist|
                @exprlist.each do |expr|
                    expr.render xml_exprlist
                end
            end
            xml.symbol ')'
        end

    end

end
