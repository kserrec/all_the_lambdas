# Roadmap

Guiding principle: the *object language* (the lambda calculus terms themselves)
stays pure untyped lambda calculus, written the way a textbook would write it.
The sugar layer (macros) and tooling (test runner, CI) are ordinary
Racket/bash and may be improved freely — but readability-as-teaching-material
is valued there too, so explicit beats clever.

## Session status (as of 2026-08-10)

The current priority is the ordered **remaining integrity work** queue below.
A new session invoked with `$next` must start with **Integrity Phase 1 — make
green tests execute their claimed cases**, complete that one phase, update this
roadmap, and stop. Each integrity phase is intentionally sized for one pass.

The targeted rational-division phase is complete. Its raw implementations were
preserved behaviorally, a strict runtime-tagged rational division module was
created, and the existing coercive runtime-tagged division boundary now returns
an explicit zero-divisor error.

Phase 2 is essentially complete. Everything numbered below is done except:
- **8c** — the reals arc (dyadics → intervals → computable reals). Deliberately
  **set aside** by the user for now; do not start it without asking.
- The **item-7 follow-on** slices (option-returning search, `HEAD-OPT`,
  Result-returning safe division) remain open but optional.

**Phase 3 is not yet defined** — the direction is a pending user decision.
Candidate tracks discussed (reals excluded): (a) strings → parser combinators
[reuses `Result`; recommended], (b) deepen the strict type layer [richer errors,
precondition checks, typed-list element discipline, function signatures — the
item-8 road not taken], (c) data structures [trees → BST → sets → maps → graphs],
(d) lambda terms as data [Var/Abs/App, substitution, beta reduction, De Bruijn,
SKI]. See `~/all-the-lambdas-notes.md` for the full menu.

## Targeted integrity phase — rational division semantics (2026-08-10)

Decision: preserve the existing raw rational behavior exactly. The untyped
Church-backed and untyped binary-backed representations both count a zero
numerator or a zero denominator as rational zero, and raw division by rational
zero returns rational zero. Only the runtime-tagged layers override that
zero-divisor result: strict division returns a `Result` error, while coercive
division returns a typed error after coercing the divisor.

- [x] **Step 1. Preserve the raw rational behavior** — leave the constructors,
  zero predicates, readers, reciprocal functions, and division functions
  behaviorally unchanged in both raw representations, and document their
  deliberate rational-zero totalization. Completed 2026-08-10: the original
  171 Church-backed rational tests and 60 binary-backed rational tests pass,
  and direct raw division-by-zero probes return `0`.
- [x] **Step 2. Add runtime-tagged zero-divisor errors** — add strict rational
  division using `Result`, and change coercive rational division to return its
  typed division error after coercing and checking the divisor. Neither wrapper
  changes the raw rational functions. Completed 2026-08-10.
- [x] **Step 3. Evidence and documentation** — test successful division,
  zero dividends, zero divisors, denominator-zero representations, strict type
  failures, and coercion; then synchronize the README, implementation guide,
  roadmap, and audit handoff with the verified behavior. Completed 2026-08-10:
  all 1,745 repository tests pass with zero failures. Direct probes confirm that
  both raw implementations return `0` for division by rational zero; strict
  runtime-tagged division returns `result:err(err:div by 0)`, and coercive
  runtime-tagged division returns `err:div by 0`.

## Current `$next` queue — remaining integrity work

This queue is ordered. One `$next` session completes exactly one integrity
phase, including its steps, focused verification, roadmap update, and stopping
point. Do not combine consecutive phases merely because time remains.

### Integrity Phase 1 — make green tests execute their claimed cases

- [ ] **Step 1. Repair the recorded strict test mismatches** — in
  `types/tests/CHURCH-test.rkt`, reconcile each label, expression, and expected
  value for `MULT(ZERO)(ONE)`, `MULT(FIVE)(FIVE)`, `DIV(ZERO)(FOUR)`, and
  `MOD(FIVE)(FIVE)`. Determine the intended case from the surrounding test
  sequence before editing; do not silently rename a label to preserve a copied
  expression.
- [ ] **Step 2. Repair the corresponding coercive mismatches** — perform the
  same evidence-based corrections in `types/coercive/tests/CHURCH-test.rkt`,
  preserving intentional coercion cases.
- [ ] **Step 3. Make the binary normalization comparison real** — replace the
  `tests/binary-lists-test.rkt` case labeled “unnormalized vs normalized” that
  currently compares `bin-one` with itself with an actual leading-zero binary
  representation compared against canonical `bin-one`.
