require 'jack_ast'

module Jack

    class Class

        def render &block
            @subs.each do |sub|
                sub.render block
            end
        end

    end

    class Function

        def render block
            block.call "function #{@parent.klass.to_s}.#{@name.to_s} #{@params.size}"
            @body.vardecs.each do |vd|
                vd.render block
            end
            @body.statements.each do |statement|
                statement.render block
            end
        end

    end

    class VarDec

        def render block
        end

    end

    class DoStatement

        def render block
            @subcall.render block
        end
    end

    class ReturnStatement

        def render block
            case @parent.parent.rettype
            when Jack::VarType::Void
                block.call "push constant 0"
            else
                @expr.render block
            end
            block.call "return"
        end
    end

    class SubCall

        def render block
            @exprlist.each do |e|
                e.render block
            end
            block.call "call #{@prefix.to_s}.#{@name.to_s} #{@exprlist.size}"
        end
    end

    class Expression

        def render block
            @expr.flatten.compact.each do |e|
                e.render block
            end
        end

    end

    class Op

        def render block
            block.call "#{@vmop}"
        end

    end

    class Term

        class Int

            def render block
                block.call "push constant #{@value}"
            end

        end

        class OpTerm

            def render block
                @term.render block
                @op.render block
            end
        end

        class Expression

            def render block
                @value.render block
            end

        end

        class UnaryOp

            def render block
                @term.render block
                @op.render block
            end
        end

    end

end
