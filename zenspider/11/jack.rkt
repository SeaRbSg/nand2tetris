#lang racket/base

(require racket/list)
(require racket/match)
(require (rename-in (prefix-in jack/ "jack/parser.rkt")
                    (jack/parse jack/parser)))
(require "jack/lexer.rkt")
(require "symbol-table.rkt")
(require syntax/parse)
(require (only-in srfi/1 zip))

(require racket/pretty)
(define (wtf where what)
  (pretty-print (cons where (syntax->datum what)) (current-error-port)))

(define (jack/compile stx)
  (define (map/compile fn xs env)
    (map (lambda (x) (fn x env)) (syntax->list xs)))

  (define-syntax-class cvar
    (pattern ({~datum classVarDec} scope type name0 (~seq "," names) ... ";")))

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

  (define (compile-class stx env)
    (syntax-parse stx
      ;; class: "class" className "{" classVarDec* subroutineDec* "}"
      [({~datum class} "class" ({~datum className} class-name) "{"
        classvars:cvar ... subroutines ... "}")
       (define name (syntax-e #'class-name))

       (printf "// class ~a~n" name)

       (define new-env
         (for/fold ([env (env-set env 'class-name name)])
                   ([cv (syntax->list #'(classvars ...))])
           (compile-classvar cv env)))

       (map/compile compile-subroutine #'(subroutines ...) new-env)]))

  (define (compile-classvar stx env)
    ;; (wtf 'classvar stx)
    (syntax-parse stx
      [({~datum classVarDec} scope type name0 (~seq "," names) ... ";")
       (define scope* (compile-scope #'scope env))
       (define type* (compile-type #'type env))
       (define vars* (cons (compile-varname #'name0 env)
                           (map/compile compile-varname #'(names ...) env)))

       (for/fold ([env env])
                 ([var vars*])
         (env-add env var type* scope*))]))

  (define (compile-scope stx env)
    (syntax-parse stx
      ["static" "static"]
      ["field" "field"]))

  (define (compile-subroutine stx env)
    ;; (wtf 'subroutine stx)
    (syntax-parse stx
      [({~datum subroutineDec} scope return-type ({~datum subroutineName} name)
        "(" params ")" ({~datum subroutineBody} "{" vars ... statements "}"))
       (define scope*       (syntax-e #'scope))
       (define return-type* (compile-type #'return-type env))
       (define name*        (syntax-e #'name))
       (define classname    (env-get env 'class-name))

       (define newenv (compile-params #'params env))
       (define original (env-length newenv))

       (set! newenv
         (for/fold ([env newenv])
                   ([var (syntax->list #'(vars ...))])
           (compile-sub-var var env)))

       (define var-count (- (env-length newenv) original))
       (printf "function ~a.~a ~a~n" classname name* var-count)

       (compile-statements #'statements newenv)]))

  (define (compile-params stx env)
    ;; (wtf 'params stx)
    (syntax-parse stx
      [({~datum parameterList})
       env]
      [({~datum parameterList} (~seq type0 var0 (~seq "," ts vars) ...))
       (for/fold ([env env])
                 ([t (cons (compile-type #'type0 env)
                           (map/compile compile-type #'(ts ...) env))]
                  [v (cons (compile-varname #'var0 env)
                           (map/compile compile-varname #'(vars ...) env))])
         (env-add env v t "argument"))]))

  (define (compile-sub-var stx env)
    ;; (wtf 'subvar stx)
    (syntax-parse stx
      [({~datum varDec} "var" type name0 (~seq "," names) ... ";")
       (define type* (compile-type #'type env))
       (define names* (cons (compile-varname #'name0 env)
                            (map/compile compile-varname #'(names ...) env)))
       (error "not yet")
       (list type* names*)]))

  (define (compile-type stx env)
    (syntax-parse stx
      [({~datum type} ({~datum className} id)) (syntax-e #'id)]
      [({~datum type} id:str)                  (syntax-e #'id)]
      [({~datum returnType} "void")            "void"]
      [({~datum returnType} type)              (compile-type #'type env)]))

  (define (compile-varname stx env)
    ;; (wtf 'varname stx)
    (syntax-parse stx
      [({~datum varName} id) (syntax-e #'id)]))

  (define (compile-statements stx env)
    (syntax-parse stx
      [({~datum statements} (~seq ({~datum statement} statements)) ...)
       (map/compile compile-statement #'(statements ...) env)]))

  (define (compile-statement stx env)
    (syntax-parse stx
      [({~datum letStatement} "let" varname "=" expression ";")
       (define var* (compile-varname #'varname env))
       (define expr* (compile-expression #'expression env))
       (define var? (env-get env var*))
       (printf "pop ~a ~a~n" (var-scope var?) (var-idx var?))]
      [({~datum letStatement} "let" varname "[" idx "]" "=" expression ";")
       (error "not yet")
       (list 'let ; TODO
             (compile-varname #'varname env)
             (compile-expression #'idx env)
             (compile-expression #'expression env))]
      [({~datum whileStatement} "while" "(" expression ")" "{" statements "}")
       (error "not yet")
       (list 'while ; TODO
             (compile-expression #'expression env)
             (compile-statements #'statements env))]
      [({~datum doStatement} "do" subroutineCall ";")
       (compile-call #'subroutineCall env)]
      [({~datum returnStatement} "return" ";")
       (printf "return~n")]
      [({~datum returnStatement} "return" expression ";")
       (compile-expression #'expression env)
       (printf "return~n")]))

  (define (compile-call stx env)
    (syntax-parse stx
      [({~datum subroutineCall}
        (subroutineName subname) "(" args ")")
       (define args* (compile-expression-list #'args env))

       (error "not yet")
       (list 'sub
             (syntax-e #'subname)
             (syntax->list #'args))]
      [({~datum subroutineCall}
        ({~datum className} recvname) "."
        (subroutineName subname) "(" args ")")

       (define recv* (syntax-e #'recvname))
       (define name* (syntax-e #'subname))
       (define args* (compile-expression-list #'args env))

       (printf "call ~a.~a ~a~n" recv* name* (length args*))]))

  (define (compile-expression-list stx env)
    ;; expressionList: [expression ("," expression)*]
    (syntax-parse stx
      [({~datum expressionList} e0 (~seq "," exprs) ...)
       (cons (compile-expression #'e0 env)
             (map/compile compile-expression #'(exprs ...) env))]))

  (define (compile-expression stx env)
    (wtf 'expression stx)
    (syntax-parse stx
      [({~datum expression} t0 (~seq ops ts) ...)
       (compile-term #'t0 env)
       (for/list ([o (syntax->list #'(ops ...))]
                  [t (syntax->list #'(ts ...))])
         (compile-term t env)
         (compile-op o env))]))

  (define OPS (hash "+" "add" "-" "sub" "&" "and" "|" "or"
                    "<" "lt"  ">" "gt"  "=" "eq"  "~" "not"
                    "*" "call Math.multiply 2"
                    "/" "call Math.divide 2"))

  (define (compile-op stx env)
    (wtf 'op stx)
    (syntax-parse stx
      [({~datum op} val)
       (printf "~a~n" (hash-ref OPS (syntax-e #'val)))]))

  (define (compile-term stx env)
    (wtf 'term stx)
    (syntax-parse stx
      [({~datum term} val:integer)
       (printf "push constant ~a\n" (syntax-e #'val))]
      [({~datum term} val:str)
       (error "not yet")
       (printf "push ~a\n" (syntax-e #'val))]
      [({~datum term} ({~datum keywordConstant} val))
       (error "not yet")
       (printf "push ~a\n" (syntax-e #'val))]
      [({~datum term} var "[" expr "]")
       (error "not yet")
       (compile-expression #'expr env)
       (printf "push ~a\n" (syntax-e #'var))]
      [({~datum term} var)
       ;; (error "wtf" (syntax->datum #'var))
       (define var* (compile-varname #'var env))
       (define var? (env-get env var*))
       (printf "push ~a ~a\n" (var-scope var?) (var-idx var?))]
      ;; [({~datum term} call)
      ;;  (compile-call #'call env)
      ;;  (printf "push ~a\n" (syntax-e #'val))]
      [({~datum term} "(" expr ")")
       (compile-expression #'expr env)]
      [({~datum term} ({~datum unaryOp} op) term)
       (error "not yet")
       (compile-term #'term env)
       (printf "~a~n" (hash-ref OPS (syntax-e #'op)))] ;; HACK
      ))

  (compile-class stx (env-new)))

(module+ main
  (require racket/pretty)

  (define (jack ip)
    (port-count-lines! ip)
    (jack/parser (lambda () (jack/lexer ip))))

  (let ([paths (current-command-line-arguments)])
    (when (empty? paths)
      (set! paths (list "ConvertToBin/Main.jack")))

    ;; (set! paths (list "ConvertToBin/Main.jack"))
    (set! paths (list "../09/grid/MathX.jack"))

    (for ([path paths])
      (define xexpr (jack (open-input-file path)))
      ;; (pretty-print (syntax->datum xexpr))
      ;; (newline)
      (jack/compile xexpr)
      (newline))))
