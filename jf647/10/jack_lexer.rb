require 'rltk'

module Jack

    class Lexer < RLTK::Lexer

        # ignore whitespace
        rule(/\s/) 

        # line comments
        rule(/\/\/.*/)              { push_state(:linecomment) }
        rule(/./, :linecomment)
        rule(/\n/, :linecomment)    { pop_state }
        # block comments
        rule(/\/\*/)                { push_state(:blockcomment) }
        rule(/./, :blockcomment)
        rule(/\n/, :blockcomment)
        rule(/\*\//, :blockcomment) { pop_state }
        # api comments
        rule(/\/\*\*/)              { push_state(:apicomment) }
        rule(/./, :apicomment)
        rule(/\n/, :apicomment)
        rule(/\*\//, :apicomment)   { pop_state }
        
        # keywords
        rule('class')           { :CLASS }
        rule('constructor')     { :CONSTRUCTOR }
        rule('function')        { :FUNCTION }
        rule('method')          { :METHOD }
        rule('field')           { :FIELD }
        rule('static')          { :STATIC }
        rule('var')             { :VAR }
        rule('int')             { :INT }
        rule('char')            { :CHAR }
        rule('boolean')         { :BOOLEAN }
        rule('void')            { :VOID }
        rule('true')            { :TRUE }
        rule('false')           { :FALSE }
        rule('null')            { :NULL }
        rule('this')            { :THIS }
        rule('let')             { :LET }
        rule('do')              { :DO }
        rule('if')              { :IF }
        rule('else')            { :ELSE }
        rule('while')           { :WHILE }
        rule('return')          { :RETURN }
        
        # symbols
        rule('{')               { :LBRACE }
        rule('}')               { :RBRACE }
        rule('\(')              { :LPAREN }
        rule('\)')              { :RPAREN }
        rule('\[')              { :LBRACKET }
        rule('\]')              { :RBRACKET }
        rule('\.')              { :DOT }
        rule(',')               { :COMMA }
        rule(';')               { :SEMICOLON }
        rule('\+')              { :PLUS }
        rule('-')               { :MINUS }
        rule('\*')              { :MULT }
        rule('\/')              { :DIV }
        rule('&')               { :AND }
        rule('|')               { :OR }
        rule('<')               { :LT }
        rule('>')               { :GT }
        rule('=')               { :EQUALS }
        rule('~')               { :NEG }
        
        # integers
        rule(/[0-9]+/)          { |t| [ :INTEGER, t.to_i ] }
        
        # strings
        rule(/"[^"]+"/)         { |t| [ :STRING, t.match(/"([^"]+)"/)[1] ]
        }
        
        # identifier
        rule(/[a-zA-Z_][\w_]*/) { |t| [ :IDENT, t.to_sym ] }
        
    end

end
