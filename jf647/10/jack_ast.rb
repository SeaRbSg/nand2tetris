require 'rltk/ast'

module Jack

    class VarType < RLTK::ASTNode
        value :type, Symbol

        class Primitive < VarType
        end

        class Class < VarType
        end

        class Void < VarType
        end
    end

    class Const < RLTK::ASTNode
        value :type, Symbol
    end

    class Op < RLTK::ASTNode
        value :op, String
    end

    class ClassVarDec < RLTK::ASTNode
        value :scope, Symbol
        value :names, [Symbol]
        child :type, Jack::VarType
    end

    class VarDec < RLTK::ASTNode
        value :names, [Symbol]
        child :type, Jack::VarType
    end

    class Expression < RLTK::ASTNode
        value :expr, Array
        def empty?
            ! @expr.flatten.any?
        end
    end

    class Var < RLTK::ASTNode
        value :name, Symbol
        child :type, Jack::VarType
    end

    class VarRef < RLTK::ASTNode
        value :name, Symbol
        child :index, Jack::Expression
    end

    class Statement < RLTK::ASTNode
    end

    class SubBody < RLTK::ASTNode
        child :vardecs, [Jack::VarDec]
        child :statements, [Jack::Statement]
    end

    class Sub < RLTK::ASTNode
        value :klass, Class
        value :name, Symbol
        child :rettype, Jack::VarType
        child :params, [Jack::Var]
        child :body, Jack::SubBody
    end

    class Constructor < Sub
        def self.keyword
            'constructor'
        end
    end

    class Function < Sub
        def self.keyword
            'function'
        end
    end

    class Method < Sub
        def self.keyword
            'method'
        end
    end

    class Class < RLTK::ASTNode
        value :klass, Symbol
        child :cvardecs, [Jack::ClassVarDec]
        child :subs, [Jack::Sub]
    end

    class LetStatement < Statement
        child :var, Jack::VarRef
        child :expr, Jack::Expression
    end

    class IfStatement < Statement
        child :expr, Jack::Expression
        child :ifstatements, [Jack::Statement]
        child :elsestatements, [Jack::Statement]
    end

    class WhileStatement < Statement
        child :expr, Jack::Expression
        child :statements, [Jack::Statement]
    end

    class SubCall < RLTK::ASTNode
        value :prefix, Symbol
        value :name, Symbol
        child :exprlist, [Jack::Expression]
    end

    class DoStatement < Statement
        child :subcall, Jack::SubCall
    end

    class ReturnStatement < Statement
        child :expr, Jack::Expression
    end

    class UnaryOp < RLTK::ASTNode
        value :op, Symbol
        value :term, Symbol
    end


end

