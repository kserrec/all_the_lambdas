#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(require "algorithms.rkt"
         "division.rkt"
         "integers.rkt"
         "lists.rkt"
         "logic.rkt"
         "church.rkt"
         "recursion.rkt")
(require "types/CHURCH.rkt"
         "types/INTEGERS.rkt"
         "types/LOGIC.rkt"
         "types/TYPES.rkt")

;===================================================

(display "NOT TABLE")
(display "\nnot(true): ")
(display (b-read (_not true)))
(newline)
(display "not(false): ")
(display (b-read (_not false)))
(newline)

(display "\nAND TABLE")
(display "\nand(true)(true): ")
(display (b-read ((_and true) true)))
(newline)
(display "and(true)(false): ")
(display (b-read ((_and true) false)))
(newline)
(display "and(false)(true): ")
(display (b-read ((_and false) true)))
(newline)
(display "and(false)(false): ")
(display (b-read ((_and false) false)))
(newline)

(display "\nOR TABLE")
(display "\nor(true)(true): ")
(display (b-read ((_or true) true)))
(newline)
(display "or(true)(false): ")
(display (b-read ((_or true) false)))
(newline)
(display "or(false)(true): ")
(display (b-read ((_or false) true)))
(newline)
(display "or(false)(false): ")
(display (b-read ((_or false) false)))
(newline)

(display "\nXOR TABLE")
(display "\nxor(true)(true): ")
(display (b-read ((xor true) true)))
(newline)
(display "xor(true)(false): ")
(display (b-read ((xor true) false)))
(newline)
(display "xor(false)(true): ")
(display (b-read ((xor false) true)))
(newline)
(display "xor(false)(false): ")
(display (b-read ((xor false) false)))
(newline)

(display "\nNOR TABLE")
(display "\nnor(true)(true): ")
(display (b-read ((nor true) true)))
(newline)
(display "nor(true)(false): ")
(display (b-read ((nor true) false)))
(newline)
(display "nor(false)(true): ")
(display (b-read ((nor false) true)))
(newline)
(display "nor(false)(false): ")
(display (b-read ((nor false) false)))
(newline)

(display "\nNAND TABLE")
(display "\nnand(true)(true): ")
(display (b-read ((nand true) true)))
(newline)
(display "nand(true)(false): ")
(display (b-read ((nand true) false)))
(newline)
(display "nand(false)(true): ")
(display (b-read ((nand false) true)))
(newline)
(display "nand(false)(false): ")
(display (b-read ((nand false) false)))
(newline)


; (display "\nif(isZero(0))(1)(2)): ")
; (define if-isZero0-1-2 (((_if (isZero zero)) one) two))
; (display (n-read if-isZero0-1-2))
; (newline)

; (display "\nif(isZero(1))(1)(2)): ")
; (define if-isZero1-1-2 (((_if (isZero one)) one) two))
; (display (n-read if-isZero1-1-2))
; (newline)

;===================================================

(display "\nzero: ")
(display (n-read zero))
(newline)
(display "\nsucc(0): ")
(display (n-read one))
(newline)
(display "\nsucc(1): ")
(display (n-read two))
(newline)
(display "\nsucc(2): ")
(display (n-read three))
(newline)

(display "\nadd(2)(3): ")
(display (n-read five))
(newline)

(display "\nmult(5)(5): ")
(define twenty-five ((mult five) five))
(display (n-read twenty-five))
(newline)

(display "\nexp(5)(3): ")
(define one-twenty-five ((exp five) three))
(display (n-read one-twenty-five))
(newline)

(display "\npred(0): ")
(define pred0 (pred zero))
(display (n-read pred0))
(newline)

(display "\npred(1): ")
(define pred1 (pred one))
(display (n-read pred1))
(newline)

(display "\npred(3): ")
(define pred3 (pred three))
(display (n-read pred3))
(newline)

(display "\npred(5): ")
(define pred5 (pred five))
(display (n-read pred5))
(newline)

