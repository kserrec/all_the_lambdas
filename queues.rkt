#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
         "logic.rkt"
         "lists.rkt"
         "recursion.rkt")

;===================================================
; PERSISTENT QUEUES
;===================================================

#| QUEUES {front, back}

    A queue is a pair of two lists. Elements leave from the FRONT list
    and arrive on the BACK list (newest first). When the front runs dry,
    the back is reversed and becomes the new front — so elements still
    come out in first-in-first-out order.

    This is the classic two-list persistent queue: push and pop build
    new queues out of old pieces, and every older queue stays usable,
    because nothing here can mutate anything.

    Popping answers with a found-flag pair, since the empty queue has
    nothing to give:

        q-pop(queue) => {false, false}
                      | {true, {value, rest-queue}}
|#

;===================================================

#|
    ~ EMPTY QUEUE ~
    - Contract: queue
    - Logic: Both the front and the back start as the empty list
|#
(def q-empty = ((pair nil) nil))

#|
    ~ IS EMPTY QUEUE ~
    - Contract: queue => bool
    - Logic: A queue is empty exactly when both of its lists are
|#
(def q-isEmpty q = ((_and (isNil (head q))) (isNil (tail q))))

#|
    ~ PUSH ~
    - Contract: (func, queue) => queue
    - Idea: Add a new element at the end of the line
    - Logic: Cons the element onto the back list; the front is untouched
|#
(def q-push x q = ((pair (head q)) ((pair x) (tail q))))

#|
    ~ POP ~
    - Contract: queue => {bool, {func, queue}} or {false, false}
    - Idea: Take the element that has waited longest, and the queue without it
    - Logic: If the front list has a head, hand it over with the rest of
                the front kept as-is. If the front is dry but the back is
                not, reverse the back into a fresh front first — the
                oldest arrival is at the bottom of the back, so reversing
                puts it on top. If both lists are dry, answer {false, false}
|#
(def q-pop q =
    (_if (isNil (head q))
        _then (_if (isNil (tail q))
                _then ((pair false) false)
                _else (_let flipped = (rev (tail q))
                        ((pair true)
                         ((pair (head flipped))
                          ((pair (tail flipped)) nil)))))
        _else ((pair true)
               ((pair (head (head q)))
                ((pair (tail (head q))) (tail q))))))

#|
    ~ DRAIN ~
    - Contract: queue => list
    - Idea: Pop until empty, collecting the values in the order they leave
    - Logic: If popping finds a value, cons it onto the drain of the rest;
                if the queue is empty, contribute nil
|#
(def q-drain q = ((Y q-drain-helper) q))

(def q-drain-helper f q =
    (_let popped = (q-pop q)
        (_if (head popped)
            _then ((pair (head (tail popped))) (f (tail (tail popped))))
            _else nil)))
