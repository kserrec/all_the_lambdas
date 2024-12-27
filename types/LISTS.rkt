#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../macros/macros.rkt")
(require "CHURCH.rkt"
         "INTEGERS.rkt"
         "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

(def l-0 = ((pair zero) nil))
(def l-5 = ((pair five) nil))
(def l-2 = ((pair two) nil))
(def l-3 = ((pair three) nil))

(def l-0-5-2-3 = ((app ((app ((app l-0) l-5)) l-2)) l-3))
(displayln ((l-read l-0-5-2-3) n-read))

(def list-0-5-2-3 = ((_make-list nat) l-0-5-2-3))
(displayln (read-list list-0-5-2-3))