(display "\npred(125): ")
(define pred125 (pred one-twenty-five))
(display (n-read pred125))
(newline)

(display "\nsub(125)(5): ")
(define sub_125_5 ((sub one-twenty-five) five))
(display (n-read sub_125_5))
(newline)

(display "\nsub(5)(3): ")
(define sub_5_3 ((sub five) three))
(display (n-read sub_5_3))
(newline)

;===================================================

(display "\nisZero(0): ")
(define isZero0 (isZero zero))
(display (b-read isZero0))
(newline)

(display "\nisZero(1): ")
(define isZero1 (isZero one))
(display (b-read isZero1))
(newline)

(display "\nisZero(2): ")
(define isZero2 (isZero two))
(display (b-read isZero2))
(newline)

(display "\nisZero(125): ")
(define isZero125 (isZero one-twenty-five))
(display (b-read isZero125))
(newline)

(display "\ngte(5,2): ")
(display (b-read ((gte five) two)))
(newline)
(display "gte(3,2): ")
(display (b-read ((gte three) two)))
(newline)
(display "gte(2,2): ")
(display (b-read ((gte two) two)))
(newline)
(display "gte(2,5): ")
(display (b-read ((gte two) five)))
(newline)

(display "\nlte(5,2): ")
(display (b-read ((lte five) two)))
(newline)
(display "lte(3,2): ")
(display (b-read ((lte three) two)))
(newline)
(display "lte(2,2): ")
(display (b-read ((lte two) two)))
(newline)
(display "lte(2,5): ")
(display (b-read ((lte two) five)))
(newline)

(display "\nlt(5,2): ")
(display (b-read ((lt five) two)))
(newline)
(display "lt(3,2): ")
(display (b-read ((lt three) two)))
(newline)
(display "lt(2,2): ")
(display (b-read ((lt two) two)))
(newline)
(display "lt(2,5): ")
(display (b-read ((lt two) five)))
(newline)

(display "\neq(5,2): ")
(display (b-read ((eq five) two)))
(newline)
(display "eq(3,2): ")
(display (b-read ((eq three) two)))
(newline)
(display "eq(2,2): ")
(display (b-read ((eq two) two)))
(newline)
(display "eq(2,5): ")
(display (b-read ((eq two) five)))
(newline)

;===================================================

(display "\nFACTORIAL")
(display "\nfact(0): ")
(define fact0 (fact zero))
(display (n-read fact0))
(newline)

(display "fact(1): ")
(define fact1 (fact one))
(display (n-read fact1))
(newline)

(display "fact(2): ")
(define fact2 (fact two))
(display (n-read fact2))
(newline)

(display "fact(3): ")
(define fact3 (fact three))
(display (n-read fact3))
(newline)

(display "fact(4): ")
(define fact4 (fact four))
(display (n-read fact4))
(newline)

(display "fact(5): ")
(define fact5 (fact five))
(display (n-read fact5))
(newline)

;===================================================

(display "\nFIBONACCI")
(display "\nfib(0): ")
(define fib0 (fib zero))
(display (n-read fib0))
(newline)

(display "fib(1): ")
(define fib1 (fib one))
(display (n-read fib1))
(newline)

(display "fib(2): ")
(define fib2 (fib two))
(display (n-read fib2))
(newline)

(display "fib(3): ")
(define fib3 (fib three))
(display (n-read fib3))
(newline)

(display "fib(4): ")
(define fib4 (fib four))
(display (n-read fib4))
(newline)

(display "fib(5): ")
(define fib5 (fib five))
(display (n-read fib5))
(newline)

(display "fib(6): ")
(define fib6 (fib (succ five)))
(display (n-read fib6))
(newline)

(display "fib(7): ")
(define fib7 (fib (succ (succ five))))
(display (n-read fib7))
(newline)

;===================================================

(display "\nN-SUM")
(display "\nnSum(0): ")
(define nSum0 (nSum zero))
(display (n-read nSum0))
(newline)

