#lang lazy
(provide (all-defined-out))
(require "../../church.rkt"
         "../../core.rkt"
         "../../integers.rkt"
         "../../lists.rkt"
         "../../logic.rkt"
         "../../macros/macros.rkt"
         "../../macros/more-macros.rkt"
         "../../rationals.rkt"
         "INTEGERS.rkt"
         "LISTS.rkt"
         "TYPES.rkt"
         "../TYPES.rkt")

(def neg2-R = (make-rat ((makeR2 negTwo) one)))
(def neg1-2-R = (make-rat ((makeR2 negOne) two)))
(def neg1-3-R = (make-rat ((makeR2 negOne) three)))
(def neg1-4-R = (make-rat ((makeR2 negOne) four)))
(def neg1-5-R = (make-rat ((makeR2 negOne) five)))
(def neg0-R = (make-rat ((makeR2 negZero) one)))
(def pos0-R = (make-rat ((makeR2 posZero) one)))
(def pos1-5-R = (make-rat ((makeR2 posOne) five)))
(def pos1-4-R = (make-rat ((makeR2 posOne) four)))
(def pos1-3-R = (make-rat ((makeR2 posOne) three)))
(def pos1-2-R = (make-rat ((makeR2 posOne) two)))
(def pos2-R = (make-rat ((makeR2 posTwo) one)))


(def IS_ZEROr R = ((((COERCE-1 isZeroR) convert-to-rat) R) bool))

(def ADDr R1 R2 = (((((COERCE-2 addR) convert-to-rat) R1) R2) rat))

(def SUBr R1 R2 = (((((COERCE-2 subR) convert-to-rat) R1) R2) rat))

(def MULTr R1 R2 = (((((COERCE-2 multR) convert-to-rat) R1) R2) rat))

(def DIVr R1 R2 = (((((COERCE-2 divR) convert-to-rat) R1) R2) rat))

(def EQr R1 R2 = (((((COERCE-2 eqR) convert-to-rat) R1) R2) bool))

(def GTEr R1 R2 = (((((COERCE-2 gteR) convert-to-rat) R1) R2) bool))

(def GTr R1 R2 = (((((COERCE-2 gtR) convert-to-rat) R1) R2) bool))

(def LTEr R1 R2 = (((((COERCE-2 lteR) convert-to-rat) R1) R2) bool))

(def LTr R1 R2 = (((((COERCE-2 ltR) convert-to-rat) R1) R2) bool))

(def FLOORr R = ((((COERCE-1 floorR) convert-to-rat) R) rat))
