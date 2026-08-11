# Roadmap

Guiding principle: the *object language* (the lambda calculus terms themselves)
stays pure untyped lambda calculus, written the way a textbook would write it.
The sugar layer (macros) and tooling (test runner, CI) are ordinary
Racket/bash and may be improved freely — but readability-as-teaching-material
is valued there too, so explicit beats clever.

## Session status (as of 2026-08-11)

The ordered integrity-work queue is complete. There is no pre-authorized
implementation phase for a new `$next` invocation. The next action is a
decision turn with Kyle: choose whether to address one of the preserved later
integrity findings (signed-zero exponentiation, binary-search termination and
false tagging, `IND-OPT`, remaining test-claim mismatches, reader diagnostics,
or teaching equations) or begin a new Phase 3 product track. The deferred reals
arc remains set aside and must not be selected without asking.

Integrity Phase 1 is complete. The bounded strict, coercive, and binary test
claims named by that phase now execute the cases their labels describe; all
1,745 repository tests still pass.

Integrity Phase 2 is complete. The raw nested-lambda `bitter/` route loads
again, mixed-sign integer addition preserves the correct magnitude, and its new
automated suite brings the repository total to 1,755 passing tests.

Integrity Phase 3 is complete. A host-level subprocess test now proves the four
approved partial division boundaries reach a 10-second deadline, while four
terminating counterparts prove every module path can return normally. The full
repository now passes 1,763 tests.

Integrity Phase 4 is complete. Binary subtraction and division now return
canonical digit lists directly rather than relying on readers to hide an empty
zero or leading quotient zeroes. Direct structure tests cover the binary-natural
arithmetic boundary and representative signed-integer and rational consumers;
the full repository now passes 1,807 tests.

Integrity Phase 5 is complete. The existing division-by-zero choices are now
declared consistently at their raw, strict, coercive, binary, and rational
implementation boundaries and in the teaching documents. No executable
behavior changed; focused probes and all 1,807 repository tests confirm the
documented policy matrix.

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

### Integrity Phase 1 — make green tests execute their claimed cases (complete 2026-08-11)

- [x] **Step 1. Repair the recorded strict test mismatches** — in
  `types/tests/CHURCH-test.rkt`, reconcile each label, expression, and expected
  value for `MULT(ZERO)(ONE)`, `MULT(FIVE)(FIVE)`, `DIV(ZERO)(FOUR)`, and
  `MOD(FIVE)(FIVE)`. Determine the intended case from the surrounding test
  sequence before editing; do not silently rename a label to preserve a copied
  expression. Completed 2026-08-11: those claims now assert results `nat:0`,
  `nat:25`, `nat:0`, and `nat:0`, respectively; the bounded adjacent scan also
  corrected `MOD(ZERO)(FOUR) => nat:0`.
- [x] **Step 2. Repair the corresponding coercive mismatches** — perform the
  same evidence-based corrections in `types/coercive/tests/CHURCH-test.rkt`,
  preserving intentional coercion cases. Completed 2026-08-11: the same five
  arithmetic claims now execute their labels, and the adjacent scan corrected
  `MULT(FOUR)(ERROR) => nat:0` plus the intentional coercion case
  `DIV(posFOUR)(negTWO) => nat:2`.
- [x] **Step 3. Make the binary normalization comparison real** — replace the
  `tests/binary-lists-test.rkt` case labeled “unnormalized vs normalized” that
  currently compares `bin-one` with itself with an actual leading-zero binary
  representation compared against canonical `bin-one`. Completed 2026-08-11:
  `bin-eq((_cons zero one))(bin-one) => true` now compares `[0,1]` with `[1]`.
- [x] **Step 4. Bound and verify the correction** — inspect the adjacent
  `MULT`, `DIV`, `MOD`, and `bin-eq` groups for the same copy/paste failure;
  run the three affected test files and then the full repository runner. Record
  every corrected claim and the resulting counts here. Completed 2026-08-11:
  the three affected files pass 478/478 tests (strict 127, coercive 148, binary
  203), and the full 24-file repository run passes 1,745/1,745 with zero
  failures.

### Integrity Phase 2 — restore and cover the `bitter/` teaching route (complete 2026-08-11)

- [x] **Step 1. Restore loadability from the declared representation** —
  reproduce the `pair: unbound identifier` failure in `bitter/lists.rkt`, then
  restore the smallest source-correct raw `pair`/`nil` definitions needed by
  the nested-lambda teaching branch. Do not import the sugared root
  implementation into `bitter/`. Completed 2026-08-11: the unchanged module
  failed at `bitter/lists.rkt:84:10`; restoring its existing raw nested-lambda
  `pair` definition and `nil = zero` made the route load without cross-branch
  imports.
