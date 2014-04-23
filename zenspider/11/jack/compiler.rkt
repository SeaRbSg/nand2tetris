#lang racket/base

(require syntax/parse)
(require "symbol-table.rkt")

(provide jack/compile)

(define (jack/compile stx)
  (define OPS (hash "+" "add" "-" "sub" "&" "and" "|" "or"
                    "<" "lt"  ">" "gt"  "=" "eq"
                    "*" "call Math.multiply 2"
                    "/" "call Math.divide 2"))

  (define UOPS (hash "~" "not"
                     "-" "neg"))

  (define labels (make-hash))

  ;;; Helper Functions

  (define (reset-labels) (set! labels (make-hash)))

  (define (new-label name)
    (define idx (hash-ref labels name 0))
    (hash-set! labels name (add1 idx))
    (format "~a~a" name idx))

  (define (map/compile fn xs env)
    (map (lambda (x) (fn x env)) (syntax->list xs)))

  ;;; Syntax Classes

  (define-syntax-class cvar
    (pattern ({~datum classVarDec} scope type name0 (~seq "," names) ... ";")))

  (define-syntax-class call
    (pattern ({~datum subroutineCall} subroutineName "(" expressionList ")"))
    (pattern ({~datum subroutineCall} recv "." subroutineName "(" expressionList ")")))

  (define-syntax-class var
    (pattern ({~datum varName} name)))

  ;; TODO
  ;; (define-syntax-class term
  ;;   (pattern ((~literal t) t)))
  ;;
  ;; (define-syntax-class operator
  ;;   (pattern ((~literal o) op)))
  ;;
  ;; (define-splicing-syntax-class op-term
  ;;   (pattern (~seq o:operator t:term)))
  ;;
  ;; (syntax-parse #'(e (t "2") (o "+") (t "3") (o "+") (t "4"))
  ;;   [(e t:term ot:op-term ...)
  ;;    (syntax->datum #'(e t ot ...))])

  ;;; Compiler Functions

  (define (compile-call stx env)
    (syntax-parse stx
      [({~datum subroutineCall}
        (subroutineName subname) "(" args ")")
       (define classname (env-get env 'class-name))
       (define name* (syntax-e #'subname))

       (printf "push pointer 0\n")
       (define args* (add1 (compile-expression-list #'args env)))
       (printf "call ~a.~a ~a~n" classname name* args*)]
      [({~datum subroutineCall}
        ({~datum className} recvname) "."
        (subroutineName subname) "(" args ")")

       (define recvname* (syntax-e #'recvname))
       (define var   (env-get env recvname*))
       (define recv* (or (and var (var-type var)) recvname*))
       (define name* (syntax-e #'subname))
       (define bonus 0)

       (unless (equal? recvname* recv*) ; instance.meth() instead of MyClass.func()
         (printf "push ~a ~a~n" (var-scope var) (var-idx var))
         (set! bonus 1))

       (define args* (compile-expression-list #'args env))

       (printf "call ~a.~a ~a~n" recv* name* (+ bonus args*))]))

  (define (compile-class stx env)
    (syntax-parse stx
      [({~datum class} "class" ({~datum className} class-name) "{"
        classvars:cvar ... subroutines ... "}")
       (define name (syntax-e #'class-name))
       (define new-env
         (for/fold ([env (env-set env 'class-name name)]) ; + 1
                   ([cv (syntax->list #'(classvars ...))])
           (compile-classvar cv env)))
       (define classvar-count (length (filter is-this? (hash-values new-env))))

       (map/compile compile-subroutine #'(subroutines ...)
                    (env-set new-env 'class-fields classvar-count))]))

  (define (compile-classvar stx env)
    (syntax-parse stx
      [({~datum classVarDec} scope type name0 (~seq "," names) ... ";")
       (define scope* (compile-scope #'scope env))
       (define type* (compile-type #'type env))
       (define vars* (cons (compile-varname #'name0 env)
                           (map/compile compile-varname #'(names ...) env)))

       (for/fold ([env env])
                 ([var vars*])
         (env-add env var type* scope*))]))

  (define (compile-expression stx env)
    (syntax-parse stx
      [({~datum expression} t0 (~seq ops ts) ...)
       (compile-term #'t0 env)
       (for/list ([o (syntax->list #'(ops ...))]
                  [t (syntax->list #'(ts ...))])
         (compile-term t env)
         (compile-op o env))]))

  (define (compile-expression-list stx env)
    (syntax-parse stx
      [({~datum expressionList})        ; TODO: better way? ~optional maybe?
       0]
      [({~datum expressionList} e0 (~seq "," exprs) ...)
       (compile-expression #'e0 env)
       (add1 (length (map/compile compile-expression #'(exprs ...) env)))]))

  (define (compile-if stx env)
    (define/syntax-parse (c t f) stx)
    (define labelt (new-label "IF_TRUE"))
    (define labelf (new-label "IF_FALSE"))
    (define labele (new-label "IF_END"))

    (compile-expression #'c env)
    (printf "if-goto ~a~n" labelt)
    (printf "goto ~a~n" labelf)
    (printf "label ~a~n" labelt)

    (compile-statements #'t env)

    (if (not (syntax-e #'f))
        (printf "label ~a~n" labelf)
        (begin
          (printf "goto ~a~n" labele)
          (printf "label ~a~n" labelf)
          (compile-statements #'f env)
          (printf "label ~a~n" labele))))

  (define (compile-keyword stx env)
    (syntax-parse stx
      ["true"  (printf "push constant 0\nnot\n")]
      ["false" (printf "push constant 0\n")]
      ["null"  (printf "push constant 0\n")]
      ["this"  (printf "push pointer 0\n")]
      [_ (error "Unknown keyword literal:" (syntax-e stx))]))

  (define (compile-op stx env)
    (syntax-parse stx
      [({~datum op} val)
       (printf "~a~n" (hash-ref OPS (syntax-e #'val)))]))
  
  (define (compile-params stx env)
    (syntax-parse stx
      [({~datum parameterList})
       env]
      [({~datum parameterList} (~seq type0 name0 (~seq "," ts names) ...))
       (for/fold ([env env])
                 ([t (cons (compile-type #'type0 env)
                           (map/compile compile-type #'(ts ...) env))]
                  [n (cons (compile-varname #'name0 env)
                           (map/compile compile-varname #'(names ...) env))])
         (env-add env n t 'argument))]))

  (define (compile-scope stx env)
    (syntax-parse stx
      ["static" 'static]
      ["field"  'this]
      [_ (error "bad scope" (syntax-e stx))]))

  (define (compile-statement stx env)
    (syntax-parse stx
      [({~datum letStatement} "let" varname "=" expression ";")
       (define var* (compile-varname #'varname env))
       (define var? (env-get env var*))

       (compile-expression #'expression env)
       (printf "pop ~a ~a~n" (var-scope var?) (var-idx var?))]

      [({~datum letStatement} "let" varname "[" idx "]" "=" expression ";")
       (define var* (compile-varname #'varname env))
       (define var? (env-get env var*))

       (compile-expression #'idx env)
       (printf "push ~a ~a~n" (var-scope var?) (var-idx var?))
       (printf "add~n")
       (compile-expression #'expression env)
       (printf "pop temp 0~n")          ; HACK?
       (printf "pop pointer 1~n")
       (printf "push temp 0~n")         ; HACK?
       (printf "pop that 0~n")]
      [({~datum whileStatement} "while" "(" expression ")" "{" statements "}")
       (compile-while #'(expression statements) env)]

      [({~datum doStatement} "do" subroutineCall ";")
       (compile-call #'subroutineCall env)
       (printf "pop temp 0~n")]

      [({~datum ifStatement} "if" "(" c ")" "{" t "}" "else" "{" f "}")
       (compile-if #'(c t f) env)]

      [({~datum ifStatement} "if" "(" c ")" "{" t "}")
       (compile-if #'(c t #f) env)]

      [({~datum returnStatement} "return" ";")
       (printf "push constant 0~n")
       (printf "return~n")]

      [({~datum returnStatement} "return" expression ";")
       (compile-expression #'expression env)
       (printf "return~n")]))

  (define (compile-statements stx env)
    (syntax-parse stx
      [({~datum statements} (~seq ({~datum statement} statements)) ...)
       (map/compile compile-statement #'(statements ...) env)]))
  
  (define (compile-sub-var stx env)
    (syntax-parse stx
      [({~datum varDec} "var" type name0 (~seq "," names) ... ";")
       (define type* (compile-type #'type env))
       (for/fold ([env env])
                 ([n (cons (compile-varname #'name0 env)
                           (map/compile compile-varname #'(names ...) env))])
         (env-add env n type* 'local))]))

  (define (compile-subroutine stx env)
    (syntax-parse stx
      [({~datum subroutineDec} scope return-type ({~datum subroutineName} name)
        "(" params ")" ({~datum subroutineBody} "{" vars ... statements "}"))
       (define scope*       (syntax-e #'scope))
       (define return-type* (compile-type #'return-type env))
       (define name*        (syntax-e #'name))
       (define classname    (env-get env 'class-name))

       (define newenv (compile-params #'params (if (equal? scope* "method")
                                                   (env-bump env 'argument)
                                                   env)))
       (define original (env-length newenv))

       (reset-labels)

       (set! newenv
         (for/fold ([env newenv])
                   ([var (syntax->list #'(vars ...))])
           (compile-sub-var var env)))

       (define var-count (- (env-length newenv) original))  ; FIX: actually count
       (printf "function ~a.~a ~a~n" classname name* var-count)

       (case scope*
         [("method")
          (printf "push argument 0\n")
          (printf "pop pointer 0\n")]
         [("constructor")
          (printf "push constant ~a\n" (env-get newenv 'class-fields))
          (printf "call Memory.alloc 1\n")
          (printf "pop pointer 0\n")]
         [("function") 'do-nothing]
         [else
          (error "unknown scope" scope*)])

       (compile-statements #'statements newenv)]))
  
  (define (compile-term stx env)
    (syntax-parse stx
      [({~datum term} val:integer)
       (printf "push constant ~a\n" (syntax-e #'val))]

      [({~datum term} val:str)
       (define str* (syntax-e #'val))
       (define len (string-length str*))
       (printf "push constant ~a~n" (- len 2))
       (printf "call String.new 1~n")

       (for ([c (in-string str* 1 (sub1 (string-length str*)) 1)])
         (printf "push constant ~a~n" (char->integer c))
         (printf "call String.appendChar 2~n"))]

      [({~datum term} ({~datum keywordConstant} val))
       (compile-keyword #'val env)]

      [({~datum term} var:var "[" expr "]")
       ;; (term (varName "xs") "[" (expression (term 0)) "]")
       (define var* (compile-varname #'var env))
       (define var? (env-get env var*))

       (compile-expression #'expr env)
       (printf "push ~a ~a~n" (var-scope var?) (var-idx var?))
       (printf "add~n")
       (printf "pop pointer 1~n")
       (printf "push that 0~n")]

      [({~datum term} var:var)
       (define var* (compile-varname #'var env))
       (define var? (env-get env var*))
       (printf "push ~a ~a\n" (var-scope var?) (var-idx var?))]

      [({~datum term} c:call)
       (compile-call #'c env)]

      [({~datum term} "(" expr ")")
       (compile-expression #'expr env)]

      [({~datum term} ({~datum unaryOp} op) term)
       (compile-term #'term env)
       (printf "~a~n" (hash-ref UOPS (syntax-e #'op)))]))

  (define (compile-type stx env)
    (syntax-parse stx
      [({~datum type} ({~datum className} id)) (syntax-e #'id)]
      [({~datum type} id:str)                  (syntax-e #'id)]
      [({~datum returnType} "void")            "void"]
      [({~datum returnType} type)              (compile-type #'type env)]))

  (define (compile-varname stx env)
    (syntax-parse stx
      [({~datum varName} id) (syntax-e #'id)]))

  (define (compile-while stx env)
    (define/syntax-parse (expression statements) stx)

    (define while_exp (new-label "WHILE_EXP"))
    (define while_end (new-label "WHILE_END"))

    (printf "label ~a~n" while_exp)
    (compile-expression #'expression env)
    (printf "not~n")
    (printf "if-goto ~a~n" while_end)
    (compile-statements #'statements env)
    (printf "goto ~a~n" while_exp)
    (printf "label ~a~n" while_end))

  (compile-class stx (env-new)))