- [ ] **Step 4. Bound and verify the correction** — inspect the adjacent
  `MULT`, `DIV`, `MOD`, and `bin-eq` groups for the same copy/paste failure;
  run the three affected test files and then the full repository runner. Record
  every corrected claim and the resulting counts here.

### Integrity Phase 2 — restore and cover the `bitter/` teaching route

- [ ] **Step 1. Restore loadability from the declared representation** —
  reproduce the `pair: unbound identifier` failure in `bitter/lists.rkt`, then
  restore the smallest source-correct raw `pair`/`nil` definitions needed by
  the nested-lambda teaching branch. Do not import the sugared root
  implementation into `bitter/`.
- [ ] **Step 2. Expose and correct the masked signed-addition bug** — add direct
  mixed-sign cases such as `+5 + (-2) = +3` and `-5 + (+2) = -3`, then correct
  the reversed natural-subtraction operands in `bitter/integers.rkt` without
  changing the signed-zero convention.
- [ ] **Step 3. Put the branch under automated evidence** — retain
  `bitter/test.rkt` as its human-readable demonstration and add a
  harness-compatible test module under `bitter/tests/` so the existing runner
  discovers it normally. Cover module loading plus the repaired list and
  mixed-sign integer cases; do not special-case a no-results demo as passing.
- [ ] **Step 4. Verify the restored route** — run the new bitter test module,
  smoke-load every `bitter/` module it transitively covers, then run the full
  repository runner and record the results.

### Integrity Phase 3 — test deliberate nontermination safely

- [ ] **Step 1. Add a bounded host-level probe mechanism** — run each expected
  nonterminating expression in a fresh Racket subprocess, impose a short
  explicit deadline, terminate the subprocess afterward, and distinguish an
  expected timeout from a crash, early value, or harness failure. Keep this in
  test/tooling code, outside the lambda-calculus object language.
- [ ] **Step 2. Prove the probe itself** — include a terminating control that
  must return the expected readable value before the deadline; a timeout-only
  mechanism without a control is not evidence.
- [ ] **Step 3. Cover every approved partial division boundary** — verify
  nontermination for raw Church-natural `div`, raw Church-integer `divZ`,
  strict runtime-tagged natural `DIV`, and strict runtime-tagged integer `DIVz`
  with zero divisors. Do not encode the unrelated binary-search termination bug
  as an expected behavior.
- [ ] **Step 4. Integrate and verify** — make the bounded checks part of the
  normal repository test signal without leaving child processes running; run
  the focused probe test and the full runner and record timing and counts.

### Integrity Phase 4 — enforce canonical binary structure

- [ ] **Step 1. Add direct structural regressions** — demonstrate, without
  passing through `bin-read`, that current `bin-div 4 3` produces leading
  zeroes and current `bin-sub 4 4` produces an empty list instead of canonical
  `bin-zero`.
- [ ] **Step 2. Restore the invariant at its sources** — make
  `rem-head-zeroes` return canonical `bin-zero` rather than an empty list and
  normalize the quotient returned by `bin-div`. Preserve the existing numeric
  results and the declared `x / 0 = 0`, `x mod 0 = x` policy.
- [ ] **Step 3. Cover the public representation boundary** — add representative
  direct-structure assertions for binary zero, one, and ordinary nonzero
  outputs across subtraction, multiplication, division, remainder, successor,
  predecessor, gcd/lcm, and exponentiation, plus representative signed-binary
  integer and binary-rational consumers. Keep the existing reader-based tests.
- [ ] **Step 4. Verify downstream compatibility** — run binary-natural,
  signed-binary-integer, and binary-rational tests, then the full repository
  runner and record the results.

### Integrity Phase 5 — declare the accepted division policies

- [ ] **Step 1. Document partial Church division** — state plainly in the raw
  Church-natural and Church-integer implementations and their strict
  runtime-tagged wrappers that demanding a zero-divisor result does not
  terminate; do not describe this as an error return.
- [ ] **Step 2. Document coercive errors** — state plainly that coercive
  runtime-tagged natural and integer division checks the coerced divisor and
  returns `err:div by 0`.
- [ ] **Step 3. Document the binary totalization** — state plainly that binary
  natural division chooses quotient zero and remainder equal to the dividend
  at a zero divisor, and that signed binary integer division inherits the zero
  quotient.
- [ ] **Step 4. Synchronize the teaching documents** — make README,
  `CLAUDE.md`, implementation comments, and the evaluation describe the same
  domain-and-layer policy; run focused readable probes and the full repository
  runner before marking the queue complete.

### Later integrity findings — preserved, not authorized by this queue

