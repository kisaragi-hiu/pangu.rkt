#lang racket
;; Paranoid text spacing in Racket
;; Port of pangu.py: https://github.com/vinta/pangu.py

(provide spacing
         spacing-text
         spacing-file)

;;; Regex definitions
(define cjk "\u2e80-\u2eff\u2f00-\u2fdf\u3040-\u309f\u30a0-\u30fa\u30fc-\u30ff\u3100-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff")

(define any-cjk (regexp (format "[~a]" cjk)))

;; there is an extra non-capturing group compared to JavaScript version
(define convert-to-fullwidth-cjk-symbols-cjk
  (regexp (format "([~a])([ ]*(?:[\\:]+|\\.)[ ]*)([~a])" cjk cjk)))
(define convert-to-fullwidth-cjk-symbols
  (regexp (format "([~a])[ ]*([~~\\!;,\\?]+)[ ]*" cjk)))
(define dots-cjk
  (regexp (format "([\\.]{{2,}}|\u2026)([~a])" cjk)))
(define fix-cjk-colon-ans
  (regexp (format "([~a])\\:([A-Z0-9\\(\\)])" cjk)))

;; highlighting would be screwed if we just used raw strings
(define cjk-quote (regexp (format "([~a])([`\"\u05f4])" cjk)))
(define quote-cjk (regexp (format "([`\"\u05f4])([~a])" cjk)))
(define fix-quote-any-quote
  #px"([`\"\u05f4]+)(\\s*)(.+?)(\\s*)([`\"\u05f4]+)")

(define cjk-single-quote-but-possessive
  (regexp (format "([~a])('[^s])" cjk)))
(define single-quote-cjk
  (regexp (format "(')([~a])" cjk)))
(define fix-possessive-single-quote
  (regexp (format "([~aA-Za-z0-9])( )('s)" cjk)))

(define hash-ans-cjk-hash
  (regexp (format "([~a])(#)([~a]+)(#)([~a])" cjk cjk cjk)))
(define cjk-hash (regexp (format "([~a])(#([^ ]))" cjk)))
(define hash-cjk (regexp (format "(([^ ])#)([~a])" cjk)))

(define cjk-operator-ans
  (regexp (format "([~a])([-\\+\\*/=&\\\\|<>])([A-Za-z0-9])" cjk)))
(define ans-operator-cjk
  (regexp (format "([A-Za-z0-9])([-\\+\\*/=&\\\\|<>])([~a])" cjk)))

(define fix-slash-as
  #rx"([/]) ([-a-z_\\./]+)")
(define fix-slash-as-slash
  #rx"([/\\.])([-A-Za-z_\\./]+) ([/])")

(define cjk-left-bracket
  (regexp (format "([~a])([\\(\\[{<>\u201c])" cjk)))
(define right-bracket-cjk
  (regexp (format "([]\\)}<>\u201d])([~a])" cjk)))
(define fix-left-bracket-any-right-bracket
  (pregexp "([\\(\\[\\{<\u201c]+)(\\s*)(.+?)(\\s*)([]\\)\\}>\u201d]+)"))
(define ans-cjk-left-bracket-any-right-bracket
  (regexp (format "([A-Za-z0-9~a])[ ]*([\u201c])([-A-Za-z0-9~a_ ]+)([\u201d])"
                  cjk cjk)))
(define left-bracket-any-right-bracket-ans-cjk
  (regexp (format "([\u201c])([-A-Za-z0-9~a_ ]+)([\u201d])[ ]*([A-Za-z0-9~a])"
                  cjk cjk)))

(define an-left-bracket #rx"([A-Za-z0-9])([\\(\\[{])")
(define right-bracket-an #rx"([]\\)}])([A-Za-z0-9])")

(define cjk-ans
  (regexp (format "([~a])([-A-Za-z\u0370-\u03ff0-9@\\$%\\^&\\*\\+\\\\=\\|/\u00a1-\u00ff\u2150-\u218f\u2700-\u27bf])"
                  cjk)))
(define ans-cjk
  (regexp (format "([-A-Za-z\u0370-\u03ff0-9~~\\!\\$%\\^&\\*\\+\\\\=\\|;:,\\./\\?\u00a1-\u00ff\u2150-\u218f\u2700-\u27bf])([~a])"
                  cjk)))

(define s-a #rx"(%)([A-Za-z])")
(define middle-dot (regexp "([ ]*)([\u00b7\u2022\u2027])([ ]*)"))

;; Python version only
(define tildes #rx"~+")
(define exclamation-marks #rx"!+")
(define semicolons #rx";+")
(define colons #rx":+")
(define commas #rx",+")
(define periods #rx"\\.+")
(define question-marks #rx"\\?+")

;;; Functions

(define (convert-to-fullwidth symbols)
  (let* ((symbols (regexp-replace* tildes symbols "～"))
         (symbols (regexp-replace* exclamation-marks symbols "！"))
         (symbols (regexp-replace* semicolons symbols "；"))
         (symbols (regexp-replace* colons symbols "："))
         (symbols (regexp-replace* commas symbols "，"))
         (symbols (regexp-replace* periods symbols "。"))
         (symbols (regexp-replace* question-marks symbols "？")))
    (string-trim symbols)))

;; NOTE: main entry point?
(define (spacing text)
  ;; https://github.com/vinta/pangu.py/blob/89407cf08dedf9d895c13053dd518d11a20f6c95/pangu.py#L97
  ;; this is probably not useful for other regexps.
  (define (to-fullwidth-symbols regexp text [prev #f])
    (if (equal? text prev)
        text
        (match (regexp-match regexp text)
          ((cons old new)
           (to-fullwidth-symbols
            regexp
            (string-replace text old (apply ~a (map convert-to-fullwidth new)))
            text))
          (#f text))))
  ;; sure...
  ;; Return prematurely from function in Racket:
  ;; https://stackoverflow.com/questions/25523522
  (let/ec return
    (when (or (<= (string-length text) 1)
              (not (regexp-match any-cjk text)))
      (return text))
    (let* ((text (to-fullwidth-symbols convert-to-fullwidth-cjk-symbols-cjk text))
           (text (to-fullwidth-symbols convert-to-fullwidth-cjk-symbols text))
           (text (regexp-replace* dots-cjk text "\\1 \\2"))
           (text (regexp-replace* fix-cjk-colon-ans text "\\1：\\2"))
           (text (regexp-replace* cjk-quote text "\\1 \\2"))
           (text (regexp-replace* quote-cjk text "\\1 \\2"))
           (text (regexp-replace* fix-quote-any-quote text "\\1\\3\\5"))
           (text (regexp-replace* cjk-single-quote-but-possessive text "\\1 \\2"))
           (text (regexp-replace* single-quote-cjk text "\\1 \\2"))
           (text (regexp-replace* fix-possessive-single-quote text "\\1's"))
           (text (regexp-replace* hash-ans-cjk-hash text "\\1 \\2\\3\\4 \\5"))
           (text (regexp-replace* cjk-hash text "\\1 \\2"))
           (text (regexp-replace* hash-cjk text "\\1 \\3"))
           (text (regexp-replace* cjk-operator-ans text "\\1 \\2 \\3"))
           (text (regexp-replace* ans-operator-cjk text "\\1 \\2 \\3"))
           (text (regexp-replace* fix-slash-as text "\\1\\2"))
           (text (regexp-replace* fix-slash-as-slash text "\\1\\2\\3"))
           (text (regexp-replace* cjk-left-bracket text "\\1 \\2"))
           (text (regexp-replace* right-bracket-cjk text "\\1 \\2"))
           (text (regexp-replace* fix-left-bracket-any-right-bracket text "\\1\\3\\5"))
           (text (regexp-replace* ans-cjk-left-bracket-any-right-bracket text "\\1 \\2\\3\\4"))
           (text (regexp-replace* left-bracket-any-right-bracket-ans-cjk text "\\1\\2\\3 \\4"))
           (text (regexp-replace* an-left-bracket text "\\1 \\2"))
           (text (regexp-replace* right-bracket-an text "\\1 \\2"))
           (text (regexp-replace* cjk-ans text "\\1 \\2"))
           (text (regexp-replace* ans-cjk text "\\1 \\2"))
           (text (regexp-replace* s-a text "\\1 \\2"))
           (text (regexp-replace* middle-dot text "・")))
      (string-trim text))))

(define (spacing-text text)
  (spacing text))

(define (spacing-file path)
  ;; NOTE: pangu.py has a todo here to read line by line.
  (spacing-text (file->string path)))

;; -v / --version = show version
;; -t / --text = arguments are text to pangu
;; -f / --file = arguments are files to pangu
;; (define (cli)
;;   (command-line
;;    #:program "pangu.rkt"
;;    #:once-each
;;    [("-v" "--version") "Show version" (println "0.0.1")]
;;    #:once-any
;;    [("-t" "--text") "Arguments are text" (spacing-text (current-command-line-arguments))]
;;    [("-t" "--text") "Arguments are text" (spacing-text (current-command-line-arguments))]))

;; TODO: cli
(module+ main
  (spacing-text (first (current-command-line-arguments))))