- [x] **Step 2. Expose and correct the masked signed-addition bug** — add direct
  mixed-sign cases such as `+5 + (-2) = +3` and `-5 + (+2) = -3`, then correct
  the reversed natural-subtraction operands in `bitter/integers.rkt` without
  changing the signed-zero convention. Completed 2026-08-11: the pre-fix probe
  returned `0, -3, -3, 0` for the four operand/magnitude orderings, and the new
  regression failed exactly the two zero-collapsing cases. `addZ` now keeps the
  shared sign when adding magnitudes and otherwise subtracts smaller from larger
  under the larger operand's sign; all four cases return `3, -3, -3, 3`, while
  `negZero` and `posZero` still compare equal.
- [x] **Step 3. Put the branch under automated evidence** — retain
  `bitter/test.rkt` as its human-readable demonstration and add a
  harness-compatible test module under `bitter/tests/` so the existing runner
  discovers it normally. Cover module loading plus the repaired list and
  mixed-sign integer cases; do not special-case a no-results demo as passing.
  Completed 2026-08-11: `bitter/tests/bitter-test.rkt` adds five list/load tests
  and five integer tests through the shared harness; `bitter/test.rkt` remains
  behaviorally and textually unchanged as the demonstration.
- [x] **Step 4. Verify the restored route** — run the new bitter test module,
  smoke-load every `bitter/` module it transitively covers, then run the full
  repository runner and record the results. Completed 2026-08-11: the focused
  module passes 10/10, all seven library modules plus `bitter/test.rkt`
  smoke-load successfully, and the full 25-file repository run passes
  1,755/1,755 with zero failures.

### Integrity Phase 3 — test deliberate nontermination safely (complete 2026-08-11)

- [x] **Step 1. Add a bounded host-level probe mechanism** — run each expected
  nonterminating expression in a fresh Racket subprocess, impose a short
  explicit deadline, terminate the subprocess afterward, and distinguish an
  expected timeout from a crash, early value, or harness failure. Keep this in
  test/tooling code, outside the lambda-calculus object language. Completed
  2026-08-11: `tests/nontermination-test.rkt` starts a fresh Lazy Racket process
  per probe, applies a 10-second deadline, forcibly terminates and reaps timed
  out children, closes their ports, and reports timeout, crash, early return,
  and harness failure as distinct outcomes.
- [x] **Step 2. Prove the probe itself** — include a terminating control that
  must return the expected readable value before the deadline; a timeout-only
  mechanism without a control is not evidence. Completed 2026-08-11: four
  controls—one for each module/import path—return `2`, `2`, `nat:2`, and
  `int:2` inside the same deadline, so slow startup cannot masquerade as
  nontermination.
- [x] **Step 3. Cover every approved partial division boundary** — verify
  nontermination for raw Church-natural `div`, raw Church-integer `divZ`,
  strict runtime-tagged natural `DIV`, and strict runtime-tagged integer `DIVz`
  with zero divisors. Do not encode the unrelated binary-search termination bug
  as an expected behavior. Completed 2026-08-11: unchanged external probes for
  all four reached the 10-second bound and exited only when terminated; all four
  integrated cases likewise time out as expected. Binary search is not encoded
  as approved nontermination.
- [x] **Step 4. Integrate and verify** — make the bounded checks part of the
  normal repository test signal without leaving child processes running; run
  the focused probe test and the full runner and record timing and counts.
  Completed 2026-08-11: the focused module passes 8/8 in 59.6 seconds (58.6
  seconds inside the probes), a process-table check finds no surviving child,
  and the full 26-file repository run passes 1,763/1,763 with zero failures.

### Integrity Phase 4 — enforce canonical binary structure (complete 2026-08-11)

- [x] **Step 1. Add direct structural regressions** — demonstrate, without
  passing through `bin-read`, that current `bin-div 4 3` produces leading
  zeroes and current `bin-sub 4 4` produces an empty list instead of canonical
  `bin-zero`. Completed 2026-08-11: direct lazy-language probes observed
  `[0,0,1]` versus numeric `1` and `[]` versus numeric `0`; the two focused
  regressions failed exactly those cases while the existing 203 assertions
  passed.
- [x] **Step 2. Restore the invariant at its sources** — make
  `rem-head-zeroes` return canonical `bin-zero` rather than an empty list and
  normalize the quotient returned by `bin-div`. Preserve the existing numeric
  results and the declared `x / 0 = 0`, `x mod 0 = x` policy. Completed
  2026-08-11: normalization now maps an exhausted/all-zero list to `[0]`, and
  `bin-div` normalizes the nontrivial quotient returned by its helper. The
  original malformed results now read structurally as `[1]` and `[0]`; direct
  zero-divisor probes still return quotient `[0]` and the dividend's canonical
  digits as remainder.
