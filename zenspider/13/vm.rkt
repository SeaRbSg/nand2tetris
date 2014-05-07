#!/usr/bin/env racket

#lang racket

(require racket/cmdline)
(require racket/generic)

;;; Generics & Structs

(define file-name (void))

(define-generics printer
  (vm-print printer))

(struct Stack (segment offset))

(struct Push Stack ()
        #:methods gen:printer
        [(define (vm-print obj)
           (define seg (Stack-segment obj))
           (define off (Stack-offset obj))
           (assemble (comment "push ~a ~a" seg off)
                     (deref seg off)
                     (store obj)
                     (push-d)))])

(struct Pop Stack ()
        #:methods gen:printer
        [(define (vm-print obj)
           (define seg (Stack-segment obj))
           (define off (Stack-offset obj))
           (assemble (comment "pop ~a ~a" seg off)
                     (deref seg off)
                     (asm "D=A")
                     (asm (store-d "@R15") (pop "D") "@R15" "A=M") ; temp_store
                     (asm "M=D")))])

(struct Op (msg)
        #:methods gen:printer
        [(define (vm-print obj)
           (define msg (Op-msg obj))
           (define push (case msg
                          [("not" "neg") false]
                          [else (push-d "A=M")]))
           (assemble (comment "~a" msg)
                     (do-op msg)
                     push))])

(struct Label (name internal)
        #:methods gen:printer
        [(define (vm-print obj)
           (define int (Label-internal obj))
           (define name (Label-name obj))
           (define comm (if int false (comment "label ~a" name)))
           (assemble comm
                     (format "(~a)" name)))])

(struct If-Goto (name)
        #:methods gen:printer
        [(define (vm-print obj)
           (assemble (pop "D")
                     (@ (If-Goto-name obj))
                     "D;JNE"))])

(struct Goto (name internal)
        #:methods gen:printer
        [(define (vm-print obj)
           (define name (Goto-name obj))
           (define internal (Goto-internal obj))
           (define comm (case internal
                          [(none) false]
                          [(internal) (format "/// goto @~a" name)]
                          [else (comment "goto @~a" name)]))
           (assemble comm
                     (@ name)
                     "0;JMP"))])

