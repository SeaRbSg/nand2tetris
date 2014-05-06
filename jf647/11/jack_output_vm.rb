require 'jack_ast'
require 'jack_symtable'
require 'jack_labelseq'

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
            st = Jack::SymTable.instance
            st.newsub
            numlocals = @body.vardecs.reduce(0) { |n,e| n += e.names.size }
            block.call "function #{@parent.klass.to_s}.#{@name.to_s} #{numlocals}"
            @params.each do |param|
                st.add(param.name, param.type, :arg)
            end
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
            st = Jack::SymTable.instance
            @names.each do |name|
                st.add(name, @type.type, :var)
            end
        end

    end

    class VarRef

        def render block
            st = Jack::SymTable.instance
            case st.kind(@name)
            when :var
                block.call "push local #{st.index(@name)}"
            when :arg
                block.call "push argument #{st.index(@name)}"
            else
                raise "NYI: unknown kind for var #{@name}"
            end

        end

    end

    class DoStatement

        def render block
            @subcall.render block
        end
    end

    class ReturnStatement

        def render block
            # walk up the AST until we find something that
            # responds to rettype
            ptr = self
            while true
                if ptr.respond_to?(:rettype)
                    case ptr.rettype
                    when Jack::VarType::Void
                        block.call "push constant 0"
                    else
                        @expr.render block
                    end
                    block.call "return"
                    return
                else
                    if ptr.respond_to?(:parent) && ! ptr.parent.nil?
                        ptr = ptr.parent
                    else
                        raise 'hit top of tree searching for return type'
                    end
                end
            end
        end

    end

    class LetStatement

        def render block
            st = Jack::SymTable.instance
            if ! @var.index.nil?
                raise 'NYI: let with indexed LHS'
            end
            @expr.render block
            case st.kind(@var.name)
            when :var
                block.call "pop local #{st.index(@var.name)}"
            when :arg
                block.call "pop argument #{st.index(@var.name)}"
            else
                raise "NYI: unknown kind for var #{@name} in let statement"
            end
        end

    end

    class WhileStatement

        def render block
            ls = Jack::LabelSeq.instance
            l1 = ls.nextlabel
            l2 = ls.nextlabel
            block.call "label #{l1}"
            @expr.render block
            block.call "not"
            block.call "if-goto #{l2}"
            @statements.each do |statement|
                statement.render block
            end
            block.call "goto #{l1}"
            block.call "label #{l2}"
        end

    end

    class IfStatement

        def render block
            ls = Jack::LabelSeq.instance
            l1 = ls.nextlabel
            l2 = ls.nextlabel
            @expr.render block
            block.call "not"
            block.call "if-goto #{l1}"
            @ifstatements.each do |statement|
                statement.render block
            end
            block.call "goto #{l2}"
            block.call "label #{l1}"
            @elsestatements.each do |statement|
                statement.render block
            end
            block.call "label #{l2}"
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

        class SubCall

            def render block
                @value.render block
            end

        end

        class VarRef

            def render block
                @value.render block
            end

        end

        class Const

            def render block

                case @value
                when :true
                    block.call 'push constant 1'
                    block.call 'neg'
                when :false, :null
                    block.call 'push constant 0'
                else
                    raise 'NYI: non true/false/null constant'
                end

            end

        end

    end

end
