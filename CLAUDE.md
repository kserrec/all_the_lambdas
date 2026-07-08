# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## The Master Rule

Everything in this repository that is not (a) the syntactic sugar layer, (b) a
reader/printer, or (c) test infrastructure **is pure untyped lambda calculus**.
Once desugared, every object-language definition could be written on paper and
mechanically reduced by hand. Nothing currently violates this, and nothing ever
may. When adding or changing code, this rule overrides all other considerations.

Concretely, object-language code may use only:

- **Lambda abstraction, application, and variables.** The sugar forms `def`,
  `_let`, `_if`, `_cons` (from `macros/macros.rkt`) expand to exactly those.
- **Church encodings for all data**: booleans from `logic.rkt`, numerals from
  `church.rkt`, pairs/lists from `core.rkt`/`lists.rkt`. Never Racket `#t`/`#f`,
  Racket numbers, or Racket lists.
- **The Y combinator for all recursion** (`recursion.rkt`). A `def` must never
  reference its own name in its body — that would be host-language recursion.
  The convention is a `(def foo ... = ((Y foo-helper) ...))` pair where the
  helper takes itself as its first parameter `f`.
- **Racket `define`/`def` for naming only.** Binding a term to a name is meta
  (like a textbook writing "let ADD ≡ λmn. ..."), as are `require`/`provide`.

Permitted host-language zones, and nothing else:

1. **`macros/`** — the translator itself. Ordinary Racket. The `def` macro's
   nine explicit arity cases are deliberate (they read as a desugaring table);
   do not collapse them into a recursive ellipsis macro (see ROADMAP Decisions).
2. **Readers** — functions that render encodings as strings for humans:
   `n-read`, `b-read`, `z-read`, `l-read`, `r-read`, `bin-read`, `bin-z-read`,
   `church-to-nat`, the `read-*` family in `types/`. Their comments mark them
   "not pure LC". Demo output (`displayln` in `data-structures-as-closures/`)
   is in the same category.
3. **Tests and tooling** — `tests/` (all three suites), `run-all-tests.sh`, CI.
4. **Error-message payloads in `types/`** — error objects are lambda-encoded
   pairs whose *structure* (tags, nesting) is pure; the message inside is a
   host string carried as an opaque token and concatenated (`wrap`,
   `string-append`) for diagnostics. The boundary: object-level control flow
   must branch only on church-encoded structure (`is-type`, `is-error`), never
   on string contents. One historical exception exists (`wrap-FOLD-only-once`
   in `types/LISTS.rkt` inspects a message with `string-contains?`); it is
   tracked on the roadmap for purification. Do not add more.

## Commands

- Run all tests: `./run-all-tests.sh` (single pass, exits nonzero on any failure)
- Run one file or folder: `./run-all-tests.sh tests/logic-test.rkt`, `./run-all-tests.sh types`
- Setup: Racket plus the lazy package — `raco pkg install --auto lazy`
- There is no build or lint step. CI (`.github/workflows/tests.yml`) runs the
  full suite on every push and pull request.

## Architecture

The same material is built three times in increasing comfort (see the README
map): `bitter/` is raw nested lambdas with zero sugar; the root `*.rkt` modules
are the sugared versions plus everything built only there (integers, rationals,
binary lists, signed binary integers); `types/` wraps it all in a strict
embedded runtime type discipline; `types/coercive/` is the variant that coerces
instead of rejecting (wip). Purity lives in what the code expands to.

**Languages and laziness.** Root and `bitter/` modules use
`#lang s-exp "macros/lazy-with-macros.rkt"` (Lazy Racket re-exported with the
sugar available); `types/` modules use `#lang lazy` directly and require the
macros. Laziness is load-bearing: direct Y-combinator recursion only terminates
because every expression is a promise. This is also why **rackunit is rejected**
— its checks compare unforced promises and fail on equal values. The custom
harness (`tests/helpers/test-helpers.rkt`) forces values naturally by rendering
them through readers.

**Representations** (cross-file; braces denote lambda-encoded pairs):

- Church numeral: n-fold application. Note `zero` *is* `false` — the same term.
- Integer: `{sign bool, nat}` (true = positive; -0 == +0 by convention)
- Rational: `{integer, nat}` = `{{sign, nat}, nat}`
- List: nested pairs ending in `nil`
- Binary nat (`binary-lists.rkt`): list of zero/one digits, most significant
  first, normalized (no leading zeros) via `rem-head-zeroes`; every public
  function returns normalized output
- Signed binary integer (`int-binary-lists.rkt`): `{sign, binary nat}`
- Typed object (`types/`): `{church-numeral type tag, value}`; error object:
  `{_error, {expected-type tag, message string}}`. The `type-check`/
  `type-check2`/`type-check3` wrappers check tags, run the wrapped untyped
  function, and chain error objects through failures so errors propagate as
  values; `fully-type*` additionally rewraps the return value with its tag.

**Tests** compare reader output strings:
`(test-list-element "label" (bin-read expr) "42")`, grouped into a list and
reported with `(show-results "group" tests)`. Test files must explicitly
require every module whose bindings they touch (e.g. `lists.rkt` for
`head`/`tail`) — the sugar lang does not re-export them.

**Style.** Definitions carry block comments in a Contract/Idea/Logic idiom;
explicit beats clever everywhere — this is teaching material as much as code.
`ROADMAP.md` tracks phased work; check items off (with date) as they complete.
