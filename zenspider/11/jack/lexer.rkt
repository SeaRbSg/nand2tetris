#lang racket/base

(provide jack/lexer)

(require ragg/support)                  ; token
(require parser-tools/lex)              ; lexer-src-pos
(require (prefix-in : parser-tools/lex-sre)) ; regexps stuffs

(define jack/lexer
  (lexer-src-pos
   [(eof) (void)]
   [(:or #\tab #\space #\newline) ; skip by recursing to get next token
    (jack/lexer input-port)]
   [(:: "//" (:* (:~ #\newline)))
    (jack/lexer input-port)]
   [(:: "/*" (complement (:: any-string "*/" any-string)) "*/") ; ditto
    (jack/lexer input-port)]

   ["class"       (token lexeme lexeme)]
   ["constructor" (token lexeme lexeme)]
   ["function"    (token lexeme lexeme)]
   ["method"      (token lexeme lexeme)]
   ["field"       (token lexeme lexeme)]
   ["static"      (token lexeme lexeme)]
   ["var"         (token lexeme lexeme)]
   ["int"         (token lexeme lexeme)]
   ["char"        (token lexeme lexeme)]
   ["boolean"     (token lexeme lexeme)]
   ["void"        (token lexeme lexeme)]
   ["true"        (token lexeme lexeme)]
   ["false"       (token lexeme lexeme)]
   ["null"        (token lexeme lexeme)]
   ["this"        (token lexeme lexeme)]
   ["let"         (token lexeme lexeme)]
   ["do"          (token lexeme lexeme)]
   ["if"          (token lexeme lexeme)]
   ["else"        (token lexeme lexeme)]
   ["while"       (token lexeme lexeme)]
   ["return"      (token lexeme lexeme)]

   ["{" (token lexeme lexeme)]
   ["}" (token lexeme lexeme)]
   ["(" (token lexeme lexeme)]
   [")" (token lexeme lexeme)]
   ["[" (token lexeme lexeme)]
   ["]" (token lexeme lexeme)]
   ["." (token lexeme lexeme)]
   ["," (token lexeme lexeme)]
   [";" (token lexeme lexeme)]
   ["+" (token lexeme lexeme)]
   ["-" (token lexeme lexeme)]
   ["*" (token lexeme lexeme)]
   ["/" (token lexeme lexeme)]
   ["&" (token lexeme lexeme)]
   ["|" (token lexeme lexeme)]
   ["<" (token lexeme lexeme)]
   [">" (token lexeme lexeme)]
   ["=" (token lexeme lexeme)]
   ["~" (token lexeme lexeme)]

   [(:+ numeric)
    ; TODO: verify size of int? or let parser do it?
    (token 'NUM (string->number lexeme))]
   [(:: (:or "_" alphabetic) (:* (:or "_" alphabetic numeric)))
    (token 'ID lexeme)]
   [(:: #\" (:* (:~ #\" #\newline)) #\" )
    (token 'STR lexeme)]))
