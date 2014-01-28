#lang racket/base

(require (only-in racket first rest second third))
(require (only-in racket/match match))

(module+ test
  (require rackunit))

(define (sexp->hdl xs)
  (define rs '())
  (define (next-id rs)
    (string->symbol (format "w~s" (length rs))))
  (define (helper xs)
    (cond [(null? xs) '()]
          [(not (list? xs)) xs]
          [else (let ([args (map helper xs)]
                      [n (next-id rs)])
                  (set! rs (cons `(,@args ,n) rs))
                  n)]))
  (helper xs)
  (reverse rs))

(module+ test
  (check-equal? (sexp->hdl '(not a))
                '((not a w0)))

  (check-equal? (sexp->hdl '(and a b))
                '((and a b w0)))

  (check-equal? (sexp->hdl '(or a b))
                '((or a b w0)))

  (check-equal? (sexp->hdl '(or [and (not a) b]
                                [and a (not b)]))
                '((not a    w0)
                  (and w0 b w1)
                  (not b    w2)
                  (and a w2 w3)
                  (or w1 w3 w4))))

(define (sexp->nand xs)
  (define rs '())
  (define wire 0)
  (define (next-id)
    (let ([r (string->symbol (format "w~s" wire))])
      (set! wire (add1 wire))
      r))
  (define (sub-id sym n)
    (string->symbol (format "~ss~s" sym n)))
  (define (helper xs)
    (cond [(null? xs) '()]
          [(not (list? xs)) xs]
          [else (case (first xs)
                  [(not)
                   (let* ([a (helper (second xs))]
                          [n (next-id)]
                          [r `(nand ,a ,a ,n)])
                     (set! rs (cons r rs))
                     n)]
                  [(or)
                   (let* ([a (helper (second xs))]
                          [b (helper (third xs))]
                          [n (next-id)]
                          [n1 (sub-id n 1)]
                          [n2 (sub-id n 2)]
                          [r `((nand ,a ,a ,n1)
                               (nand ,b ,b ,n2)
                               (nand ,n1 ,n2 ,n))])
                     (set! rs (append (reverse r) rs))
                     n)]
                  [(and)
                   (let* ([a (helper (second xs))]
                          [b (helper (third xs))]
                          [n (next-id)]
                          [n1 (sub-id n 1)]
                          [r `((nand ,a ,b ,n1)
                               (nand ,n1 ,n1 ,n))])
                     (set! rs (append (reverse r) rs))
                     n)]
                  [else (set! rs (cons (list 'error xs) rs))])]))
  (helper xs)
  (reverse rs))

(module+ test
  (check-equal? (sexp->nand '(not a))
                '((nand a a w0)))

  (check-equal? (sexp->nand '(or a b))
                '((nand a a w0s1)
                  (nand b b w0s2)
                  (nand w0s1 w0s2 w0)))

  (check-equal? (sexp->nand '(and a b))
                '((nand a b w0s1)
                  (nand w0s1 w0s1 w0)))

  (check-equal? (sexp->nand '(or [and (not a) b]
                                 [and a (not b)]))
                '((nand a a w0)          ; not a
                  (nand w0 b w1s1)       ; nand w0 b
                  (nand w1s1 w1s1 w1)    ; not
                  (nand b b w2)          ; not b
                  (nand a w2 w3s1)       ; nand a w1
                  (nand w3s1 w3s1 w3)    ; not
                  (nand w1 w1 w4s1)      ; not
                  (nand w3 w3 w4s2)      ; not
                  (nand w4s1 w4s2 w4)))) ; or w0 w1

(define (sexp-optimize xs)
  (match xs
    [`() '()]
    ;; (not (not a)) -> a

    ;; todo: table of substitutions, then register wiring in
    ;; (not (not a)) and substitute in subsequent sexps

    [(list-rest `(nand ,a ,a ,b) ; (not (not a)) -> a
                `(nand ,b ,b ,c)
                `(nand ,d ,c ,e)
                rest)
     (sexp-optimize (cons `(nand ,d ,a ,e) rest))]
    ;; HACK: this is the dumbest way, but I'm tired
    [(list-rest `(nand ,a ,a ,b)
                `(nand ,b ,b ,c)
                `(nand ,c ,d ,e)
                rest)
     (sexp-optimize (cons `(nand ,a ,d ,e) rest))]
    [else (cons (first xs)
                (sexp-optimize (rest xs)))]))

(module+ test
  (check-equal? (sexp-optimize '((nand a a w0)
                                 (nand w0 w0 w1)
                                 (nand b w1 w2)))
                '((nand b a w2)))

  (check-equal? (sexp-optimize '((nand a a w0)
                                 (nand w0 w0 w1)
                                 (nand w1 b w2)))
                '((nand a b w2)))

  (check-equal? (sexp-optimize '((woot)
                                 (nand a a w0)
                                 (nand w0 w0 w1)
                                 (nand w1 b w2)))
                '((woot) (nand a b w2)))
  (check-equal? (sexp-optimize '((nand a a w0)
                                 (nand w0 w0 w1)
                                 (nand w1 b w2)
                                 (woot)))
                '((nand a b w2) (woot))))

(module+ main
  (sexp->hdl '(or [and (not a) b]
                  [and a (not b)]))

  (sexp->nand '(or [and (not a) b]
                   [and a (not b)])))
