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

; just testing things out here 

(def l-0 = ((pair zero) nil))
(def l-5 = ((pair five) nil))
(def l-2 = ((pair two) nil))
(def l-3 = ((pair three) nil))

(def l-0-5-2-3 = ((app ((app ((app l-0) l-5)) l-2)) l-3))

(def LIST-0 = ((_make-list nat) l-0))

(def LIST-0-5-2-3 = ((_make-list nat) l-0-5-2-3))
(displayln (read-any LIST-0-5-2-3))

;===================================================

(def NIL-error = ((_make-list _error) nil))
(def NIL-bool = ((_make-list bool) nil))
(def NIL-nat = ((_make-list nat) nil))
(def NIL-int = ((_make-list int) nil))
(def NIL-list = ((_make-list _list) nil))

(def LEN L = (((((fully-type len) "LEN") _list) L) nat))

(displayln (read-any (LEN LIST-0-5-2-3)))
(displayln (read-any (LEN NIL-error)))
(displayln (read-any (LEN NIL-bool)))
(displayln (read-any (LEN NIL-nat)))
(displayln (read-any (LEN NIL-int)))
(displayln (read-any (LEN NIL-list)))


(def IS-NIL L = (((((fully-type isNil) "IS-NIL") _list) L) bool))

(displayln (read-any (IS-NIL NIL-bool)))
(displayln (read-any (IS-NIL LIST-0-5-2-3)))
(displayln (read-any (IS-NIL LIST-0)))

(def IND L i = (((((((fully-type2 ind) "IND") _list) L) nat) i) nat))

; (display (read-any ((IND LIST-0-5-2-3) ONE)))


(def APP L1 L2 = (((((((fully-type2 app) "APP") _list) L1) _list) L2) _list))

(displayln (read-any ((APP LIST-0-5-2-3) LIST-0)))


(def REV L = (((((fully-type rev) "REV") _list) L) _list))
(displayln (read-any (REV LIST-0-5-2-3)))