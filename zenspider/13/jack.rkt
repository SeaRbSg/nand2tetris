#!/usr/bin/env racket
#lang racket/base

(require (rename-in (prefix-in jack/ "jack/parser.rkt")
                    (jack/parse jack/parser)))
(require "jack/lexer.rkt")
(require "jack/compiler.rkt")
(require racket/cmdline)

(module+ main
  (define (jack ip)
    (port-count-lines! ip)
    (jack/parser (lambda () (jack/lexer ip))))

  (let ([paths (command-line #:args paths paths)])
    (for ([path paths])
      (define xexpr (jack (open-input-file path)))
      (jack/compile xexpr))))
