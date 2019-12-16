#lang scribble/manual
@(require scribble/eval
          (for-label pangu
                     racket/base))
@(define my-eval (make-base-eval))
@(my-eval `(require pangu))

@title{pangu}
@author{@hyperlink["https://kisaragi-hiu.com"]{Kisaragi Hiu}}

@defmodule[pangu]

@section{English}

Paranoid text spacing for Racket.

Add spaces around CJK characters to make them less cramped.

This is a port of the @hyperlink["https://github.com/vinta/pangu.js"]{pangu family of libraries}. Specifically, the regexps and the test suite are all directly ported from @hyperlink["https://github.com/vinta/pangu.py"]{vinta/pangu.py}.

@section{Mandarin}

@hyperlink["https://github.com/vinta/pangu.js"]{@"@"vinta的盤古之白}移植到Racket上。

基本上是Python版的直譯。

@section{Reference}

@defproc[(spacing [text string?]) string?]{
 Returns a new string with pangu spacing applied.
 @examples[#:eval my-eval
           (spacing "為什麼小明有問題都不Google？因為他有Bing")
           (spacing "當你凝視著bug，bug也凝視著你")]
}

@defproc[(spacing-file [path path-string?]) string?]{
 Apply pangu spacing to the file's contents, and return it as a string.
}