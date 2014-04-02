#lang racket/base

(require parser-tools/yacc
         parser-tools/lex
         (prefix-in : parser-tools/lex-sre))
(require xml)

(define-tokens jack-tokens (KEY SYM INT STR ID))
(define-empty-tokens jack-empty-tokens (EOF))

(define jack-lexer
  (lexer
   [(eof) (token-EOF)]
   [(:or #\tab #\space #\newline) ; skip by recursing to get next token
    (jack-lexer input-port)]
   [(:: "//" (:* (:~ #\newline)))
    (jack-lexer input-port)]
   [(:: "/*" (complement (:: any-string "*/" any-string)) "*/") ; ditto
    (jack-lexer input-port)]
   [(:or "class" "constructor" "function" "method" "field" "static" "var" "int"
         "char" "boolean" "void" "true" "false" "null" "this" "let" "do" "if"
         "else" "while" "return")
    (token-KEY lexeme)]
   [(:or "{" "}" "(" ")" "[" "]" "." "," ";" "+" "-" "*" "/" "&" "|" "<" ">" "=" "~")
    (token-SYM lexeme)]
   [(:+ numeric)
    ; TODO: verify size of int? or let parser do it?
    (token-INT lexeme)]
   [(:: alphabetic (:* (:or alphabetic numeric)))
    (token-ID lexeme)]
   [(:: #\" (:* (:~ #\" #\newline)) #\" )
    (token-STR lexeme)]))

(define jack-parser
  (parser
   (start start)
   (end EOF)
   (tokens jack-tokens jack-empty-tokens)
   (error (lambda (a b c) (void)))
   
   (grammar

    (start [() #f]
           [(error start) $2] ; skip over errors
           [(exp start) (if $2 (cons $1 $2) (list $1))])
    
    (exp [(KEY) (list 'keyword $1)]
         [(SYM) (list 'symbol $1)]
         [(INT) (list 'integerConstant $1)]
         [(ID)  (list 'identifier $1)]
         [(STR) (list 'stringConstant $1)]))))

(define (jack ip)
  (port-count-lines! ip)
  (cons 'tokens
        (jack-parser (lambda () (jack-lexer ip)))))

(module+ main
  (for ([path (current-command-line-arguments)])
    (define xexpr (jack (open-input-file path)))
    (display-xml/content (xexpr->xml xexpr)))
  (newline))