The audit handoff also records signed-zero exponentiation inconsistency,
binary-search nontermination and false strict tagging, `IND-OPT` type/Option
violations, reader diagnostic copy errors, and incorrect teaching equations.
Do not start those repairs merely because the five phases above finish; discuss
their behavioral decisions with Kyle first.

## Phase 2 — continuing the build (from ~/all-the-lambdas-notes.md priorities)

- [x] **1. README framing** — "what happens after the tutorial ends" opening,
  Lazy Racket rationale, softened uniqueness claim (2026-07-08)
- [x] **2. "Typed Untyped Lambda Calculus" explanation** — README section plus
  matching doc headers in `types/TYPES.rkt` (strict) and
  `types/coercive/TYPES.rkt` (strict-vs-coercive contrast) (2026-07-08)
- [x] **3. Binary-list explanation** — README section and `binary-lists.rkt`
  motivation reframed as the project's first representation upgrade (2026-07-08)
- [x] **3.5. Fix `type-check3` arg3 bug** — errors for a wrong-typed third
  argument were tagged with `param-type2`; fixed with regression tests
  (2026-07-08)
- [ ] **4. Restore historical binary integer work** (from the old
  `binary-lists/` folder, commits `664ced3`..`705a26b`)
  - [x] 4a. Nat-level operators restored into `binary-lists.rkt` with tests:
    `bin-succ`, `bin-pred`, `bin-lte`, `bin-gt`, `bin-is-even`, `bin-is-odd`,
    `bin-exp`. Note: historical `bin-is-even`/`bin-is-odd` were untested and
    buggy (`isZero` applied to a one-element list instead of its digit; `_not`
    applied to the function instead of the result) — fixed in restoration
    (2026-07-08)
  - [x] 4b. Signed binary integers restored as root `int-binary-lists.rkt`
    (makeZ-bin, succZ-bin, predZ-bin, invertZ-bin, addZ-bin, subZ-bin,
    multZ-bin, divZ-bin, expZ-bin, comparisons, absValZ-bin, parity), constants
    renamed bz.N -> bin-posN/bin-negN to match integers.rkt style. Historical
    tests restored and extended to the operators that never had any (succ,
    pred, invert, exp, comparisons, absVal, parity) — 121 tests (2026-07-08)
- [x] **5. Add `bin-div-n-mod` and `bin-mod`** — remainder via the long-division
  identity (remainder = dividend − quotient·divisor), leaving the tested
  `bin-div` untouched (2026-07-08)
- [x] **6. Add `bin-gcd` and `bin-lcm`** — Euclid via `bin-mod`;
  lcm = product / gcd (2026-07-08)
- [x] **6.5. Purify `wrap-FOLD-only-once`** (`types/LISTS.rkt`) — was the only
  spot where object-level control flow branched on host data (a Racket `if` +
  `string-contains?` checking whether an error message already said "FOLD").
  Fixed by splitting the two error origins into distinct control-flow branches:
  a new `FOLD-inner` labels errors from *inside* the fold, while argument-type
  errors are labeled by `keep-typed3`/`type-check3` as before — so the "already
  labeled?" question is answered by which branch we are in, never by inspecting
  the message. Dropped the now-unused `racket/string` require from
  `types/LISTS.rkt`. Object language re-verified fully pure (2026-07-08)
