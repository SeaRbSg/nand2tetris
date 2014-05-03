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
                @cvardecs.each do |cvar|
                    cvar.render xml_c
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
                @rettype.render xml_sd
                xml_sd.identifier @name.to_s
                xml_sd.symbol '('
                xml_sd.parameterList do |xml_pl|
                    @params.each_with_index do |param, i|
                        param.render xml_pl
                        if i != (@params.size-1)
                            xml_pl.symbol ','
                        end
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
                @vardecs.each do |var|
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
                @type.render xml_vd
                @names.each_with_index do |name, i|
                    xml_vd.identifier name.to_s
                    if i != (@names.size-1)
                        xml_vd.symbol ','
                    end
                end
                xml_vd.symbol ';'
            end

        end

    end

    class Var

        def render xml
            @type.render xml
            xml.identifier @name.to_s
        end

    end

    class ClassVarDec

        def render xml

            xml.classVarDec do |xml_cvd|
                xml_cvd.keyword @scope.to_s
                @type.render xml_cvd
                @names.each_with_index do |name, i|
                    xml_cvd.identifier name.to_s
                    if i != (@names.size-1)
                        xml_cvd.symbol ','
                    end
                end
                xml_cvd.symbol ';'
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
                xml_if.symbol '('
                @expr.render xml_if
                xml_if.symbol ')'
                xml_if.symbol '{'
                xml_if.statements do |xml_stmts|
                    @ifstatements.each do |stmt|
                        stmt.render xml_stmts
                    end
                end
                xml_if.symbol '}'
            end

        end

    end

    class WhileStatement

        def render xml

            xml.whileStatement do |xml_while|
                xml_while.keyword 'while'
                xml_while.symbol '('
                @expr.render xml_while
                xml_while.symbol ')'
                xml_while.symbol '{'
                xml_while.statements do |xml_stmts|
                    @statements.each do |stmt|
                        stmt.render xml_stmts
                    end
                end
                xml_while.symbol '}'
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
                if @expr
                    @expr.render xml_return
                end
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
                @exprlist.each.with_index do |expr, i|
                    expr.render xml_exprlist
                    if i != (@exprlist.size-1)
                        xml_exprlist.symbol ','
                    end
                end
            end
            xml.symbol ')'
        end

    end

    class VarType

        class Primitive

            def render xml
                xml.keyword @type.to_s
            end

        end

        class Class

            def render xml
                xml.identifier @type.to_s
            end

        end

        class Void

            def render xml
                xml.keyword 'void'
            end

        end

    end

end
