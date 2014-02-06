#!/usr/bin/env racket

#lang racket

(module+ test
  (require rackunit))

(define (sexp->hdl xs)
  (define rs '())
  (define (hdl-fn fmt x)
    (let* ([f (string-titlecase (symbol->string (first x)))]
           [args (cons f (rest x))]
           [r (apply format fmt args)])
      (set! rs (cons r rs))))
  (define (helper xs)
    (cond [(null? xs) '()]
          [(not (list? xs)) xs]
          [else (let ([x (first xs)])
                  (case (first x)
                    [(//)
                     (hdl-fn "~n~a ~a" x)]
                    [(and or xor nand)
                     (hdl-fn "~a(a=~a, b=~a, out=~a);" x)]
                    [(and3 or3)
                     (hdl-fn "~a(a=~a, b=~a, c=~a, out=~a);" x)]
                    [(and4 or4)
                     (hdl-fn "~a(a=~a, b=~a, c=~a, d=~a, out=~a);" x)]
                    [else (set! rs (cons (list 'error x) rs))])
                  (helper (rest xs)))]))
  (helper xs)
  (string-join (reverse rs) "\n"))


(define (wire prefix)
  (let ((n -1))
    (lambda ()
      (set! n (add1 n))
      (string->symbol (format "~s~s" prefix n)))))

(define (wires proc n)                ; TODO: there has to be a cleaner form
  (apply values (for/list ([i (in-range n)])
                  (proc))))

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

(define (filter-not-not xs)
  (define (rewrite xxs a b)
    (for/list ([xs xxs])
      (for/list ([x xs])
        (if (eq? x a) b x))))
  (define (possibly-include gate xs)
    (let ((out (last gate)))
      (if (for/or ([x xs]) (memq out x))
          (cons gate xs)
          xs))
    )
  (match xs
    [(list-no-order `(nand ,a1 ,a2 ,c1)
                    `(nand ,b1 ,b2 ,c2) rest ...)
     #:when (and (eq? a1 a2)
                 (eq? b1 b2)
                 (eq? c1 b1))
     (filter-not-not (possibly-include
                      `(nand ,a1 ,a2 ,c1)
                      (rewrite rest c2 a1)))]
    [else xs]))

(module+ test
  (require rackunit)
  (define x '((nand a a w0)          ; not a
              (nand w0 b w1s1)       ; nand w0 b
              (nand w1s1 w1s1 w1)    ; not
              (nand b b w2)          ; not b
              (nand a w2 w3s1)       ; nand a w1
              (nand w3s1 w3s1 w3)    ; not
              (nand w1 w1 w4s1)      ; not
              (nand w3 w3 w4s2)      ; not
              (nand w4s1 w4s2 w4)))

  (check-equal? (filter-not-not x)
                '((nand a a w0)              ; not a
                  (nand w0 b w1s1)           ; nand w0 b
                  (nand b b w2)              ; not b
                  (nand a w2 w3s1)           ; nand a w1
                  (nand w1s1 w3s1 w4)))

  (check-equal? (filter-not-not '((nand a  a  w0)
                                  (nand w0 w0 b)
                                  (nand b  c  d)
                                  (nand w0 e  f)))
                '((nand a  a  w0)
                  (nand a  c  d)
                  (nand w0 e  f)))
)

(define (sexp-optimize xs)
  (filter-not-not xs))

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
  (define p (wire 'p))
  (define g (wire 'g))
  (define w (wire 'w))
  (define c (wire 'c))
  (define x (wire 'x))
  (define comment-add4 (wire 'add4-))
  (define comment-cla (wire 'cla))
  (define comment-pfa (wire 'pfa))
  (define comment-and (wire 'and))
  (define comment-or (wire 'or))
  (define comment-xor (wire 'xor))

  (define (comment x)
    `(// ,x))

  (define (And a b c)
    (let ([w (w)])
      `(,(comment (comment-and))
        (nand ,a ,b ,w)
        (nand ,w ,w ,c))))

  (define (Xor a b c)
    (let ([w1 (x)]
          [w2 (x)]
          [w3 (x)])
      `(,(comment (comment-xor))
        (nand ,a  ,b  ,w1)
        (nand ,w1 ,b  ,w2)
        (nand ,a  ,w1 ,w3)
        (nand ,w2 ,w3 ,c))))

  (define (Or a b c)
    (let ([w1 (w)]
          [w2 (w)])
      `(,(comment (comment-or))
        (nand ,a ,a ,w1)
        (nand ,b ,b ,w2)
        (nand ,w1 ,w2 ,c))))

  (define (or3 a b c d)
    (let ([w (w)])
      (append
       (Or a b w)
       (Or w c d))))

  (define (and3 a b c d)
    (let ([w (w)])
      (append
       (And a b w)
       (And w c d))))

  (define (and4 a b c d e)
    (let ([w1 (w)]
          [w2 (w)])
      (append
       (And a b w1)
       (And c d w2)
       (And w1 w2 e))))

  (define (or4 a b c d e)
    (let ([w1 (w)]
          [w2 (w)])
      (append
       (Or a b w1)
       (Or c d w2)
       (Or w1 w2 e))))

  (define (pfa a b cin p g sum)
    (append
     (list (comment (comment-pfa)))
     (And a b g)
     (Xor a b p)
     (Xor p cin sum)))

  (define (cla g0 g1 g2 g3
               p0 p1 p2 p3 cin
               c1 c2 c3
               pout gout)
    (let-values ([(w1c0 w1c1 w1c2) (wires w 3)]
                 [(w2c1 w2c2)      (wires w 2)]
                 [(w3c2)           (w)]
                 [(w1g w2g w3g)    (wires w 3)])
      (append
       (list (comment (comment-cla)))
       (And p0 cin w1c0)
       (Or  g0 w1c0 c1)

       (And  p1 g0 w1c1)
       (and3 p1 p0 cin w2c1)
       (or3  g1 w1c1 w2c1 c2)

       (And  p2 g1 w1c2)
       (and3 p2 p1 g0 w2c2)
       (and4 p2 p1 p0 cin w3c2)
       (or4  g2 w1c2 w2c2 w3c2 c3)

       (And  p3 g2 w1g)
       (and3 p3 p2 g1 w2g)
       (and4 p3 p2 p1 g0 w3g)

       (or4  g3 w1g w2g w3g gout)
       (and4 p3 p2 p1 p0 pout))))

  (define (add4 a0 a1 a2 a3
                b0 b1 b2 b3 c0
                s0 s1 s2 s3
                pout gout)
    (let-values ([(p0 p1 p2 p3) (wires p 4)]
                 [(g0 g1 g2 g3) (wires g 4)]
                 [(c1 c2 c3)    (wires c 3)])
      (append
       (list (comment (comment-add4)))
       (pfa a0 b0 c0 p0 g0 s0)
       (pfa a1 b1 c1 p1 g1 s1)
       (pfa a2 b2 c2 p2 g2 s2)
       (pfa a3 b3 c3 p3 g3 s3)
       (cla g0 g1 g2 g3
            p0 p1 p2 p3 c0
            c1 c2 c3
            pout gout))))

  (define (add16 a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15
                 b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15
                 c0
                 s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15
                 cout)
    (let-values ([(p0 p1 p2 p3) (wires p 4)]
                 [(g0 g1 g2 g3) (wires g 4)]
                 [(   c1 c2 c3) (wires c 3)]
                 [(pout) (p)]
                 [(gout) (g)])
      (append
       (add4 a0 a1 a2 a3
             b0 b1 b2 b3 c0
             s0 s1 s2 s3
             p0 g0)
       (add4 a4 a5 a6 a7
             b4 b5 b6 b7 c1
             s4 s5 s6 s7
             p1 g1)
       (add4 a8 a9 a10 a11
             b8 b9 b10 b11 c2
             s8 s9 s10 s11
             p2 g2)
       (add4 a12 a13 a14 a15
             b12 b13 b14 b15 c3
             s12 s13 s14 s15
             p3 g3)
       (cla g0 g1 g2 g3
            p0 p1 p2 p3
            c0 c1 c2 c3
            pout gout))))

  (define a16
    (time (add16 'a0 'a1 'a2  'a3  'a4  'a5  'a6  'a7
                 'a8 'a9 'a10 'a11 'a12 'a13 'a14 'a15
                 'b0 'b1 'b2  'b3  'b4  'b5  'b6  'b7
                 'b8 'b9 'b10 'b11 'b12 'b13 'b14 'b15
                 'false
                 'out0 'out1 'out2  'out3  'out4  'out5  'out6  'out7
                 'out8 'out9 'out10 'out11 'out12 'out13 'out14 'out15
                 'cout)))

  (define (count-nand xs)
    (count (lambda (x) (eq? 'nand (first x))) xs))

  (printf "// unoptimized = ~a gates\n" (count-nand a16))

  (define opt-a16 (time (sexp-optimize a16)))

  (printf "// optimized = ~a gates\n" (count-nand opt-a16))

  (display (sexp->hdl opt-a16))
  (newline)

  ) ; module+ main
