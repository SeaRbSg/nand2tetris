#lang racket/base

(require racket/pretty)
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
   (debug "grammar.debug.txt")
   (tokens jack-tokens jack-keywords jack-empty-tokens)
   (error (lambda (tok-ok? tok-name tok-value)
            (printf "error: ~s ~s ~s\n" tok-ok? tok-name tok-value)))

   (grammar

    (start [() #f]
           [(error start) $2] ; skip over errors
           [(classE) $1]
           #;[(exp start) (if $2 (cons $1 $2) (list $1))]
           )

    ;;; Program Structure:

    (classE [(CLASS className LBRACE classVarDec* subroutineDec* RBRACE)
             (list 'class
                   (list 'keyword "class")
                   $2
                   (list 'symbol "{")
                   $5
                   (list 'symbol "}"))])

    (classVarDec [(cvarScope type varNames SEMI) (list 'classVarDec $1 $2 $3)])

    (type [(INT) "int"] [(CHAR) "char"] [(BOOLEAN) "boolean"] [(className) $1])

    (subroutineDec [(subroutineScope returnType subroutineName
                                     LPAREN optParameterList RPAREN
                                     subroutineBody)
                    (list 'subroutineDec
                          $1
                          $2
                          $3
                          'lparen
                          $5
                          'rparen
                          $7)])

    (parameterList [(parameter COMMA parameterList) (cons $1 $3)]
                   [(parameter) (list $1)])

    (subroutineBody [(LBRACE varDec* statement* RBRACE)
                     (list 'lbrace
                           $2
                           $3
                           'rbrace)])

    (varDec [(VAR type varNames SEMI) (list 'varDec $2 $3)])

    (className [(ID) (list 'identifier $1)])

    (subroutineName [(ID) $1])

    (varName [(ID) $1])

    ;;; Statements:

    (statement [(letStatement)    $1]
               [(ifStatement)     $1]
               [(whileStatement)  $1]
               [(doStatement)     $1]
               [(returnStatement) $1])

    (letStatement [(LET varName EQ expression SEMI)
                   (list 'letStatement $2 $4)]
                  [(LET varName LBRACK expression RBRACK EQ expression SEMI)
                   (list 'letStatement $2 $4 $7)])

    (ifStatement [(IF LPAREN expression RPAREN LBRACE statement* RBRACE)
                  (list 'ifStatement $3 $6)]
                 [(IF LPAREN expression RPAREN LBRACE statement* RBRACE ELSE LBRACE statement* RBRACE)
                  (list 'ifStatement $3 $6 $10)])

    (whileStatement [(WHILE LPAREN expression RPAREN LBRACE statement* RBRACE)
                     (list 'whileStatement $3 $6)])

    (doStatement [(DO subroutineCall SEMI) (list 'doStatement $2)])

    (returnStatement [(RETURN expression? SEMI) (list 'returnStatement $2)])

    ;;; Expressions:

    (expression [(term*) $1])

    (term [(NUM) $1]
          [(STR) $1]
          [(keywordConstant) $1]
          [(varName) $1]
          [(varName LBRACK expression RBRACK) (list $1 $3)]
          [(subroutineCall) $1]
          [(LPAREN expression RPAREN) $2]
          [(unaryOp term) (list $1 $2)])

    (subroutineCall [(subroutineName LPAREN expression* RPAREN) (cons $1 $3)]
                    [(classOrVar DOT subroutineName LPAREN expression* RPAREN) (list $1 $3 $5)])

    (op [(PLUS) '+] [(MINUS) '-] [(TIMES) '*] [(DIVIDE) '/] [(AND) '&] [(OR) '\|] [(LT) '<] [(GT) '>] [(EQ) '=])

    (unaryOp [(MINUS) '-] [(NOT) '~])

    ;;; Lists: (because LALR grammars suck)

    (expression? [(expression) $1]
                 [() '()])

    (expression* [(expression+) $1]
                 [() '()])

    (expression+ [(expression COMMA expression+) (cons $1 $3)]
                 [(expression) (list $1)])

    (term* [(term+) $1]
           [() '()])

    (term+ [(term op term*) (list $1 $2 $3)]
           [(term) (list $1)])

    (classVarDec* [(classVarDec classVarDec*) (cons $1 $2)]
                  [() '()])

    (optParameterList [(parameterList) $1]
                      [() '()])

    (statement* [(statement statement*) (cons $1 $2)]
                [() '()])

    (subroutineDec* [(subroutineDec subroutineDec*) (cons $1 $2)]
                    [() '()])

    (varDec* [(varDec varDec*) (cons $1 $2)]
             [() '()])

    (varNames [(varName COMMA varNames) (cons $1 $3)]
              [(varName) (list $1)])

    ;;; Support:

    (classOrVar [(className) $1]
                [(varName) $1])

    (cvarScope [(FIELD) "field"]
               [(STATIC) "static"])

    (parameter [(type varName) (list 'parameter $1 $2)])

    (returnType [(VOID) "void"]
                [(type) $1])

    (subroutineScope [(CONSTRUCTOR) "constructor"]
                     [(FUNCTION)    "function"]
                     [(METHOD)      "method"])

    (keywordConstant [(CLASS) "class"] [(CONSTRUCTOR) "constructor"] [(FUNCTION) "function"] [(METHOD) "method"] [(FIELD) "field"] [(STATIC) "static"] [(VAR) "var"] [(INT) "int"] [(CHAR) "char"] [(BOOLEAN) "boolean"] [(VOID) "void"] [(TRUE) "true"] [(FALSE) "false"] [(NULL) "null"] [(THIS) "this"] [(LET) "let"] [(DO) "do"] [(IF) "if"] [(ELSE) "else"] [(WHILE) "while"] [(RETURN) "return"]))))

(define (jack ip)
  (port-count-lines! ip)
  (jack-parser (lambda () (jack-lexer ip))))

(module+ main
  (for ([path (current-command-line-arguments)])
    (define xexpr (jack (open-input-file path)))
    (display-xml/content (xexpr->xml xexpr))
    ;; (pretty-print xexpr)
    )
  (newline))
