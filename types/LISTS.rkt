#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../macros/macros.rkt"
         "../recursion.rkt")
(require "CHURCH.rkt"
         "INTEGERS.rkt"
         "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

; helper functions

(def un-type obj = (val obj))

(def un-type-els L = ((make-obj _list) ((_map un-type) (un-type L))))

;===================================================

; just testing things out here 

(def l-0 = ((pair zero) nil))
(def l-5 = ((pair five) nil))
(def l-2 = ((pair two) nil))
(def l-3 = ((pair three) nil))


(def l-0-5-2-3 = ((app ((app ((app l-0) l-5)) l-2)) l-3))
(def l-5-5-2-3 = ((app ((app ((app l-5) l-5)) l-2)) l-3))


(def l-p2 = ((pair posTwo) nil))
(def l-n3 = ((pair negThree) nil))
(def l-p4 = ((pair posFour) nil))

(def l-p4-n3-p4-p2 = ((app ((app ((app l-p4) l-n3)) l-p4)) l-p2))

; (displayln (z-read (head l-p4-n3-p4-p2)))

; (displayln ((l-read l-p4-n3-p4-p2) z-read))

(def LIST-0 = ((_make-list nat) l-0))

(def LIST-5 = ((_make-list nat) l-5))

(def LIST-0-5-2-3 = ((_make-list nat) l-0-5-2-3))
(def LIST-5-5-2-3 = ((_make-list nat) l-5-5-2-3))
(def LIST-p4-n3-p4-p2 = ((_make-list int) l-p4-n3-p4-p2))


; (displayln (read-any LIST-0-5-2-3))
; (displayln (read-any LIST-5-5-2-3))
; (displayln (read-any LIST-p4-n3-p4-p2))


#|
    De-Abstractify list of lists

    list:list[
        list:nat[0,5,2,3],
        list:nat[5,5,2,3]
    ]
    ==
    [
        list:nat[0,5,2,3],
        list:nat[5,5,2,3]
    ]
    ==
    {
        ; type - "_list" (four),
        ; val  - {
                    list:nat[0,5,2,3],
                    list:nat[5,5,2,3]
                 }
    }
    ==
    {
        ; type - "_list" (four),
        ; val  - {
                    {
                        ; type - "_list" (four),
                        ; val  - [nat:0,nat:5,nat:2,nat:3]
                    },
                    {
                        {   
                            ; type - "_list" (four),
                            ; val  - [nat:0,nat:5,nat:2,nat:3]
                        },
                        NIl-list
                    }
    }


|#


;===================================================

; TYPED NILs
(def make-NIL type = ((pair type) false))

(def NIL-error = (make-NIL _error))
(def NIL-bool = (make-NIL bool))
(def NIL-nat = (make-NIL nat))
(def NIL-int = (make-NIL int))
(def NIL-list = (make-NIL _list))

;===================================================

(def LEN L = (((((fully-type len) "LEN") _list) L) nat))

;===================================================

(def IS-NIL L = (((((fully-type isNil) "IS-NIL") _list) L) bool))

;===================================================

; have to use un-type-els because fully-type-f adds types to elements so sub elements cannot go in already typed
(def IND L I = (((((((fully-type2 ind) "IND") _list) (un-type-els L)) nat) I) nat))

;===================================================

(def APP L1 L2 = (((((((fully-type2 app) "APP") _list) L1) _list) L2) _list))

;===================================================

(def REV L = (((((fully-type rev) "REV") _list) L) _list))

;===================================================

(def MAP G L = (((((((fully-type2 _map) "MAP") bool) ((make-obj bool) G)) _list) L) _list))

;===================================================

(def _filter-helper-typed g lst = ((((Y filter-helper-typed) g) lst) nil))

(def filter-helper-typed f g lst n = 
    ((lst (lambda (x)
                (lambda (y)
                    (lambda (z)
                        (_if (val (g x))
                            _then ((pair x) (((f g) y) n))
                            _else (((f g) y) n)
                        )
                    )
                )  
            ))  n))

(def FILTER G L = (((((((fully-type2 _filter-helper-typed) "FILTER") bool) ((make-obj bool) G)) _list) L) _list))

;===================================================

(define _fold-helper-typed (Y fold-helper-typed))

(def fold-helper-typed f g i lst = 
    (_if ((eq zero) (len lst))
        _then i
        _else ((lst (lambda (x)
                    (lambda (y)
                        (lambda (z)
                            ((g x) (((f g) i) y))
                        )
                    )
                ))  i)
    )
)

(def FOLD G X L = (((((((((fully-type3 _fold) "FOLD") bool) ((make-obj bool) G)) (type X)) X) _list) (un-type-els L)) (type X)))



(displayln (read-any (((FOLD add) FIVE) LIST-0-5-2-3)))

(displayln (read-any (((FOLD mult) ONE) LIST-5-5-2-3)))

(displayln (read-any (((FOLD multZ) posONE) LIST-p4-n3-p4-p2)))


; (displayln (read-any LIST-p4-n3-p4-p2))

(def LIST-OF-LIST = ((pair LIST-0-5-2-3) NIL-list))


(def LIST-OF-LISTS = ((pair LIST-5-5-2-3) LIST-OF-LIST))
(def LOL = ((make-obj _list) LIST-OF-LISTS))

(displayln (read-any ((ind LIST-OF-LISTS) one)))

; (displayln (read-any ((IND LOL) ONE)))

; (displayln (read-any (((_fold app) LIST-OF-LISTS) NIL-list)))

; (displayln "read NIL list")
; (displayln (read-any NIL-list))

; (displayln "read LIST OF LIST")
; (displayln (read-any LIST-OF-LIST))

;===================================================

(def TAKE N L = (((((((fully-type2 _take) "TAKE") nat) N) _list) L) _list))

(displayln (read-any ((TAKE TWO) LIST-5-5-2-3)))


(def TAKE-TAIL N L = (((((((fully-type2 takeTail) "TAKE-TAIL") nat) N) _list) L) _list))


(displayln (read-any ((TAKE-TAIL TWO) LIST-5-5-2-3)))

;===================================================

; "fully-type" function returns falsely typed list by just tagging with a _list type, but it doesn't have typed elements so this extra wrapping with _make-list is needed
(def INSERT X L I = ((_make-list (type X)) (val (((((((((fully-type3 insert) "INSERT") (type X)) X) _list) (un-type-els L)) nat) I) _list))))

; (displayln "insert test")
; (def inserted-LIST-5523 = (((INSERT FOUR) LIST-5-5-2-3) TWO))
; (displayln (read-any inserted-LIST-5523))
; (displayln (n-read (type inserted-LIST-5523)))
; (displayln (n-read (type (val inserted-LIST-5523))))


(def REPLACE X L I = ((_make-list (type X)) (val (((((((((fully-type3 replace) "REPLACE") (type X)) X) _list) (un-type-els L)) nat) I) _list))))

(displayln "replace test")
(def replaced-LIST-5523 = (((REPLACE FOUR) LIST-5-5-2-3) TWO))
(displayln (read-any replaced-LIST-5523))
; (displayln (n-read (type inserted-LIST-5523)))
; (displayln (n-read (type (val replaced-LIST-5523))))


(def DROP N L = (((((((fully-type2 _drop) "DROP") nat) N) _list) L) _list))

(displayln "drop test")
(displayln (read-any ((DROP ONE) LIST-5-5-2-3)))