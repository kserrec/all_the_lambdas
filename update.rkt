#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "logic.rkt"
         "church.rkt"
         "core.rkt"
         "lists.rkt"
         "recursion.rkt")

; setup
(def a = zero)
(def b = one)
(def c = two)
(def ten = ((mult two) five))
(def eleven = ((add one) ten))
(def nine-nine-nine = (pred ((_exp ten) three)))

; denotational semantics
(def _identity x = x)

(def update f i v = 
    (lambda (id)
        (_if ((eq id) i) _then v _else (f id))))

(def m1 = (((update _identity) a) one))
(def m2 = (((update m1) b) two))
(def m3 = (((update m2) c) three))
(def m4 = (((update m3) a) eleven))

(displayln (n-read (m4 a))) ; 11
(displayln (n-read (m4 b)))  ; 2
(displayln (n-read (m4 c)))  ; 3

; queue
(def qUpdate _rest key value = ((((Y _qUpdate) _rest) key) value))

(def _qUpdate f _rest key value =
    (lambda (k) (lambda (v)
        (_if ((eq k) key)
            _then (_let rec-qUpdate = (((f _rest) key) value)
                  ((pair value) rec-qUpdate))
            _else (_let rest-k-v = ((_rest k) v)
                (((qChange rest-k-v) key) value))))))

(def qChange new-value-new-rest key value = 
    (_let newvalue = (head new-value-new-rest)
    (_let newrest = (tail new-value-new-rest)
    ((pair newvalue) (((qUpdate newrest) key) value)))))

(def qExtend key value = (((Y _qExtend) key) value))

(def _qExtend f key value = ((pair value) (((qUpdate f) key) value)))


(def v1-q1 = ((qExtend a) one))
(def q1 = (tail v1-q1))

(def v2-q2 = ((q1 b) two))
(def q2 = (tail v2-q2))

(def v3-q3 = ((q2 c) three))
(def q3 = (tail v3-q3))

(def v4-q4 = ((q3 a) eleven))
(def q4 = (tail v4-q4))


(def q4-a-999 = ((q4 a) nine-nine-nine))
(display (string-append (n-read (head q4-a-999)) ", "))  
(displayln (tail q4-a-999)) ; 1, #<procedure:..._lambdas/update.rkt:38:4>

(def q4-b-999 = ((q4 b) nine-nine-nine))
(display (string-append (n-read (head q4-b-999)) ", ")) 
(displayln (tail q4-b-999)) ; 2, #<procedure:..._lambdas/update.rkt:38:4>

(def q4-c-999 = ((q4 c) nine-nine-nine))
(display (string-append (n-read (head q4-c-999)) ", "))
(displayln (tail q4-c-999)) ; 3, #<procedure:..._lambdas/update.rkt:38:4>
