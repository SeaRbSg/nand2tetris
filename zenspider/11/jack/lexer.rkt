#lang racket/base

(provide jack/lexer)

(require ragg/support)                  ; token
(require parser-tools/lex)              ; lexer-src-pos
(require (prefix-in : parser-tools/lex-sre)) ; regexps stuffs

 #;parser-tools/yacc

(define jack/lexer
  (lexer-src-pos
   [(eof) (void)]
   [(:or #\tab #\space #\newline) ; skip by recursing to get next token
    (jack/lexer input-port)]
   [(:: "//" (:* (:~ #\newline)))
    (jack/lexer input-port)]
   [(:: "/*" (complement (:: any-string "*/" any-string)) "*/") ; ditto
    (jack/lexer input-port)]

   ["class"       (token lexeme)]
   ["constructor" (token lexeme)]
   ["function"    (token lexeme)]
   ["method"      (token lexeme)]
   ["field"       (token lexeme)]
   ["static"      (token lexeme)]
   ["var"         (token lexeme)]
   ["int"         (token lexeme)]
   ["char"        (token lexeme)]
   ["boolean"     (token lexeme)]
   ["void"        (token lexeme)]
   ["true"        (token lexeme)]
   ["false"       (token lexeme)]
   ["null"        (token lexeme)]
   ["this"        (token lexeme)]
   ["let"         (token lexeme)]
   ["do"          (token lexeme)]
   ["if"          (token lexeme)]
   ["else"        (token lexeme)]
   ["while"       (token lexeme)]
   ["return"      (token lexeme)]

   ["{" (token lexeme)]
   ["}" (token lexeme)]
   ["(" (token lexeme)]
   [")" (token lexeme)]
   ["[" (token lexeme)]
   ["]" (token lexeme)]
   ["." (token lexeme)]
   ["," (token lexeme)]
   [";" (token lexeme)]
   ["+" (token lexeme)]
   ["-" (token lexeme)]
   ["*" (token lexeme)]
   ["/" (token lexeme)]
   ["&" (token lexeme)]
   ["|" (token lexeme)]
   ["<" (token lexeme)]
   [">" (token lexeme)]
   ["=" (token lexeme)]
   ["~" (token lexeme)]

   [(:+ numeric)
    ; TODO: verify size of int? or let parser do it?
    (token 'NUM lexeme)]
   [(:: alphabetic (:* (:or alphabetic numeric)))
    (token 'ID lexeme)]
   [(:: #\" (:* (:~ #\" #\newline)) #\" )
    (token 'STR lexeme)]))
