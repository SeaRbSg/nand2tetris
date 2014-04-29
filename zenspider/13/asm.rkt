#!/usr/bin/env racket

#lang racket

(struct A (env ref))
(struct C (code dest jump))

(define (quick-hash . keys)
  (for/hash ([k keys]
             [i (in-range (length keys))])
    (values k i)))

(define DEST (quick-hash false "M" "D" "MD" "A" "AM" "AD" "AMD"))

(define JUMP (quick-hash false "JGT" "JEQ" "JGE" "JLT" "JNE" "JLE" "JMP"))

;; new = +62 instructions
;; old = -28 instructions
;; sum =  34 MOAR POWAH
;;
;;                   a=0 (A's)           a=1 (M's)
;;                                 aznzn+n                  aznzn+n
;;                                 mxxyy&o                  mxxyy&o
(define COMP #hash(("D&A"      . #b0000000) ("D&M"      . #b1000000)
                   ("!(D&A)"   . #b0000001) ("!(M&A)"   . #b1000001)
                   ("~D|~A"    . #b0000001) ("~M|~A"    . #b1000001)
                   ("D+A"      . #b0000010) ("D+M"      . #b1000010)
                   ("~(D+A)"   . #b0000011) ("~(M+A)"   . #b1000011)
                   ("D&!A"     . #b0000100) ("M&!A"     . #b1000100)
                   ("!(D&!A)"  . #b0000101) ("!(M&!A)"  . #b1000101)
                   ("!D|A"     . #b0000101) ("!M|A"     . #b1000101)
                   ("D+~A"     . #b0000110) ("M+~A"     . #b1000110)
                   ("A-D"      . #b0000111) ("M-D"      . #b1000111)
                   ("D"        . #b0001100)
                   ("!D"       . #b0001101) ; #b0011100 preferred
                   ("D-1"      . #b0001110)
                   ("-D"       . #b0001111)
                   ("!D&A"     . #b0010000) ("!M&A"     . #b1010000)
                   ("!(!D&A)"  . #b0010001) ("!(!M&A)"  . #b1010001)
                   ("D|~A"     . #b0010001) ("M|~A"     . #b1010001)
                   ("!D+A"     . #b0010010) ("!M+A"     . #b1010010)
                   ("D-A"      . #b0010011) ("D-M"      . #b1010011)
                   ("!D&!A"    . #b0010100) ("!M&!A"    . #b1010100)
                   ("!(D|A)"   . #b0010100) ("!(M|A)"   . #b1010100)
                   ("D|A"      . #b0010101) ("D|M"      . #b1010101)
                   ("!D+!A"    . #b0010110) ("!M+!A"    . #b1010110)
                   ("~(~D+~A)" . #b0010111) ("~(~M+~A)" . #b1010111)
                   ("!D-1"     . #b0011110) ("!M-1"     . #b1011110)
                   ("D+1"      . #b0011111)
                   ("0"        . #b0101010) ; #b0100000 preferred
                   ("A"        . #b0110000) ("M"   . #b1110000)
                   ("!A"       . #b0110001) ("!M"  . #b1110001) ; #b0110100 preferred
                   ("A-1"      . #b0110010) ("M-1" . #b1110010)
                   ("-A"       . #b0110011) ("-M"  . #b1110011)
                   ("!A-1"     . #b0110110) ("!A-1"     . #b1110110)
                   ("A+1"      . #b0110111) ("M+1" . #b1110111)
                   ("-1"       . #b0111010) ; #b0111100 preferred
                   ("-2"       . #b0111110)
                   ("1"        . #b0111111)))

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
    (set! argv #("Prog.asm")))

(for ([path argv])
  (display (string-join (assemble (file->lines path)) "")))