(display "nSum(1): ")
(define nSum1 (nSum one))
(display (n-read nSum1))
(newline)

(display "nSum(2): ")
(define nSum2 (nSum two))
(display (n-read nSum2))
(newline)

(display "nSum(3): ")
(define nSum3 (nSum three))
(display (n-read nSum3))
(newline)

(display "nSum(4): ")
(define nSum4 (nSum four))
(display (n-read nSum4))
(newline)

(display "nSum(5): ")
(define nSum5 (nSum five))
(display (n-read nSum5))
(newline)

(display "nSum(125): ")
(define nSum125 (nSum one-twenty-five))
(display (n-read nSum125))
(newline)

;===================================================

(display "div(6)(2): ")
(define div_6_2 ((div (succ five)) two))
(display (n-read div_6_2))
(newline)

(display "div(5)(2): ")
(define div_5_2 ((div five) two))
(display (n-read div_5_2))
(newline)

(display "div(7)(2): ")
(define div_7_2 ((div (succ (succ five))) two))
(display (n-read div_7_2))
(newline)

(display "div(8)(2): ")
(define div_8_2 ((div (succ (succ (succ five)))) two))
(display (n-read div_8_2))
(newline)

(display "div(125)(5): ")
(define div_125_5 ((div one-twenty-five) five))
(display (n-read div_125_5))
(newline)

(display "div(4)(5): ")
(define div_4_5 ((div four) five))
(display (n-read div_4_5))
(newline)


(define l_4_5_125 ((pair four) ((twolist five) one-twenty-five)))
(define l_one_two ((twolist one) two))
(define l_1_2_4_5_125 ((app l_one_two) l_4_5_125))
(display "[1,2,4,5,125]: ")
(display ((l-read l_1_2_4_5_125) n-read))
(newline)
(display "l_1_2_4_5_125 ind of 1: ")
(display (n-read ((binarySearch l_1_2_4_5_125) one)))
(newline)
(display "l_1_2_4_5_125 ind of 2: ")
(display (n-read ((binarySearch l_1_2_4_5_125) two)))
(newline)
(display "l_1_2_4_5_125 ind of 4: ")
(display (n-read ((binarySearch l_1_2_4_5_125) four)))
(newline)
(display "l_1_2_4_5_125 ind of 5: ")
(display (n-read ((binarySearch l_1_2_4_5_125) five)))
(newline)
(display "l_1_2_4_5_125 ind of 125: ")
(display (n-read ((binarySearch l_1_2_4_5_125) one-twenty-five)))
(newline)
(display "l_1_2_4_5_125 ind of 3: ")
(display (n-read ((binarySearch l_1_2_4_5_125) three)))
(newline)

;================================================
; (display (n-read (_cond true ? two : three)))
; (newline)

(display (n-read (_if true _then two _else three)))
(newline)

(display "B-READ(TRUE): ")
(display (B-READ TRUE))
(newline)

(display "B-READ(FALSE): ")
(display (B-READ FALSE))
(newline)

(display "B-READ(TWO): ")
(display (B-READ TWO))
(newline)

(display "N-READ(TWO): ")
(display (N-READ TWO))
(newline)

(define ONE-TWENTY-FIVE (makeNat one-twenty-five))
(display "N-READ(125): ")
(display (N-READ ONE-TWENTY-FIVE))
(newline)

(display "B-READ(IS_ZERO(ZERO)): ")
(display (B-READ (IS_ZERO ZERO)))
(newline)

(display "B-READ(IS_ZERO(ONE)): ")
(display (B-READ (IS_ZERO ONE)))
(newline)

(display "B-READ(IS_ZERO(TWO)): ")
(display (B-READ (IS_ZERO TWO)))
(newline)

(display "B-READ(IS_ZERO(FALSE)): ")
(display (B-READ (IS_ZERO FALSE)))
(newline)

