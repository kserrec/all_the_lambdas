#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "logic.rkt"
         "church.rkt"
         "core.rkt"
         "lists.rkt"
         "recursion.rkt")

; setup
(def six = (succ five))
(def seven = (succ six))
(def ten = ((mult two) five))
(def eleven = ((add one) ten))
(def nine-nine-nine = (pred ((_exp ten) three)))

(def a = zero)
(def b = one)
(def c = two)
(def d = three)
(def e = four)
(def f = five)
(def g = six)

; denotational semantics
(displayln "semantics!")
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
(displayln "queue!")
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

(displayln (n-read (head ((q4 a) nine-nine-nine)))) ; 1
(displayln (n-read (head ((q4 b) nine-nine-nine)))) ; 2
(displayln (n-read (head ((q4 c) nine-nine-nine)))) ; 3

; ordered
(displayln "ordered!")
(def oUpdate _rest key value = ((((Y _oUpdate) _rest) key) value))

(def _oUpdate f _rest key value = 
    (lambda (k) (lambda (v)
    (_let rec-oUpdate = (((f _rest) key) value)
    (_if ((eq k) key)
        _then ((pair value) rec-oUpdate)
        _else (_if ((lt k) key)
                _then (_let rec-2-oUpdate = (((f rec-oUpdate) k) v)
                    ((pair v) rec-2-oUpdate))
                _else (_let rest-k-v = ((_rest k) v)
                    (((oChange rest-k-v) key) value))))))))

(def oChange new-value-new-rest key value = 
    (_let newvalue = (head new-value-new-rest)
    (_let newrest = (tail new-value-new-rest)
    ((pair newvalue) (((oUpdate newrest) key) value)))))

(def oExtend key value = (((Y _oExtend) key) value))

(def _oExtend f key value = 
    ((pair value) (((oUpdate f) key) value)))


(def uUpdate _rest key value = (((Y _rest) key) value))

(def _uUpdate f _rest key value = 
    (lambda (mode) (lambda (k) (lambda (v) (
        _if (mode)
         _then (_let rec-uUpdate = (((f _rest) key) value)
            ((pair value) rec-uUpdate))
         _else (_if ((eq k) key)
                _then ((pair v) (((f _rest) key) v))
                _else (_let rest-mode-k-v = (((_rest mode) k) v)
                    (((uChange rest-mode-k-v) key) value))))))))

(def uChange new-value-new-rest key value = 
    (_let newvalue = (head new-value-new-rest)
    (_let newrest = (tail new-value-new-rest)
    ((pair newvalue) (((uUpdate newrest) key) value)))))

(def uExtend key value = (((Y _uExtend) key) value))

(def _uExtend f key value = 
    ((pair value) (((uUpdate f) key) value)))


(def v1-o1 = ((oExtend a) one))
(def o1 = (tail v1-o1))

(def v2-o2 = ((o1 c) three))
(def o2 = (tail v2-o2))

(def v3-o3 = ((o2 b) two))
(def o3 = (tail v3-o3))

(displayln (n-read (head ((o3 a) nine-nine-nine)))) ; 1
(displayln (n-read (head ((o3 b) nine-nine-nine)))) ; 2
(displayln (n-read (head ((o3 c) nine-nine-nine)))) ; 3

; tree
(displayln "tree!")
(def tUpdate left right key value = 
    (((((Y _tUpdate) left) right) key) value))

(def _tUpdate f left right key value = 
    (lambda (k) (lambda (v) 
    (_if ((eq k) key)
        _then (_let rec-tUpdate = ((((f left) right) key) value)
            ((pair value) rec-tUpdate))
        _else (_if ((lt k) key)
                _then (_let left-k-v = ((left k) v)
                    ((((lChange left-k-v) right) key) value))
                _else (_let right-k-v = ((right k) v)
                    ((((rChange right-k-v) left) key) value)))))))

(def lChange new-value-new-left right key value = 
    (_let newvalue = (head new-value-new-left)
    (_let newleft = (tail new-value-new-left)
    ((pair newvalue) ((((tUpdate newleft) right) key) value)))))

(def rChange new-value-new-right left key value = 
    (_let newvalue = (head new-value-new-right)
    (_let newright = (tail new-value-new-right)
    ((pair newvalue) ((((tUpdate left) newright) key) value)))))

(def tExtend k v = (((Y _tExtend) k) v))

(def _tExtend f k v = 
    ((pair v) ((((tUpdate f) f) k) v)))


(def v1-t1 = ((tExtend d) four))
(def t1 = (tail v1-t1))

(def v2-t2 = ((t1 b) two))
(def t2 = (tail v2-t2))

(def v3-t3 = ((t2 a) one))
(def t3 = (tail v3-t3))

(def v4-t4 = ((t3 c) three))
(def t4 = (tail v4-t4))

(def v5-t5 = ((t4 f) six))
(def t5 = (tail v5-t5))

(def v6-t6 = ((t5 e) five))
(def t6 = (tail v6-t6))

(def v7-t7 = ((t6 g) seven))
(def t7 = (tail v7-t7))


(displayln (n-read (head ((t7 a) nine-nine-nine)))) ; 1
(displayln (n-read (head ((t7 b) nine-nine-nine)))) ; 2
(displayln (n-read (head ((t7 c) nine-nine-nine)))) ; 3
(displayln (n-read (head ((t7 d) nine-nine-nine)))) ; 4
(displayln (n-read (head ((t7 e) nine-nine-nine)))) ; 5
(displayln (n-read (head ((t7 f) nine-nine-nine)))) ; 6
(displayln (n-read (head ((t7 g) nine-nine-nine)))) ; 7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

()