- [x] **7. Add `Option`/`Result` to the strict typing branch** — two new typed
  containers in `types/TYPES.rkt`: `option = some(value) | none` (type tag 6)
  and `result = ok(value) | err(error)` (type tag 7). Both reuse the
  `{type, {discriminating-bool, payload}}` shape (the same trick integers use).
  Constructors `make-some`/`NONE`/`make-ok`/`make-err-result`, predicates
  `is-option`/`is-result`/`is-some`/`is-none`/`is-ok`/`is-err`, selectors
  `unwrap-*`, safe eliminators `option-or-else`/`result-or-else`, and reader
  integration (`read-option`/`read-result`, wired into `read-any`). 29 tests
  (2026-07-08). Follow-on — wire these into functions where failure is expected:
  - [x] `IND-OPT` in `types/LISTS.rkt` — safe indexing: in range => `some(value)`,
    out of range => `none` (rather than IND's garbage). 10 tests (2026-07-08)
  - [ ] Option-returning search — the untyped `binarySearch` signals "not found"
    with a church `true`, `binarySearchZ` with `negOne`; a typed search returning
    `some(index)`/`none` would retire those in-band sentinels
  - [ ] `HEAD-OPT` (no typed `HEAD` exists yet)
  - [~] Result-returning safe division — strict rational `DIVr` now returns
    `result:ok(rat)` or `result:err(error)` (2026-08-10); strict natural and
    integer division still inherit raw partiality, by the approved policy
- [~] **8. Next major tentacle: binary rationals** (chosen 2026-07-08 over
  typed-list/function-signatures). The scalable counterpart to `rationals.rkt`,
  now at full parity with it.
  - [x] 8a. `binary-rationals.rkt` — `binR = {binZ numerator, binNat denominator}`,
    mirroring `rationals.rkt` onto the `-bin` operators (uses the `bin-gcd`/
    `bin-lcm` from item 6 directly instead of re-deriving Euclid). Reader,
    constants, `reduce-bin`, `reciprocal-bin`, `invert-sign-R-bin`,
    `convert-s-numer-bin`, `isZeroR-bin`, arithmetic (`addR-bin`/`subR-bin`/
    `multR-bin`/`divR-bin`), and comparisons (`eqR-bin`/`gteR-bin`/`gtR-bin`/
    `ltR-bin`/`lteR-bin`). Also filled a gap in `binary-lists.rkt`: `bin-eq`
    (had gte/gt/lt/lte but no equality). 44 + 7 tests (2026-07-08)
  - [x] 8b. `floorR-bin` and `expR-bin` — the coupled, subtle pair. Translated
    the *fixed* Church `floorR` (non-negative truncates; negative goes one down
    only on a nonzero remainder, so negative wholes are their own floor — the
    `-4/2 => -2` edge is tested). `expR-bin` floors its exponent, so rationals
    stay closed; 0^0 = 1, negative exponent flips to the reciprocal, negative
    base's sign follows exponent parity. 16 tests (2026-07-08)
  - [ ] 8c. (stretch) the numeric-tower next steps from the notes: dyadic
    rationals, then intervals, then computable reals as approximation functions

## Phase 1 — quality improvements (complete)

- [x] **1. Test runner overhaul** (`run-all-tests.sh`)
  - Run each test file **once**, not twice (currently the whole suite runs a
    second time just to build the summary — doubles an already slow lazy run)
  - Exit nonzero when any test fails (currently always exits 0, so nothing
    automated can detect a red suite)
  - Clean up the `mktemp` file on exit
  - Make file discovery safe for paths with spaces
  - Skip `tests/helpers/` (helper module, not a test)

- [x] **2. Harness quality-of-life** (beef up the custom harness — see
  Decisions: rackunit is rejected)
  - Optional argument to run a single test file or directory:
    `./run-all-tests.sh tests/logic-test.rkt`
  - Per-file colored PASS/FAIL line with timing
  - Files that crash (produce no results) count as failed
  - Red "Failing files" list at the end of the summary

- [x] **3. Continuous integration**
  - GitHub Actions workflow (`.github/workflows/tests.yml`): installs Racket +
    `lazy`, runs `./run-all-tests.sh` on every push and pull request
  - Verified passing on GitHub (first green run 2026-07-08, 1405/1405 tests)

- [x] **4. Small cleanups**
  - README: added a repository map table and single-file test instructions
  - `transform-string` in `types/TYPES.rkt`: turned out to be **dead code** —
    only referenced from the commented-out `read-list` variants next to the
    "can't decide on how to read lists" note. Left untouched since it's tied
    to that open design decision. Delete it (or revive a `read-list` that
    uses it) whenever the list-reading format gets decided.

## Out of scope (features — not this effort)

- ~~Finishing rational exponentiation~~ — **done 2026-07-07**: `expR` in
  `rationals.rkt` floors the exponent first (rationals stay closed under
  exponentiation), and a `floorR` bug (negative whole values floored one
  too far down, e.g. floor(−4/2) gave −3) was fixed along the way
- Finishing the coercive type system's remaining pieces

## Decisions

- **`def` macro stays as nine explicit arity cases.** A recursive ellipsis
  macro would be equivalent and shorter, but the explicit cases read like a
  desugaring table and that teaching value is worth the length. Purity is not
  at stake either way — the macro layer is outside the object language.
- **rackunit rejected; the custom harness is deliberate.** The project runs
  under `#lang lazy`, where every expression is a promise; rackunit's checks
  compare unforced promises and fail even when the underlying values match.
  The custom harness forces values naturally inside the lazy world. Improve
  it in place (items 1–2) rather than replacing it.
- **Test helpers are already shared** — all three suites (`tests/`,
  `types/tests/`, `types/coercive/tests/`) require the single
  `tests/helpers/test-helpers.rkt`. No deduplication needed.
