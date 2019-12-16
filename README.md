# pangu.rkt

Paranoid text spacing in Racket.

Nearly a direct port of the official Python version ([`vinta/pangu.py`](https://github.com/vinta/pangu.py)).

## Install

After cloning:

```
raco pkg install --name pangu
```

## Usage

```racket
(require pangu)

(spacing-text "當你凝視著bug，bug也凝視著你") ; => "當你凝視著 bug，bug 也凝視著你"

(with-output-to-file "/tmp/testing"
  (lambda () (printf "與PM戰鬥的人, 應當小心自己不要成為PM")))
(spacing-file "/tmp/testing") ; => "與 PM 戰鬥的人，應當小心自己不要成為 PM"
```

## License

MIT. See file `LICENSE`.