(display "B-READ(IS_ZERO(BOOL_ERROR)): ")
(display (B-READ (IS_ZERO BOOL_ERROR)))
(newline)

(display "B-READ(AND(TRUE)(TRUE)): ")
(display (B-READ ((AND TRUE) TRUE)))
(newline)

(display "B-READ(AND(TRUE)(FALSE)): ")
(display (B-READ ((AND TRUE) FALSE)))
(newline)

(display "B-READ(AND(FALSE)(TRUE)): ")
(display (B-READ ((AND FALSE) TRUE)))
(newline)

(display "B-READ(AND(FALSE)(FALSE)): ")
(display (B-READ ((AND FALSE) FALSE)))
(newline)

(display "B-READ(AND(TRUE)(BOOL_ERROR)): ")
(display (B-READ ((AND TRUE) BOOL_ERROR)))
(newline)

(display "B-READ(AND(TRUE)(TWO)): ")
(display (B-READ ((AND TRUE) TWO)))
(newline)

(display "B-READ(AND(TWO)(TRUE)): ")
(display (B-READ ((AND TWO) TRUE)))
(newline)

(display "B-READ(AND(IS_ZERO(FALSE))(TRUE)): ")
(display (B-READ ((AND (IS_ZERO FALSE)) TRUE)))
(newline)

(display "B-READ(AND(TRUE)(IS_ZERO(FALSE))): ")
(display (B-READ ((AND TRUE) (IS_ZERO FALSE))))
(newline)

(display "B-READ(NOT(TRUE)): ")
(display (B-READ (NOT TRUE)))
(newline)

(display "B-READ(NOT(FALSE)): ")
(display (B-READ (NOT FALSE)))
(newline)

(display "B-READ (NOT(TWO)): ")
(display (B-READ (NOT TWO)))
(newline)

(display "B-READ (NOT(IS_ZERO(ZERO))): ")
(display (B-READ (NOT (IS_ZERO ZERO))))
(newline)

(display "B-READ (NOT(IS_ZERO(TWO))): ")
(display (B-READ (NOT (IS_ZERO TWO))))
(newline)

(display "B-READ (NOT(IS_ZERO(FALSE))): ")
(display (B-READ (NOT (IS_ZERO FALSE))))
(newline)

(display "B-READ (NOT(IS_ZERO(NOT(TWO)))): ")
(display (B-READ (NOT (IS_ZERO (NOT TWO)))))
(newline)

; ===================================================

(display "N-READ SUCC(TWO): ")
(display (N-READ (SUCC TWO)))
(newline)

(display "N-READ SUCC(ONE-TWENTY-FIVE): ")
(display (N-READ (SUCC ONE-TWENTY-FIVE)))
(newline)

(display "N-READ SUCC(FALSE): ")
(display (N-READ (SUCC FALSE)))
(newline)

(display "N-READ SUCC(BOOL_ERROR): ")
(display (N-READ (SUCC BOOL_ERROR)))
(newline)

; ===================================================

(display "ADD(TWO)(THREE): ")
(display (N-READ ((ADD TWO) THREE)))
(newline)

(display "ADD(ONE-TWENTY-FIVE)(ONE-TWENTY-FIVE): ")
(display (N-READ ((ADD ONE-TWENTY-FIVE) ONE-TWENTY-FIVE)))
(newline)

(display "ADD(FALSE)(TWO): ")
(display (N-READ ((ADD FALSE) TWO)))
(newline)

(display "ADD(ONE)(TRUE): ")
(display (N-READ ((ADD ONE) TRUE)))
(newline)

(display "ADD(BOOL_ERROR)(TWO): ")
(display (N-READ ((ADD BOOL_ERROR) TWO)))
(newline)


; ===================================================

(display "MULT(TWO)(THREE): ")
(display (N-READ ((MULT TWO) THREE)))
(newline)

(display "MULT(ONE-TWENTY-FIVE)(ONE-TWENTY-FIVE): ")
(display (N-READ ((MULT ONE-TWENTY-FIVE) ONE-TWENTY-FIVE)))
(newline)

