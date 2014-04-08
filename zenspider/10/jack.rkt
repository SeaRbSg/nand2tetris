#lang racket/base

(require parser-tools/yacc
         parser-tools/lex
         (prefix-in : parser-tools/lex-sre))
(require xml)

(define-tokens jack-tokens (SYM NUM STR ID))
(define-empty-tokens jack-keywords (CLASS CONSTRUCTOR FUNCTION METHOD FIELD STATIC VAR INT CHAR BOOLEAN VOID TRUE FALSE NULL THIS LET DO IF ELSE WHILE RETURN))
(define-empty-tokens jack-empty-tokens (EOF LBRACE RBRACE LPAREN RPAREN LBRACK RBRACK DOT COMMA SEMI PLUS MINUS TIMES DIVIDE AND OR LT GT EQ NOT))

(define jack-lexer
  (lexer
   [(eof) (token-EOF)]
   [(:or #\tab #\space #\newline) ; skip by recursing to get next token
    (jack-lexer input-port)]
   [(:: "//" (:* (:~ #\newline)))
    (jack-lexer input-port)]
   [(:: "/*" (complement (:: any-string "*/" any-string)) "*/") ; ditto
    (jack-lexer input-port)]

   ["class"       'CLASS]
   ["constructor" 'CONSTRUCTOR]
   ["function"    'FUNCTION]
   ["method"      'METHOD]
   ["field"       'FIELD]
   ["static"      'STATIC]
   ["var"         'VAR]
   ["int"         'INT]
   ["char"        'CHAR]
   ["boolean"     'BOOLEAN]
   ["void"        'VOID]
   ["true"        'TRUE]
   ["false"       'FALSE]
   ["null"        'NULL]
   ["this"        'THIS]
   ["let"         'LET]
   ["do"          'DO]
   ["if"          'IF]
   ["else"        'ELSE]
   ["while"       'WHILE]
   ["return"      'RETURN]

   ["{" 'LBRACE]
   ["}" 'RBRACE]
   ["(" 'LPAREN]
   [")" 'RPAREN]
   ["[" 'LBRACK]
   ["]" 'RBRACK]
   ["." 'DOT]
   ["," 'COMMA]
   [";" 'SEMI]
   ["+" 'PLUS]
   ["-" 'MINUS]
   ["*" 'TIMES]
   ["/" 'DIVIDE]
   ["&" 'AND]
   ["|" 'OR]
   ["<" 'LT]
   [">" 'GT]
   ["=" 'EQ]
   ["~" 'NOT]

   [(:+ numeric)
    ; TODO: verify size of int? or let parser do it?
    (token-NUM lexeme)]
   [(:: alphabetic (:* (:or alphabetic numeric)))
    (token-ID lexeme)]
   [(:: #\" (:* (:~ #\" #\newline)) #\" )
    (token-STR lexeme)]))

(define jack-parser
  (parser
   (start start)
   (end EOF)
   (tokens jack-tokens jack-keywords jack-empty-tokens)
   (error (lambda (tok-ok? tok-name tok-value)
            (printf "error: ~s ~s ~s\n" tok-ok? tok-name tok-value)))

   (grammar

    (start [() #f]
           [(error start) $2] ; skip over errors
           [(classE) $1])

    ;;; Program Structure:

    (classE [(CLASS className LBRACE classVarDec* subroutineDec* RBRACE)
             `(class ,(k "class") ,$2 ,(s "{") ,@$4 ,@$5 ,(s "}"))])

    (classVarDec [(cvarScope type varNames SEMI)
                  `(classVarDec ,$1 ,$2 ,@$3 ,(s ";"))])

    (type [(INT) (k "int")] [(CHAR) (k "char")]
          [(BOOLEAN) (k "boolean")] [(className) $1])

    (subroutineDec [(subroutineScope returnType subroutineName
                                     LPAREN parameter* RPAREN
                                     subroutineBody)
                    `(subroutineDec ,(k $1) ,$2 ,$3
                      ,(s "(") (parameterList ,@$5) ,(s ")")
                      ,$7)])

    (subroutineBody [(LBRACE varDec* statement* RBRACE)
                     `(subroutineBody ,(s "{") ,@$2 (statements ,@$3) ,(s "}"))])

    (varDec [(VAR type varNames SEMI)
             `(varDec ,(k "var") ,$2 ,@$3 ,(s ";"))])

    (className [(ID) `(identifier ,$1)])

    (subroutineName [(ID) `(identifier ,$1)])

    (varName [(ID) `(identifier ,$1)])

    ;;; Statements:

    (statement [(letStatement)    $1]
               [(ifStatement)     $1]
               [(whileStatement)  $1]
               [(doStatement)     $1]
               [(returnStatement) $1])

    (letStatement [(LET varName EQ expression SEMI)
                   `(letStatement ,(k "let") ,$2
                     ,(s "=") ,$4 ,(s ";"))]
                  [(LET varName LBRACK expression RBRACK EQ expression SEMI)
                   `(letStatement ,(k "let") ,$2 ,(s "[") ,$4 ,(s "]")
                     ,(s "=") ,$7 ,(s ";"))])

    (ifStatement [(IF LPAREN expression RPAREN LBRACE statement* RBRACE)
                  `(ifStatement
                    ,(k "if") ,(s "(") ,$3 ,(s ")")
                    ,(s "{") (statements ,@$6) ,(s "}"))]
                 [(IF LPAREN expression RPAREN LBRACE statement* RBRACE
                      ELSE LBRACE statement* RBRACE)
                  `(ifStatement
                    ,(k "if") ,(s "(") ,$3 ,(s ")")
                    ,(s "{")
                    (statements ,@$6)
                    ,(s "}") ,(k "else") ,(s "{")
                    (statements ,@$10)
                    ,(s "}"))])

    (whileStatement [(WHILE LPAREN expression RPAREN LBRACE statement* RBRACE)
                     `(whileStatement
                       ,(k "while")
                       ,(s "(")
                       ,$3
                       ,(s ")")
                       ,(s "{")
                       (statements ,@$6)
                       ,(s "}"))])

    (doStatement [(DO subroutineCall SEMI)
                  `(doStatement ,(k "do") ,@$2 ,(s ";"))])

    (returnStatement [(RETURN expression SEMI)
                      `(returnStatement ,(k "return") ,$2 ,(s ";"))]
                     [(RETURN SEMI)
                      `(returnStatement ,(k "return") ,(s ";"))])

    ;;; Expressions:

    (expression [(term*) `(expression ,@$1)])

    (term [(NUM) `(term (integerConstant ,$1))]
          [(STR) `(term (stringConstant ,$1))]
          [(keywordConstant) `(term (keyword ,$1))]
          [(varName) `(term ,$1)]
          [(varName LBRACK expression RBRACK)
           `(term ,$1 ,(s "[") ,$3 ,(s "]"))]
          [(subroutineCall) `(term ,@$1)]
          [(LPAREN expression RPAREN) `(term ,(s "(") ,$2 ,(s ")"))]
          [(unaryOp term) `(term ,(s $1) ,$2)])

    (subroutineCall [(               subroutineName LPAREN expression* RPAREN)
                     `(,$1 ,(s "(") (expressionList ,@$3) ,(s ")"))]
                    [(classOrVar DOT subroutineName LPAREN expression* RPAREN)
                     `(,$1 ,(s ".") ,$3 ,(s "(") (expressionList ,@$5) ,(s ")"))])

    (op [(PLUS) "+"] [(MINUS) "-"] [(TIMES) "*"] [(DIVIDE) "/"]
        [(AND) "&"] [(OR) "|"] [(LT) "<"] [(GT) ">"] [(EQ) "="])

    (unaryOp [(MINUS) "-"] [(NOT) "~"])

    ;;; Lists: (because LALR grammars suck)

    (classVarDec* [(classVarDec classVarDec*) (cons $1 $2)]
                  [() '()])

    (expression* [(expression+) $1]
                 [() '()])

    (expression+ [(expression COMMA expression+) `(,$1 ,(s ",") ,@$3)]
                 [(expression) (list $1)])

    (expression? [(expression) $1]
                 [() '()])

    (parameter* [(parameter+) $1]
                [() '()])

    (parameter+ [(type varName COMMA parameter*) `(,$1 ,$2 ,(s ",") ,@$4)]
                [(type varName) `(,$1 ,$2)])

    (statement* [(statement statement*) (cons $1 $2)]
                [() '()])

    (subroutineDec* [(subroutineDec subroutineDec*) (cons $1 $2)]
                    [() '()])

    (term* [(term+) $1]
           [() '()])

    (term+ [(term op term*) `(,$1 ,(s $2) ,@$3)]
           [(term) (list $1)])

    (varDec* [(varDec varDec*) (cons $1 $2)]
             [() '()])

    (varNames [(varName COMMA varNames) `(,$1 ,(s ",") ,@$3)]
              [(varName) (list $1)])

    ;;; Support:

    (classOrVar [(className) $1]
                [(varName) $1])

    (cvarScope [(FIELD) (k "field")]
               [(STATIC) (k "static")])

    (keywordConstant [(CLASS) "class"] [(CONSTRUCTOR) "constructor"]
                     [(FUNCTION) "function"] [(METHOD) "method"]
                     [(FIELD) "field"] [(STATIC) "static"] [(VAR) "var"]
                     [(INT) "int"] [(CHAR) "char"] [(BOOLEAN) "boolean"]
                     [(VOID) "void"] [(TRUE) "true"] [(FALSE) "false"]
                     [(NULL) "null"] [(THIS) "this"] [(LET) "let"] [(DO) "do"]
                     [(IF) "if"] [(ELSE) "else"] [(WHILE) "while"]
                     [(RETURN) "return"])

    (returnType [(VOID) (k "void")]
                [(type) $1])

    (subroutineScope [(CONSTRUCTOR) "constructor"]
                     [(FUNCTION)    "function"]
                     [(METHOD)      "method"]))))

(define (s x) `(symbol ,x))
(define (k x) `(keyword ,x))

(define (jack ip)
  (port-count-lines! ip)
  (jack-parser (lambda () (jack-lexer ip))))

(module+ main
  (for ([path (current-command-line-arguments)])
    (define xexpr (jack (open-input-file path)))
    (display-xml/content (xexpr->xml xexpr)))
  (newline))
