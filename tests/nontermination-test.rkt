#lang racket

(require racket/port
         racket/runtime-path
         racket/string)

; This is host-level test infrastructure. Each expression runs in a fresh Lazy
; Racket process so an intentionally divergent term cannot hang the test runner.

(define-runtime-path project-root "..")

(define deadline-seconds 10.0)
(define racket-executable (find-executable-path "racket"))

(struct probe-case (label expression expectation expected-output) #:transparent)
(struct probe-completed (status stdout stderr elapsed-seconds) #:transparent)
(struct probe-timed-out (stdout stderr elapsed-seconds) #:transparent)
(struct probe-harness-failure (message elapsed-seconds) #:transparent)
(struct probe-check (label passed? detail elapsed-seconds) #:transparent)

(define (elapsed-seconds start-milliseconds)
    (/ (- (current-inexact-milliseconds) start-milliseconds) 1000.0))

(define (close-input-port/quietly port)
    (when (input-port? port)
        (with-handlers ([exn:fail? void])
            (close-input-port port))))

(define (close-output-port/quietly port)
    (when (output-port? port)
        (with-handlers ([exn:fail? void])
            (close-output-port port))))

(define (stop-process/quietly process)
    (when process
        (with-handlers ([exn:fail? void])
            (when (eq? (subprocess-status process) 'running)
                (subprocess-kill process #t))
            (subprocess-wait process))))

(define (read-and-close-child-output child-stdout child-stderr)
    (define stdout-text (string-trim (port->string child-stdout)))
    (define stderr-text (string-trim (port->string child-stderr)))
    (close-input-port child-stdout)
    (close-input-port child-stderr)
    (values stdout-text stderr-text))

(define (run-probe expression)
    (define start-milliseconds (current-inexact-milliseconds))
    (define process #f)
    (define child-stdout #f)
    (define child-stdin #f)
    (define child-stderr #f)

    (cond
        [(not racket-executable)
            (probe-harness-failure
                "could not locate the racket executable"
                (elapsed-seconds start-milliseconds))]
        [else
            (with-handlers
                ([exn:fail?
                    (lambda (error)
                        (stop-process/quietly process)
                        (close-input-port/quietly child-stdout)
                        (close-output-port/quietly child-stdin)
                        (close-input-port/quietly child-stderr)
                        (probe-harness-failure
                            (exn-message error)
                            (elapsed-seconds start-milliseconds)))])
                (let-values ([(new-process new-stdout new-stdin new-stderr)
                    (parameterize ([current-directory project-root])
                        (subprocess
                            #f #f #f
                            racket-executable
                            "-I" "lazy" "-e" expression))])
                    (set! process new-process)
                    (set! child-stdout new-stdout)
                    (set! child-stdin new-stdin)
                    (set! child-stderr new-stderr))

                (close-output-port child-stdin)
                (set! child-stdin #f)

                (if (sync/timeout deadline-seconds process)
                    (begin
                        (subprocess-wait process)
                        (let-values ([(stdout-text stderr-text)
                            (read-and-close-child-output
                                child-stdout child-stderr)])
                            (probe-completed
                                (subprocess-status process)
                                stdout-text
                                stderr-text
                                (elapsed-seconds start-milliseconds))))
                    (begin
                        (subprocess-kill process #t)
                        (subprocess-wait process)
                        (let-values ([(stdout-text stderr-text)
                            (read-and-close-child-output
                                child-stdout child-stderr)])
                            (probe-timed-out
                                stdout-text
                                stderr-text
                                (elapsed-seconds start-milliseconds))))))]))

(define probe-cases
    (list
        ; A terminating counterpart for every module path proves that startup,
        ; imports, forcing, and readable output all finish inside the deadline.
        (probe-case
            "control: raw div(5)(2)"
            "(require \"division.rkt\" \"church.rkt\") (displayln (n-read ((div five) two)))"
            'value
            "2")
        (probe-case
            "control: raw divZ(+5)(+2)"
            "(require \"integers.rkt\") (displayln (z-read ((divZ posFive) posTwo)))"
            'value
            "2")
        (probe-case
            "control: strict DIV(FIVE)(TWO)"
            "(require \"types/CHURCH.rkt\" \"types/TYPES.rkt\") (displayln (read-any ((DIV FIVE) TWO)))"
            'value
            "nat:2")
        (probe-case
            "control: strict DIVz(posFIVE)(posTWO)"
            "(require \"types/INTEGERS.rkt\" \"types/TYPES.rkt\") (displayln (read-any ((DIVz posFIVE) posTWO)))"
            'value
            "int:2")

        ; These are the four approved partial division boundaries. Returning a
        ; value or crashing is a failure; only reaching the deadline passes.
        (probe-case
            "timeout: raw div(5)(0)"
            "(require \"division.rkt\" \"church.rkt\") (displayln (n-read ((div five) zero)))"
            'timeout
            #f)
        (probe-case
            "timeout: raw divZ(+5)(+0)"
            "(require \"integers.rkt\") (displayln (z-read ((divZ posFive) posZero)))"
            'timeout
            #f)
        (probe-case
            "timeout: strict DIV(FIVE)(ZERO)"
            "(require \"types/CHURCH.rkt\" \"types/TYPES.rkt\") (displayln (read-any ((DIV FIVE) ZERO)))"
            'timeout
            #f)
        (probe-case
            "timeout: strict DIVz(posFIVE)(posZERO)"
            "(require \"types/INTEGERS.rkt\" \"types/TYPES.rkt\") (displayln (read-any ((DIVz posFIVE) posZERO)))"
            'timeout
            #f)))

(define (outcome-elapsed-seconds outcome)
    (cond
        [(probe-completed? outcome) (probe-completed-elapsed-seconds outcome)]
        [(probe-timed-out? outcome) (probe-timed-out-elapsed-seconds outcome)]
        [else (probe-harness-failure-elapsed-seconds outcome)]))

(define (failed-check case outcome detail)
    (probe-check
        (probe-case-label case)
        #f
        detail
        (outcome-elapsed-seconds outcome)))

(define (passed-check case outcome detail)
    (probe-check
        (probe-case-label case)
        #t
        detail
        (outcome-elapsed-seconds outcome)))

(define (check-probe case)
    (define outcome (run-probe (probe-case-expression case)))

    (cond
        [(probe-harness-failure? outcome)
            (failed-check
                case outcome
                (format "harness failure: ~a"
                    (probe-harness-failure-message outcome)))]
        [(eq? (probe-case-expectation case) 'timeout)
            (cond
                [(probe-timed-out? outcome)
                    (passed-check case outcome "timed out as expected")]
                [(zero? (probe-completed-status outcome))
                    (failed-check
                        case outcome
                        (format "returned early with stdout ~s and stderr ~s"
                            (probe-completed-stdout outcome)
                            (probe-completed-stderr outcome)))]
                [else
                    (failed-check
                        case outcome
                        (format "crashed with exit ~a and stderr ~s"
                            (probe-completed-status outcome)
                            (probe-completed-stderr outcome)))])]
        [else
            (cond
                [(probe-timed-out? outcome)
                    (failed-check case outcome "terminating control timed out")]
                [(not (zero? (probe-completed-status outcome)))
                    (failed-check
                        case outcome
                        (format "control crashed with exit ~a and stderr ~s"
                            (probe-completed-status outcome)
                            (probe-completed-stderr outcome)))]
                [(not (string=?
                        (probe-completed-stdout outcome)
                        (probe-case-expected-output case)))
                    (failed-check
                        case outcome
                        (format "control returned ~s instead of ~s"
                            (probe-completed-stdout outcome)
                            (probe-case-expected-output case)))]
                [(not (string=? (probe-completed-stderr outcome) ""))
                    (failed-check
                        case outcome
                        (format "control wrote unexpected stderr ~s"
                            (probe-completed-stderr outcome)))]
                [else
                    (passed-check case outcome "returned the expected value")])]))

(define probe-checks (map check-probe probe-cases))
(define failed-checks
    (filter (lambda (check) (not (probe-check-passed? check))) probe-checks))
(define total-count (length probe-checks))
(define failure-count (length failed-checks))
(define pass-count (- total-count failure-count))
(define total-probe-seconds
    (apply + (map probe-check-elapsed-seconds probe-checks)))

(displayln "---------------------------------------------------")
(displayln "-- bounded nontermination results:")
(printf "~a FAIL ~a PASS ~a TEST(s) \n\n"
    failure-count pass-count total-count)
(printf "Deadline: ~a seconds per subprocess; probe time: ~a seconds\n"
    deadline-seconds
    (/ (round (* total-probe-seconds 10)) 10.0))

(unless (null? failed-checks)
    (newline)
    (displayln "Failed Tests:")
    (for-each
        (lambda (check)
            (printf " - ~a: ~a (~a seconds)\n"
                (probe-check-label check)
                (probe-check-detail check)
                (/ (round (* (probe-check-elapsed-seconds check) 10)) 10.0)))
        failed-checks))