(display "MULT(FALSE)(TWO): ")
(display (N-READ ((MULT FALSE) TWO)))
(newline)

(display "MULT(ONE)(TRUE): ")
(display (N-READ ((MULT ONE) TRUE)))
(newline)

(display "MULT(BOOL_ERROR)(TWO): ")
(display (N-READ ((MULT BOOL_ERROR) TWO)))
(newline)

; ===================================================

(display "EXP(TWO)(THREE): ")
(display (N-READ ((EXP TWO) THREE)))
(newline)

(display "EXP(ONE-TWENTY-FIVE)(TWO): ")
(display (N-READ ((EXP ONE-TWENTY-FIVE) TWO)))
(newline)

(display "EXP(FALSE)(TWO): ")
(display (N-READ ((EXP FALSE) TWO)))
(newline)

(display "EXP(ONE)(TRUE): ")
(display (N-READ ((EXP ONE) TRUE)))
(newline)

(display "EXP(BOOL_ERROR)(TWO): ")
(display (N-READ ((EXP BOOL_ERROR) TWO)))
(newline)

; ===================================================

(display "PRED(ZERO): ")
(display (N-READ (PRED ZERO)))
(newline)

(display "PRED(ONE): ")
(display (N-READ (PRED ONE)))
(newline)

(display "PRED(TWO): ")
(display (N-READ (PRED TWO)))
(newline)

(display "PRED(ONE-TWENTY-FIVE): ")
(display (N-READ (PRED ONE-TWENTY-FIVE)))
(newline)

(display "PRED(FALSE): ")
(display (N-READ (PRED FALSE)))
(newline)

(display "PRED(BOOL_ERROR): ")
(display (N-READ (PRED BOOL_ERROR)))
(newline)


; ===================================================

(display "SUB(FIVE)(TWO): ")
(display (N-READ ((SUB FIVE) TWO)))
(newline)

(display "SUB(ONE-TWENTY-FIVE)(PRED(ONE-TWENTY-FIVE)): ")
(display (N-READ ((SUB ONE-TWENTY-FIVE) (PRED ONE-TWENTY-FIVE))))
(newline)

(display "SUB(ONE-TWENTY-FIVE)(FOUR): ")
(display (N-READ ((SUB ONE-TWENTY-FIVE) FOUR)))
(newline)

(display "SUB(ONE)(TRUE): ")
(display (N-READ ((SUB ONE) TRUE)))
(newline)

(display "SUB(BOOL_ERROR)(TWO): ")
(display (N-READ ((SUB BOOL_ERROR) TWO)))
(newline)

; ===================================================

(display "SUCCz(ZEROz): ")
(display (Z-READ (SUCCz ZEROz)))
(newline)

(display "SUCCz(ONEz): ")
(display (Z-READ (SUCCz ONEz)))
(newline)

(display "SUCCz(TWOz): ")
(display (Z-READ (SUCCz TWOz)))
(newline)

(display "SUCCz(THREEz): ")
(display (Z-READ (SUCCz THREEz)))
(newline)

(display "SUCCz(FOURz): ")
(display (Z-READ (SUCCz FOURz)))
(newline)

(display "SUCCz(FIVEz): ")
(display (Z-READ (SUCCz FIVEz)))
(newline)


; ===================================================

(display "ADDz(TWOz)(THREEz): ")
(display (Z-READ ((ADDz TWOz) THREEz)))
(newline)

(def ONE-TWENTY-FIVEz = ((newInt true) one-twenty-five))
(display "ADDz(ONE-TWENTY-FIVE)(ONE-TWENTY-FIVE): ")
(display (Z-READ ((ADDz ONE-TWENTY-FIVEz) ONE-TWENTY-FIVEz)))
(newline)

(display "ADDz(FALSE)(TWO): ")
(display (Z-READ ((ADDz FALSE) TWOz)))
(newline)

