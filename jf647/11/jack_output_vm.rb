require 'jack_ast'
require 'jack_symtable'
require 'jack_labelseq'

module Jack

    class Class

        def render &block
            st = Jack::SymTable.instance
            st.newclass
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

    class Constructor

        def render block
            st = Jack::SymTable.instance
            st.newsub
            numlocals = @body.vardecs.reduce(0) { |n,e| n += e.names.size }
            numfields = 0
            @parent.cvardecs.select{|e| e.scope == :field}.each do |e|
                e.names.each do |name|
                    st.add(name, e.type, :field)
                    numfields += 1
                end
            end
            @parent.cvardecs.select{|e| e.scope == :static}.each do |e|
                e.names.each do |name|
                    st.add(name, e.type, :static)
                end
            end
            block.call "function #{@parent.klass.to_s}.#{@name.to_s} #{numlocals}"
            block.call "push constant #{numfields}"
            block.call "call Memory.alloc 1"
            block.call "pop pointer 0"
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

    class Method

        def render block
            st = Jack::SymTable.instance
            st.newsub
            numlocals = @body.vardecs.reduce(0) { |n,e| n += e.names.size }
            block.call "function #{@parent.klass.to_s}.#{@name.to_s} #{numlocals}"
            st.bumpi(:arg)
            @params.each do |param|
                st.add(param.name, param.type, :arg)
            end
            @body.vardecs.each do |vd|
                vd.render block
            end
            block.call "push argument 0"
            block.call "pop pointer 0"
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
            if ! @index.nil?
                @index.render block
                case st.kind(@name)
                when :var
                    block.call "push local #{st.index(@name)}"
                when :arg
                    block.call "push argument #{st.index(@name)}"
                when :static
                    block.call "push static #{st.index(@name)}"
                when :field
                    block.call "push this #{st.index(@name)}"
                end
                block.call "add"
                block.call "pop pointer 1"
                block.call "push that 0"
            else
                case st.kind(@name)
                when :var
                    block.call "push local #{st.index(@name)}"
                when :arg
                    block.call "push argument #{st.index(@name)}"
                when :static
                    block.call "push static #{st.index(@name)}"
                when :field
                    block.call "push this #{st.index(@name)}"
                end
            end
        end

    end

    class DoStatement

        def render block
            @subcall.render block
            block.call "pop temp 0"
        end
    end

    class ReturnStatement

        def render block
            ptr = Jack.walk_up_to(self, Jack::Sub)
            case ptr.rettype
            when Jack::VarType::Void
                block.call "push constant 0"
            else
                @expr.render block
            end
            block.call "return"
        end

    end

    class LetStatement

        def render block
            st = Jack::SymTable.instance
            if ! @var.index.nil?
                @var.index.render block
                case st.kind(@var.name)
                when :var
                    block.call "push local #{st.index(@var.name)}"
                when :arg
                    block.call "push argument #{st.index(@var.name)}"
                when :static
                    block.call "push static #{st.index(@var.name)}"
                when :field
                    block.call "push this #{st.index(@var.name)}"
                end
                block.call "add"
                @expr.render block
                block.call "pop temp 0"
                block.call "pop pointer 1"
                block.call "push temp 0"
                block.call "pop that 0"
            else
                @expr.render block
                case st.kind(@var.name)
                when :var
                    block.call "pop local #{st.index(@var.name)}"
                when :arg
                    block.call "pop argument #{st.index(@var.name)}"
                when :static
                    block.call "pop static #{st.index(@var.name)}"
                when :field
                    block.call "pop this #{st.index(@var.name)}"
                end
            end
        end

    end

    class WhileStatement

        def render block
            ls = Jack::LabelSeq.instance
            l1 = ls.nextlabel('WHILE_EXP%x')
            l2 = ls.nextlabel('WHILE_END%x')
            block.call "label #{l1}"
            @expr.render block
            block.call 'not'
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
            l1 = ls.nextlabel('IF_TRUE%x')
            l2 = ls.nextlabel('IF_FALSE%x')
            @expr.render block
            block.call "if-goto #{l1}"
            @elsestatements.each do |statement|
                statement.render block
            end
            block.call "goto #{l2}"
            block.call "label #{l1}"
            @ifstatements.each do |statement|
                statement.render block
            end
            block.call "label #{l2}"
        end

    end

    class SubCall

        def render block
            st = Jack::SymTable.instance
            exprcount = @exprlist.size
            # if we don't have a prefix, we look in this class to
            # determine if the name is a function or method
            if @prefix.nil?
                @prefix = st.classname
                exprcount += 1
                block.call "push pointer 0"
            else
                # is the prefix in the symbol table?
                type = st.type(@prefix)
                if type.is_a?(Jack::VarType::Ident)
                    type = type.type
                end
                if :none != type
                    exprcount += 1
                    # the prefix is the type of the var
                    kind = st.kind(@prefix)
                    index = st.index(@prefix)
                    @prefix = type
                    case kind
                    when :var
                        block.call "push local #{index}"
                    when :arg
                        block.call "push argument #{index}"
                    when :static
                        block.call "push static #{index}"
                    when :field
                        block.call "push this #{index}"
                    else
                        raise "NYI: unknown kind for var #{@prefix} in let statement"
                    end
                end
            end
            # push the params
            @exprlist.each do |e|
                e.render block
            end
            # call the func
            block.call "call #{@prefix.to_s}.#{@name.to_s} #{exprcount}"
            # if the thing we're calling has a void return, pop the dummy result

        end
    end

    class Expression

        def render block
            @expr.compact.each do |e|
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

        class String

            def render block
                block.call "push constant #{@value.length}"
                block.call "call String.new 1"
                @value.each_codepoint do |i|
                    block.call "push constant #{i}"
                    block.call "call String.appendChar 2"
                end
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
                    block.call 'push constant 0'
                    block.call 'not'
                when :false, :null
                    block.call 'push constant 0'
                when :this
                    block.call 'push pointer 0'
                else
                    raise "NYI: non true/false/null constant #{@value}"
                end

            end

        end

    end

end
