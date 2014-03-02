#lang racket/base

(require (only-in racket/format ~r))
(require (only-in racket/bool false))
(require (only-in racket/function identity))
(require (only-in racket/match match))
(require (only-in racket/string string-join string-trim))
(require (only-in racket/file file->lines))

(struct A (env ref))
(struct C (code dest jump))

(define (quick-hash . keys)
  (for/hash ([k keys]
             [i (in-range (length keys))])
    (values k i)))

(define DEST (quick-hash false "M" "D" "MD" "A" "AM" "AD" "AMD"))

(define JUMP (quick-hash false "JGT" "JEQ" "JGE" "JLT" "JNE" "JLE" "JMP"))

;;                   a=0 (A's)           a=1 (M's)
(define COMP #hash(("0"   . #b0101010)
                   ("1"   . #b0111111)
                   ("-1"  . #b0111010)
                   ("D"   . #b0001100)
                   ("A"   . #b0110000) ("M"   . #b1110000)
                   ("!D"  . #b0001101)
                   ("!A"  . #b0110001) ("!M"  . #b1110001)
                   ("-D"  . #b0001111)
                   ("-A"  . #b0110011) ("-M"  . #b1110011)
                   ("D+1" . #b0011111)
                   ("A+1" . #b0110111) ("M+1" . #b1110111)
                   ("D-1" . #b0001110)
                   ("A-1" . #b0110010) ("M-1" . #b1110010)
                   ("D+A" . #b0000010) ("D+M" . #b1000010)
                   ("D-A" . #b0010011) ("D-M" . #b1010011)
                   ("A-D" . #b0000111) ("M-D" . #b1000111)
                   ("D&A" . #b0000000) ("D&M" . #b1000000)
                   ("D|A" . #b0010101) ("D|M" . #b1010101)))

(define DEFAULTS                        ; what a pain in the ass!!!
  (make-immutable-hash
   (append (hash->list (quick-hash "R0" "R1" "R2"  "R3"  "R4"  "R5"  "R6"  "R7"
                                   "R8" "R9" "R10" "R11" "R12" "R13" "R14" "R15"))
           (hash->list (quick-hash "SP" "LCL" "ARG" "THIS" "THAT"))
           (list '("SCREEN" . 16384)
                 '("KBD" . 24576)))))

(define (assemble lines)
  (define line# 0)
  (define env (hash-copy DEFAULTS))
  (define n 15)
  (define (next-slot) (set! n (add1 n)) n)
  (define (n->b n w) (~r n #:base 2 #:min-width w #:pad-string "0"))
  (define (to-asm thingy)
    (match thingy
      [(A env ref)
       (let ([val (if (number? ref) ref (hash-ref! env ref next-slot))])
         (format "0~a\n"
                 (n->b val 15)))]
      [(C code dest jump)
       (format "111~a~a~a\n"
               (n->b (hash-ref COMP code) 7)
               (n->b (hash-ref DEST dest) 3)
               (n->b (hash-ref JUMP jump) 3))]))
  (define (compile)
    (for/list ([line lines])
      (let ([l (string-trim line)])
        ;; case line.strip.sub(%r%\s*//.*%, '')
        (match (regexp-replace #px"\\s*//.*" l "")
          ["" false]
          [(pregexp #px"^//") false]

          [(pregexp #px"^\\(([\\w:.$-]+)\\)$" (list _ name))
           (hash-set! env name line#)
           false]
          [(pregexp #px"^@(\\d+)$" (list _ name))
           (set! line# (add1 line#))
           (A env (string->number name))]
          [(pregexp #px"^@([\\w:.$-]+)$" (list _ name))
           (set! line# (add1 line#))
           (A env name)]
          [(pregexp #px"^(?:([ADM]+)\\s*=)?([^;]+)(?:;(J(?:GT|EQ|GE|LT|LE|NE|MP)))?$"
                    (list _ dst cmp jmp))
           (set! line# (add1 line#))
           (C (string-trim cmp) dst jmp)]))))
  (map to-asm (filter identity (compile))))

(define argv (current-command-line-arguments))
(when (zero? (vector-length argv))
    (set! argv #("max/Max.asm")))

(for ([path argv])
  (display (string-join (assemble (file->lines path)) "")))