(display "ADDz(ONE)(TRUE): ")
(display (Z-READ ((ADDz ONEz) TRUE)))
(newline)

(display "ADDz(BOOL_ERROR)(TWO): ")
(display (Z-READ ((ADDz BOOL_ERROR) TWOz)))
(newline)
; ===================================================

(display "SUBz(TWOz)(THREEz): ")
(display (Z-READ ((SUBz TWOz) THREEz)))
(newline)

(display "SUBz(THREEz)(TWOz): ")
(display (Z-READ ((SUBz THREEz) TWOz)))
(newline)

(display "SUBz(ONE-TWENTY-FIVE)(ONE-TWENTY-FIVE): ")
(display (Z-READ ((SUBz ONE-TWENTY-FIVEz) ONE-TWENTY-FIVEz)))
(newline)

(display "SUBz(FALSE)(TWO): ")
(display (Z-READ ((SUBz FALSE) TWOz)))
(newline)

(display "SUBz(ONE)(TRUE): ")
(display (Z-READ ((SUBz ONEz) TRUE)))
(newline)

(display "SUBz(BOOL_ERROR)(TWO): ")
(display (Z-READ ((SUBz BOOL_ERROR) TWOz)))
(newline)

; ===================================================

(display "MULTz(TWOz)(THREEz): ")
(display (Z-READ ((MULTz TWOz) THREEz)))
(newline)

(def negTHREEz = ((newInt false) three))
(display "MULTz(negTHREEz)(TWOz): ")
(display (Z-READ ((MULTz negTHREEz) TWOz)))
(newline)

(display "MULTz(ONE-TWENTY-FIVE)(ONE-TWENTY-FIVE): ")
(display (Z-READ ((MULTz ONE-TWENTY-FIVEz) ONE-TWENTY-FIVEz)))
(newline)

(display "MULTz(FALSE)(TWO): ")
(display (Z-READ ((MULTz FALSE) TWOz)))
(newline)

(display "MULTz(ONE)(TRUE): ")
(display (Z-READ ((MULTz ONEz) TRUE)))
(newline)

(display "MULTz(BOOL_ERROR)(TWO): ")
(display (Z-READ ((MULTz BOOL_ERROR) TWOz)))
(newline)


; ===================================================

(display "DIVz(TWOz)(THREEz): ")
(display (Z-READ ((DIVz TWOz) THREEz)))
(newline)

(display "DIVz(negTHREEz)(TWOz): ")
(display (Z-READ ((DIVz negTHREEz) TWOz)))
(newline)

(def negTWOz = ((newInt false) two))
(display "DIVz(MULTz(FOUR)(FIVE))(TWOz): ")
(display (Z-READ ((DIVz ((MULTz FOURz) FIVEz)) negTWOz)))
(newline)

(display "DIVz(ONE-TWENTY-FIVE)(ONE-TWENTY-FIVE): ")
(display (Z-READ ((DIVz ONE-TWENTY-FIVEz) ONE-TWENTY-FIVEz)))
(newline)

(display "DIVz(FALSE)(TWO): ")
(display (Z-READ ((DIVz FALSE) TWOz)))
(newline)

(display "DIVz(ONE)(TRUE): ")
(display (Z-READ ((DIVz ONEz) TRUE)))
(newline)

(display "DIVz(BOOL_ERROR)(TWO): ")
(display (Z-READ ((DIVz BOOL_ERROR) TWOz)))
(newline)

; ===================================================

(display "mod(four)(two): ")
(display (n-read ((mod four) two)))
(newline)

(display "mod(five)(two): ")
(display (n-read ((mod five) two)))
(newline)

(display "mod(mult(four)(five))(three): ")
(display (n-read ((mod ((mult four) five)) three)))
(newline)

(display "mod(one-twenty-five)(one-twenty-five): ")
(display (n-read ((mod one-twenty-five) one-twenty-five)))
(newline)

(display "mod(two)(five): ")
(display (n-read ((mod two) five)))
(newline)