- [x] **Step 3. Cover the public representation boundary** — add representative
  direct-structure assertions for binary zero, one, and ordinary nonzero
  outputs across subtraction, multiplication, division, remainder, successor,
  predecessor, gcd/lcm, and exponentiation, plus representative signed-binary
  integer and binary-rational consumers. Keep the existing reader-based tests.
  Completed 2026-08-11: 32 binary-natural structure assertions cover the
  normalization helper, every named operation, combined quotient/remainder,
  and both zero-divisor outputs; four signed-integer and eight binary-rational
  assertions inspect their embedded digit lists directly. Existing
  reader-based assertions remain in place.
- [x] **Step 4. Verify downstream compatibility** — run binary-natural,
  signed-binary-integer, and binary-rational tests, then the full repository
  runner and record the results. Completed 2026-08-11: the focused suites pass
  428/428 tests (binary natural 235, signed binary integer 125, binary rational
  68), and the explicit 26-file repository run passes 1,807/1,807 with zero
  failures.

### Integrity Phase 5 — declare the accepted division policies (complete 2026-08-11)

- [x] **Step 1. Document partial Church division** — state plainly in the raw
  Church-natural and Church-integer implementations and their strict
  runtime-tagged wrappers that demanding a zero-divisor result does not
  terminate; do not describe this as an error return. Completed 2026-08-11:
  `division.rkt`, `integers.rkt`, `types/CHURCH.rkt`, and
  `types/INTEGERS.rkt` now state the partial domain at the definitions. The
  bounded subprocess suite passes 8/8: four terminating controls return, while
  raw `div`/`divZ` and strict `DIV`/`DIVz` remain active at the 10-second
  zero-divisor deadline.
- [x] **Step 2. Document coercive errors** — state plainly that coercive
  runtime-tagged natural and integer division checks the coerced divisor and
  returns `err:div by 0`. Completed 2026-08-11: comments at coercive `DIV`,
  `MOD`, and `DIVz` now name coercion-before-checking and the explicit error.
  Readable probes for natural and integer zero values plus `FALSE` coercions all
  return `err:div by 0`.
- [x] **Step 3. Document the binary totalization** — state plainly that binary
  natural division chooses quotient zero and remainder equal to the dividend
  at a zero divisor, and that signed binary integer division inherits the zero
  quotient. Completed 2026-08-11: `binary-lists.rkt` and
  `int-binary-lists.rkt` now state the policy at `bin-div`, `bin-div-n-mod`,
  `bin-mod`, and `divZ-bin`. Direct readable/structural probes return quotient
  `0`/`[0]`, remainder `5`/`[1,0,1]`, and signed quotient `0`/`[0]`.
- [x] **Step 4. Synchronize the teaching documents** — make README,
  `CLAUDE.md`, implementation comments, and the evaluation describe the same
  domain-and-layer policy; run focused readable probes and the full repository
  runner before marking the queue complete. Completed 2026-08-11: README and
  `CLAUDE.md` now carry the same five-row policy matrix; the evaluation and
  audit handoff record the resolved status and current evidence. Eight affected
  ordinary suites pass 894/894, the bounded partiality suite passes 8/8, all
  readable probes match the documentation, and the explicit 26-file repository
  run passes 1,807/1,807 with zero failures.

### Later integrity findings — preserved, not authorized by this queue

The audit handoff also records signed-zero exponentiation inconsistency,
binary-search nontermination and false strict tagging, `IND-OPT` type/Option
violations, reader diagnostic copy errors, and incorrect teaching equations.
Phase 1's context inspection also directly observed green claim mismatches
outside its authorized `MULT`/`DIV`/`MOD`/`bin-eq` boundary: strict
`IS_ZERO(TRUE)` and `SUB(FIVE)(FIVE)`; coercive `IS_ZERO(FALSE)`,
`SUB(FIVE)(FIVE)`, `EXP(ZERO)(ONE)`, `EXP(FIVE)(FIVE)`, and
`EXP(FOUR)(ERROR)`; and binary `bin-add(bin-zero)(bin-one)`. These were not
changed in Phase 1 and have not received their own repair authorization.
Do not start those repairs merely because the five phases above finish; discuss
their scope, and any behavioral decisions they require, with Kyle first.

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
- **Test helpers are already shared** — all four suites (`bitter/tests/`,
  `tests/`, `types/tests/`, `types/coercive/tests/`) require the single
  `tests/helpers/test-helpers.rkt`. No deduplication needed.
