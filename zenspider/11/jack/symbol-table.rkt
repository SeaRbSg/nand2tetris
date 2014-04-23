#lang racket/base

(provide (struct-out var)
         env-new env-get env-set env-add env-length env-bump
         is-this?)

(struct var (type scope idx) #:transparent)

(define (env-new)
  (hash 'argument 0
        'field    0
        'local    0
        'static   0
        'this     0
        ))

(define (env-set env key val)
  (hash-set env key val))

(define (env-idx env scope)
  (hash-ref env scope))

(define (env-bump env scope)
  (env-set env scope (add1 (env-idx env scope))))

(define (env-add env key type scope)
  (define idx (env-idx env scope))
  (env-set (env-bump env scope) key (var type scope idx)))

(define (env-get env key)
  (hash-ref env key #f))

(define env-length hash-count)

(define (is-this? x)
  (and (var? x)
       (equal? 'this (var-scope x))))