(struct Function (name size)
        #:methods gen:printer
        [(define (vm-print obj)
           (define/generic super-vm-print vm-print)
           (define name (Function-name obj))
           (define size (Function-size obj))
           (define (push-locals fn)
             (case size
               [(0)
                false]
               [(1 2)                              ; 4n=5+2n == 2n=5 == n=2.5
                (for/list ([n (in-range size)])
                  (list (push-d "AM=M+1" "0")))]
               [else 
                (asm (@ size)
                     "D=A" "@SP" "AM=D+M" "A=A-D"
                     (for/list ([n (in-range size)])
                       (list "M=0" "A=A+1")))]))
           (assemble (comment "function ~a ~a" name size)
                     (super-vm-print (Label name 'internal))
                     (push-locals obj)))])

(struct Call (name size)
        #:methods gen:printer
        [(define (vm-print obj)
           (define/generic super-vm-print vm-print)
           (define (push name [loc "M"])
             (asm (format "/// push ~a" name) name (format "D=~a" loc) (push-d)))
           (define (set dest . instructions)
             (append instructions (store-d dest)))
           (define addr (next-num "return"))
           (define name (Call-name obj))
           (define size (Call-size obj))
           
           (assemble (comment "call ~a ~a" name size)
                     (push (@ addr) "A")
                     (push "@LCL")
                     (push "@ARG")
                     (push "@THIS")
                     (push "@THAT")
                     (set "@ARG"
                          (format "/// ARG = SP-~a-5" size)
                          (@ (+ 5 size)) "D=A" "@SP" "D=M-D")
                     (set "@LCL" "/// LCL = SP" "@SP" "D=M")
                     (super-vm-print (Goto name 'internal))
                     (super-vm-print (Label addr 'internal))))])

(struct Return ()
        #:methods gen:printer
        [(define (vm-print obj)
           (assemble (comment "return")
                     "/// FRAME = LCL"
                     "@LCL" "D=M" (store-d "@R14")
                     (let ([arg "@R13"]
                           [off 5])
                       (asm              ; store_frame("@R13" 5)
                        (format "/// ~a = *(FRAME-~a)" arg off)
                        (@ off)
                        "D=A"
                        "@R14"
                        "A=M-D"
                        "D=M"
                        (store-d arg)))

                     "/// *ARG = pop()"
                     (pop "D") (store-d! "@ARG")

                     "/// SP = ARG+1"
                     "@ARG" "D=M+1" (store-d "@SP")

                     (decrement-and-store-frame "@THAT" 1)
                     (decrement-and-store-frame "@THIS" 2)
                     (decrement-and-store-frame "@ARG"  3)
                     (decrement-and-store-frame "@LCL"  4)

                     "/// goto RET"
                     "@R13" "A=M" "0;JMP"))])

(struct Init ()
        #:methods gen:printer
        [(define (vm-print obj)
           (define/generic super-vm-print vm-print)
           (define fuck (next-num "FUCK_IT_BROKE"))

           (assemble (comment "bootstrap")
                     "/// SP = 256"
                     "@256" "D=A" (store-d "@SP")
                     "/// set THIS=THAT=LCL=ARG=-1 to force error if used as pointer"
                     "D=-1"
                     (store-d "@THIS")
                     (store-d "@THAT")
                     (store-d "@LCL")
                     (store-d "@ARG")
                     (super-vm-print (Call "Sys.init" 0))
                     (super-vm-print (Label fuck false))
                     (super-vm-print (Goto fuck false))))])

;;; Stack Functions

(define (asm . instructions)
  instructions)

(define (assemble . instructions)
  (define (truthy l) (filter identity l))
  (string-join (truthy (flatten instructions)) "\n   "))

(define (decrement-and-store-frame arg off)
  (asm (format "/// ~a = *(FRAME-~a)" arg off)
       "@R14" "AM=M-1" "D=M" (store-d arg)))

(define (deref name offset)
  (case name
    [("constant") (@ (number->string offset))]
    [("temp")
     (asm (@ (format "R~a" (+ 5 offset))))]
    [("static")
     (asm (format "@~a.~a" file-name offset))]
    [("pointer")
     (define off (if (zero? offset) false "A=A+1"))
     (asm "@THIS" off)]
    [else
     (let ([seg (case name
                  [("local")    "LCL"]
                  [("argument") "ARG"]
                  [("this")     "THIS"]
                  [("that")     "THAT"])])
       (case offset
         [(0) (asm (@ seg) "A=M")]
         [(1) (asm (@ seg) "A=M+1")]
         [else (asm (@ seg) "D=M" (@ (number->string offset)) "A=D+A")]))]))

(define (pop dest)
  (asm "@SP" "AM=M-1" (format "~a=M" dest)))

(define (push-d [deref "AM=M+1"] [val "D"])
  (asm "@SP" deref "A=A-1" (format "M=~a" val)))

(define (store obj)
  (if (string=? "constant" (Stack-segment obj))
      "D=A" "D=M"))

(define (store-d loc)
  (asm loc "M=D"))

(define (store-d! loc)
  (asm loc "A=M" "M=D"))

;;; Helper functions

(define (@ name)
  (format "@~a" name))

(define (comment fmt . args)
  (format "~n// ~a~n" (apply format fmt args)))

(define *next-num* (make-hash))
(define (next-num name)
  (define n (hash-ref *next-num* name 1))
  (hash-set! *next-num* name (add1 n))
  (format "~a.~a" name n))

(define (do-op msg)
  (define (binary . instructions)
    (apply asm (pop "D") "A=A-1" "A=M" instructions))

  (define (unary . instructions)
    (apply asm "@SP" "A=M-1" instructions))

  (define (test test)
    (define addr (next-num test))
    (binary "D=A-D"
            (@ addr)
            (format "D;~a" test)
            "D=0"
            (vm-print (Goto (format "~a.done" addr) 'none))
            (vm-print (Label addr 'internal))
            "D=-1"
            (vm-print (Label (format "~a.done" addr) 'internal))))

  (case msg
    [("add") (binary "D=D+A")]
    [("and") (binary "D=D&A")]
    [("or")  (binary "D=D|A")]
    [("sub") (binary "D=A-D")]
    [("neg") (unary  "M=-M")]
    [("not") (unary  "M=!M")]
    [("eq")  (test   "JEQ")]
    [("gt")  (test   "JGT")]
    [("lt")  (test   "JLT")]
    [else (error "Unhandled op" msg)]))

;;; Driver

(define (to-vm thingy)
  (printf "   ~a~n" (vm-print thingy)))

(define (vm/compile lines)
  (define (compile)
    (define SEGMENTS "(argument|local|static|constant|this|that|pointer|temp)")
    (define OPS "(add|sub|neg|eq|gt|lt|and|or|not)")

    (for/list ([line lines])
      (let ([l (regexp-replace " *//.*" (string-trim line) "")])
        (match l
          ["" false]
          [(pregexp #px"^//") false]

          [(pregexp (format "^push ~a (\\d+)" SEGMENTS) (list _ seg n))
           (Push seg (string->number n))]

          [(pregexp (format "^pop ~a (\\d+)" SEGMENTS) (list _ seg n))
           (Pop seg (string->number n))]

          [(pregexp (format "^~a$" OPS) (list _ op))
           (Op op)]

          [(pregexp #px"^label (\\S+)" (list _ name))
           (Label name false)]
          
          [(pregexp #px"^if-goto (\\S+)$" (list _ name))
           (If-Goto name)]
          
          [(pregexp #px"^goto (\\S+)$" (list _ name))
           (Goto name false)]
          
          [(pregexp #px"^function (\\S+) (\\d+)$" (list _ name count))
           (Function name (string->number count))]
          
          [(pregexp #px"^call (\\S+) (\\d+)$" (list _ name count))
           (Call name (string->number count))]

          [(pregexp #px"^return$")
           (Return)]))))
  (map to-vm (filter identity (compile))))

(let ([paths (command-line #:args paths paths)])
  (when (empty? paths)
    (set! paths (list "ProgramFlow/FibonacciSeries/FibonacciSeries.vm")))

  (when (> (length paths) 1)
    (to-vm (Init)))

  (for ([path paths])
    (let ([fuck (path->string (file-name-from-path path)) ])
     (set! file-name (substring fuck 0 (- (string-length fuck)
                                          (string-length ".vm")))))
    (vm/compile (file->lines path))))
