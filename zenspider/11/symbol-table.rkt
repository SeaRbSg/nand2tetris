#lang racket/base

(provide (struct-out var)
         env-new env-get env-set env-add env-length)

(struct var (type scope idx) #:transparent)

(define (env-new)
  (hash "argument" 0
        "field"    0
        "local"    0
        "static"   0))

(define (env-set env key val)
  (hash-set env key val))

(define (env-idx env scope)
  (hash-ref env scope))

(define (env-add env key type scope)
  (define idx (env-idx env scope))
  (env-set (env-set env scope (add1 idx)) key (var type scope idx)))

(define (env-get env key)
  (hash-ref env key))

(define env-length hash-count)
