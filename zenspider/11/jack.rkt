#lang racket/base

(require racket/pretty)
(require ragg/support)
(require (rename-in (prefix-in jack/ "jack/parser.rkt")
                    (jack/parse jack/parser)))
(require "jack/lexer.rkt")

(module+ main
  (define (jack ip)
    (port-count-lines! ip)
    (jack/parser (lambda () (jack/lexer ip))))

  (for ([path (current-command-line-arguments)])
    (define xexpr (jack (open-input-file path)))
    (pretty-print (syntax->datum xexpr))
    (newline)))
