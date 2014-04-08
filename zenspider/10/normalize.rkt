#lang racket

(require xml)

(define (clean/ws el)
  (define (all-blank s) (andmap char-whitespace? (string->list s)))
  (define name (element-name el))
  (define content (map (lambda (x) (if (element? x) (clean/ws x) x))
                       (element-content el)))
  (make-element
   (source-start el)
   (source-stop el)
   name
   (element-attributes el)
   (filter (lambda (s) (not (and (pcdata? s) (all-blank (pcdata-string s)))))
           content)))

(module+ main
  (collapse-whitespace true)
  (for ([path (current-command-line-arguments)])
    (let ([xml (if (string=? "-" path) (read-xml) (read-xml (open-input-file path)))])
      (display-xml/content (clean/ws (document-element xml)))))
  (newline))
