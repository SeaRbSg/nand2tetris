require 'rltk'

module Jack

    class Parser < RLTK::Parser

        # a jack compilation unit / class
        p(:class) do
            c('CLASS IDENT LBRACE cvardec* subdec* RBRACE') do |_,klass,_,cvars,subs,_|
                Jack::Class.new(klass, cvars, subs)
            end
        end

        # a class variable declaration
        p(:cvardec, 'cvarscope vartype identlist SEMICOLON') do |scope,type,names,_|
            Jack::ClassVarDec.new(scope, names, type)
        end

        # a variable declaration
        p(:vardec, 'VAR vartype identlist SEMICOLON')   do |_,type,names,_|
            Jack::VarDec.new(names, type)
        end

        # a class variable scope
        p(:cvarscope) do
            c('STATIC')     { |s| :static }
            c('FIELD')      { |s| :field }
        end

        # variable type
        p(:vartype) do
            c('INT')        { |t| Jack::VarType::Primitive.new(:int) }
            c('CHAR')       { |t| Jack::VarType::Primitive.new(:char) }
            c('BOOLEAN')    { |t| Jack::VarType::Primitive.new(:boolean) }
            c('IDENT')      { |t| Jack::VarType::Ident.new(t) }
        end

        # a nonempty list of variable names
        nonempty_list(:identlist, :IDENT, :COMMA)

        # a subroutine declaration
        p(:subdec) do
            c('subtype rettype IDENT LPAREN varlist RPAREN LBRACE subbody RBRACE') do |klass,rettype,name,_,params,_,_,body,_|
                klass = Module.const_get(klass)
                klass.new(klass, name, rettype, params, body)
            end
        end

        # a subroutine type
        p(:subtype) do
            c('CONSTRUCTOR')    { |_| 'Jack::Constructor' }
            c('FUNCTION')       { |_| 'Jack::Function' }
            c('METHOD')         { |_| 'Jack::Method' }
        end

        # subroutine return type
        p(:rettype) do
            c('VOID')           { |t| Jack::VarType::Void.new }
            c('vartype')        { |t| t }
        end

        # a variable declration
        p(:typedvar, 'vartype IDENT')   { |type,name| Jack::Var.new(name, type) }

        # a nonempty list of typed variables
        empty_list(:varlist, :typedvar, :COMMA)

        # a subroutine body
        p(:subbody, 'vardec* statements') do |vars,statements|
            Jack::SubBody.new(vars, statements)
        end

        # a possibly empty list of statements
        empty_list(:statements, :statement)

        # a jack statement
        p(:statement) do
            c('LET varref EQUALS expression SEMICOLON') do |_,var,_,expr,_|
                Jack::LetStatement.new(var, expr)
            end
            c('IF LPAREN expression RPAREN LBRACE statements RBRACE elseclause?') do |_,_,expr,_,_,ifstatements,_,elsestatements|
                if ! elsestatements.nil?
                    Jack::IfStatement.new(expr, ifstatements, elsestatements)
                else
                    Jack::IfStatement.new(expr, ifstatements, [])
                end
            end
            c('WHILE LPAREN expression RPAREN LBRACE statements RBRACE') do |_,_,expr,_,_,statements,_|
                Jack::WhileStatement.new(expr, statements)
            end
            c('DO subcall SEMICOLON') do |_,subcall,_|
                Jack::DoStatement.new(subcall)
            end
            c('RETURN expression? SEMICOLON') do |_,expr,_|
                Jack::ReturnStatement.new(expr)
            end
        end

        # a subroutine call
        p(:subcall, 'prefix? IDENT LPAREN expressionlist RPAREN') do |prefix,name,_,exprlist,_|
            Jack::SubCall.new(prefix, name, exprlist)
        end

        # the else clause to an if statement
        p(:elseclause, 'ELSE LBRACE statements RBRACE') do |_,_,statements,_|
            statements
        end

        # a prefix
        p(:prefix, 'IDENT DOT')    { |prefix,_| prefix }

        # a jack expression
        p(:opterm, 'op term')       { |op,term| Jack::Term::OpTerm.new(op, term) }
        p(:expression, 'term opterm*') do |t,t2|
            Jack::Expression.new( [ t,t2 ].flatten )
        end

        # an expression term
        p(:term) do
            c('INTEGER')            { |t| Jack::Term::Int.new t }
            c('STRING')             { |t| Jack::Term::String.new t }
            c('const')              { |t| t }
            c('varref')             { |t| Jack::Term::VarRef.new t }
            c('subcall')            { |t| Jack::Term::SubCall.new t }
            c('LPAREN expression RPAREN')   { |_,expr,_| Jack::Term::Expression.new expr }
            c('unaryop term')       { |op,term| Jack::Term::UnaryOp.new op, term }
        end

        # an expression operator
        p(:op) do
            c('PLUS')           { |t| Jack::Op.new '+', 'add' }
            c('MINUS')          { |t| Jack::Op.new '-', 'sub' }
            c('MULT')           { |t| Jack::Op.new '*', 'call Math.multiply 2' }
            c('DIV')            { |t| Jack::Op.new '/', 'call Math.divide 2' }
            c('AND')            { |t| Jack::Op.new '&', 'and' }
            c('OR')             { |t| Jack::Op.new '|', 'or' }
            c('LT')             { |t| Jack::Op.new '<', 'lt' }
            c('GT')             { |t| Jack::Op.new '>', 'gt' }
            c('EQUALS')         { |t| Jack::Op.new '=', 'eq' }
        end

        # a unary operation
        p(:unaryop) do
            c('MINUS')              { |t| Jack::Op.new '-', 'neg' }
            c('NEG')                { |t| Jack::Op.new '~', 'not' }
        end

        # a constant
        p(:const) do
            c('TRUE')   { |c| Jack::Term::Const.new(:true) }
            c('FALSE')  { |c| Jack::Term::Const.new(:false) }
            c('NULL')   { |c| Jack::Term::Const.new(:null) }
            c('THIS')   { |c| Jack::Term::Const.new(:this) }
        end

        # an index to an array var
        p(:arrindex, 'LBRACKET expression RBRACKET') do |_, expr, _|
            Jack::Expression.new [expr]
        end

        # a variable reference with optional array index
        p(:varref, 'IDENT arrindex?') do |name,expr|
            if ! expr.nil?
                Jack::VarRef.new(name, expr.expr[0])
            else
                Jack::VarRef.new(name)
            end
        end

        # a nonempty list of expressions
        empty_list(:expressionlist, :expression, :COMMA)

        finalize :explain => ENV.key?('DUMP_PARSER')

    end

end
