# Roadmap

Guiding principle: the *object language* (the lambda calculus terms themselves)
stays pure untyped lambda calculus, written the way a textbook would write it.
The sugar layer (macros) and tooling (test runner, CI) are ordinary
Racket/bash and may be improved freely — but readability-as-teaching-material
is valued there too, so explicit beats clever.

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
  - [ ] `HEAD-OPT` (no typed `HEAD` exists yet) and a Result-returning safe
    division (`err` on divide-by-zero)
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
