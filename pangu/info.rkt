#lang info
(define scribblings '(("scribblings/pangu.scrbl" ())))
(define compile-omit-paths '("tests.rkt"))
(define raco-commands '(("pangu"
                         (submod pangu main)
                         "Apply paranoid CJK text spacing"
                         #f)))
(define clean '("compiled"))
