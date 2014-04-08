#lang racket/base

(provide jack-lexer jack-tokens jack-keywords jack-empty-tokens)

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
           [(exp start) (if $2 (cons $1 $2) (list $1))])

    (exp [(keywordConstant) (list 'keyword $1)]
         [(symbol) (list 'symbol $1)]
         [(NUM) (list 'integerConstant $1)]
         [(ID)  (list 'identifier $1)]
         [(STR) (list 'stringConstant $1)])

    (symbol [(LBRACE) "{"] [(RBRACE) "}"] [(LPAREN) "("] [(RPAREN) ")"] [(LBRACK) "["]
            [(RBRACK) "]"] [(DOT) "."] [(COMMA) ","] [(SEMI) ";"] [(PLUS) "+"]
            [(MINUS) "-"] [(TIMES) "*"] [(DIVIDE) "/"] [(AND) "&"] [(OR) "|"]
            [(LT) "<"] [(GT) ">"] [(EQ) "="] [(NOT) "~"])

    (keywordConstant [(CLASS) "class"] [(CONSTRUCTOR) "constructor"]
                     [(FUNCTION) "function"] [(METHOD) "method"]
                     [(FIELD) "field"] [(STATIC) "static"] [(VAR) "var"]
                     [(INT) "int"] [(CHAR) "char"] [(BOOLEAN) "boolean"]
                     [(VOID) "void"] [(TRUE) "true"] [(FALSE) "false"]
                     [(NULL) "null"] [(THIS) "this"] [(LET) "let"] [(DO) "do"]
                     [(IF) "if"] [(ELSE) "else"] [(WHILE) "while"]
                     [(RETURN) "return"]))))

(define (jack ip)
  (port-count-lines! ip)
  (cons 'tokens
        (jack-parser (lambda () (jack-lexer ip)))))

(module+ main
  (for ([path (current-command-line-arguments)])
    (define xexpr (jack (open-input-file path)))
    (display-xml/content (xexpr->xml xexpr)))
  (newline))
