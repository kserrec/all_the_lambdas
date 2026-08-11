# All the Lambdas — Integrity Audit Handoff

> **Superseded; status advanced 2026-08-11.** Kyle approved preserving the existing raw
> rational behavior: untyped Church-backed and untyped binary-backed division
> by rational zero still returns rational zero. Strict and coercive
> runtime-tagged rational division now return explicit errors for a
> rational-zero divisor. The implementation and current evidence are tracked in
> `ROADMAP.md`. Integrity Phase 1's bounded test-claim corrections completed on
> 2026-08-11; the four remaining approved, single-pass integrity phases are
> ordered there, and a future `$next` starts with Integrity Phase 2's `bitter/`
> restoration. The findings below describe the pre-change state and preserve
> the later issues that still require decisions.

> Created 2026-08-10 for resuming this discussion in a new session.
>
> This handoff becomes stale if the arithmetic implementations, typed wrappers,
> binary search, binary normalization, `bitter/` modules, relevant tests, or
> representation documentation described below change.

**Project**: A pedagogical exploration that takes untyped lambda calculus as a given and keeps extending what can be built from it, using Racket's lazy language rather than implementing a separate lambda interpreter.

## Completed this session

- Evaluated the project and produced `all-the-lambdas-evaluation.html`.
- Corrected the evaluation's framing around mathematically unconventional operations: totalizing partial operations is common and pedagogically defensible; returning zero is not automatically a defect.
- Performed a read-only integrity audit of the totalization policies and adjacent behavioral, representation, type-layer, testing, and teaching claims.
- Reproduced the concrete results recorded below. No implementation fixes were made and no improvement plan was solidified.

## Current state

- Git branch: `main`.
- Before this handoff was written, `git status --short` showed only the untracked file `all-the-lambdas-evaluation.html`.
- This handoff is another new repository file.
- No project code, tests, configuration, or existing documentation was changed during the integrity audit.
- No long-running processes were intentionally left running.
- Kyle does not want a major overhaul assumed. The eventual work, if authorized, should improve what exists without adding new lambda features.
- Kyle wants decisions discussed before a phased plan is solidified. In particular, unconventional totalization choices must not be treated as defects merely because they differ from ordinary mathematics.

## Next step

Read this handoff with Kyle and discuss which currently undeclared semantic differences should become explicit, documented policies and which should be aligned. Do not edit implementation or solidify a phase-and-step plan until Kyle has made the decisions that materially affect behavior.

## Watch-outs

- Questions and critiques are not work orders. Answer them without changing files unless Kyle explicitly asks for a change.
- Never inspect dotenv files or their contents.
- Run these modules with the lazy Racket language when probing them, for example through `racket -I lazy`; strict top-level evaluation gives misleading promise-shaped results.
- A green existing test suite does not settle the findings below because several test labels execute different expressions, termination is not checked, structural normalization is usually hidden by readers, `bitter/test.rkt` is outside the runner's discovery pattern, and coercive rationals have no test file.
- Distinguish three categories throughout the next discussion:
  1. an unconventional but coherent convention;
  2. an undeclared difference between domains, representations, or teaching layers;
  3. an actual invariant, contract, or evidence failure.

---

# Full integrity findings

## Main conclusion

The totalizing choices are individually defensible. The integrity problem is that the project currently applies several different policies without declaring where each policy belongs.

The evaluation should therefore say: “division by zero returns zero” is not itself a defect. The defect is semantic drift between representations and layers.

## Division-by-zero audit

When the result is demanded, the project currently has four behaviors:

| Number family / API | Actual zero-divisor behavior |
|---|---|
| Church naturals | `5 / 0` never terminates |
| Strict typed naturals | Also never terminates |
| Coercive typed naturals | Returns `err:div by 0` |
| Binary naturals | Returns quotient `0`; modulo returns the dividend |
| Church integers | `5 / 0` never terminates |
| Strict typed integers | Also never terminates |
| Coercive typed integers | Returns `err:div by 0` |
| Binary integers | Returns readable integer `0` |
| Church rationals | `(1/2) / 0` returns rational `0` |
| Binary rationals | `(1/2) / 0` returns rational `0` |
| Coercive rationals | `(1/2) / 0` returns `rat:0` |

The unary Church implementation in `division.rkt` repeatedly asks whether the divisor is greater than the remaining dividend. With divisor zero, that condition never becomes true because `n × 0` always remains zero. The recursion therefore never makes semantic progress. `mod` inherits the same behavior because it calls `div`.

The binary implementation in `binary-lists.rkt` explicitly chooses:

```text
5 / 0 = 0
5 mod 0 = 5
```

That is a coherent totalization because it preserves:

```text
dividend = quotient × divisor + remainder
5        = 0        × 0       + 5
```

The coercive natural and integer layers explicitly return errors in `types/coercive/CHURCH.rkt` and `types/coercive/INTEGERS.rkt`.

The rational encodings make a different but deliberate choice: any rational with a zero numerator or zero denominator counts as rational zero in `rationals.rkt`. Consequently, reciprocating zero creates a denominator-zero representation, which collapses back into rational zero. Unary rationals, binary rationals, and coercive rationals agree on this.

The resulting judgment is:

- The rational policy is internally consistent.
- The binary quotient/remainder policy is internally coherent.
- Returning an error value is coherent.
- Leaving division partial is normal in lambda calculus.
- Having all four without an explicit domain-and-layer policy is the integrity problem.
- The clearest direct mismatches are Church naturals versus binary naturals, and Church integers versus binary integers: changing only the representation changes whether the same operation terminates.
- Strict versus coercive behavior may intentionally differ because they are different experiments. But `types/coercive/TYPES.rkt` claims the coercive layer provides “guardrails (like no division by zero),” while coercive rational division returns zero rather than an error. That is a direct contradiction inside the coercive layer's stated policy.

## Totalizations that are largely consistent

These choices are not, by themselves, integrity problems:

- Natural subtraction saturates at zero in both Church and binary naturals.
- `pred 0 = 0` is consistent across the natural encodings.
- Negative integer powers default to zero in both unary and binary integer implementations.
- Rational exponentiation uses the floor of a rational exponent in both rational implementations.
- The ordinary `0^0 = 1` convention is used across naturals and rationals.
- Returning Church `true` for an absent natural search result and `-1` for an absent integer result can be defended as domain-specific sentinel choices because naturals cannot represent `-1`.

There is one important exception involving signed zero.

## Actual semantic integrity failures

### 1. Equal integer zeros produce unequal exponentiation results

The project explicitly declares positive zero and negative zero equal. Its tests confirm:

```text
eqZ(-0, +0) = true
```

But direct evaluation gives:

```text
2^(+0) = 1
2^(-0) = 0
```

The binary integer implementation gives the same results:

```text
binary 2^(+0) = 1
binary 2^(-0) = 0
```

The cause is in `integers.rkt` and `int-binary-lists.rkt`: exponentiation examines the exponent's sign before examining whether its magnitude is zero. Negative zero therefore takes the “negative exponent becomes zero” branch.

This is not merely an unconventional mathematical choice. It violates substitution of equals:

```text
-0 = +0
but
2^(-0) ≠ 2^(+0)
```

Either the two zeros must remain observably distinct, or operations must treat them identically. The project currently claims the latter but implements the former here.

### 2. Binary search loses its termination argument at zero

The natural binary search in `algorithms.rkt` uses natural numbers for `low`, `mid`, and `high`.

For:

```text
list   = [1, 3]
target = 0
```

execution reaches:

```text
low  = 0
mid  = 0
high = 0
```

Because the target is below the first element, it recurses with:

```text
high = pred(mid) = pred(0) = 0
```

The state is exactly the same, so the search repeats forever. Both the natural and integer search versions remained running past a 15-second probe bound.

The failure is not `pred 0 = 0`; that is a legitimate natural-number convention. The failure is using a binary-search algorithm whose progress proof assumes that `mid - 1` can become `-1`, while representing its boundaries as saturating naturals.

There is a second search problem:

```text
binarySearch [1, 3] 2 = true
```

That sentinel is documented and could be acceptable in raw untyped code. But the function advertises `(list,nat) => nat`, and the strict wrapper in `types/ALGORITHMS.rkt` blindly tags the returned `true` as a natural. Reading that supposed natural produces:

```text
number->string: expected number?
given: a procedure
```

The strict type tag therefore makes a false claim about its underlying value.

### 3. Binary arithmetic violates its canonical representation

The project states that binary naturals are normalized lists with no leading zeroes and that every public operation returns normalized output.

Direct structural readings show:

```text
bin-div 4 3  => [0,0,1]
canonical 1  => [1]

bin-sub 4 4  => []
canonical 0  => [0]
```

The numeric reader hides both failures by printing `1` and `0`, respectively. But the representations are observably different: they have different lengths and list structures.

The causes are localized:

- `bin-div` does not normalize its generated quotient.
- `rem-head-zeroes` allows the empty list to survive as zero.

This matters because signed binary integers and binary rationals build on these values. A representation invariant must hold underneath its numeric reader, not merely appear correct after rendering.

### 4. `IND-OPT` violates both strict typing and Option meaning

The strict layer promises that passing the wrong type yields a typed error. But `IND-OPT` in `types/LISTS.rkt` unwraps its inputs before checking their tags.

Confirmed examples:

```text
IND-OPT FALSE ZERO
=> option:none
```

A Boolean was passed where a list was required, but the result claims there was merely no element.

For a wrong index type:

```text
IND-OPT typed-[1] FALSE
=> option:some(IND(arg2(err:nat)))
```

Now a type failure is wrapped in `some`, which semantically says the lookup succeeded.

The source comment says type errors are `IND`'s concern, but only the successful range branch calls `IND`. The unsuccessful branch silently hides type errors, while the successful branch packages them as success values.

There are also smaller diagnostic copy errors:

```text
nat-read TRUE => err:bool
Z-READ TRUE   => err:bool
```

Both readers use `BOOL-ERROR` in their rejection branches rather than their own error types in `types/CHURCH.rkt` and `types/INTEGERS.rkt`.

### 5. The recommended `bitter/` teaching route cannot load

The README recommends beginning with the raw `bitter/` branch.

Loading `bitter/lists.rkt` produces:

```text
pair: unbound identifier
```

Its local definitions of `pair` and `nil` are commented out, while the module does not import replacements. Files depending on it consequently fail too.

There is also a currently masked mixed-sign addition bug in `bitter/integers.rkt`. Its subtraction operands are reversed in part of the mixed-sign case:

```text
+5 + (-2)
```

would compute the magnitude as natural `2 - 5`, which saturates to zero, producing `+0` rather than `+3`. This is masked because the module cannot currently reach that calculation due to the earlier loading failure.

## Evidence and teaching integrity failures

### 6. Several green tests do not execute what their labels claim

Examples from `types/tests/CHURCH-test.rkt`:

```text
Label:    MULT(ZERO)(ONE)
Executes: MULT(THREE)(ONE)
Expected: 3

Label:    MULT(FIVE)(FIVE)
Executes: MULT(FIVE)(TWO)
Expected: 10

Label:    DIV(ZERO)(FOUR)
Executes: DIV(ZERO)(ONE)

Label:    MOD(FIVE)(FIVE)
Executes: MOD(FIVE)(FOUR)
```

The coercive suite repeats several of these mismatches.

The binary test described as “unnormalized vs normalized” simply compares `bin-one` with `bin-one` in `tests/binary-lists-test.rkt`.

That explains how the suite can be fully green while the claimed cases remain untested: the harness evaluates the expression, not the human-readable label. It also lacks:

- negative-zero exponent tests;
- termination checks;
- structural normalization checks;
- coercive rational tests;
- automated coverage of `bitter/test.rkt`.

### 7. Some teaching equations describe the wrong encoding

The list explanation in `lists.rkt` expands `[a,b]` using `a` twice:

```text
[a,b] = {a,{a,[]}}
```

The correct expansion is:

```text
[a,b] = {a,{b,[]}}
```

The typed-object examples in `types/TYPES.rkt` also say:

```text
{one, one} = typed TRUE
[]         = typed nil list
```

The Boolean type tag may be Church `one`, but the value must be Church `true`, not Church numeral `one`. Typed nil is actually `{four,nil}`, implemented as `NIL-list`, not bare `[]`.

These are especially important because the representations are the lesson. A wrong explanatory term can teach the wrong lambda encoding even when the implementation underneath is correct.

## Bottom line for the next session

The project's unconventional totalizations should not be swept away. Most are coherent and pedagogically interesting. The genuine problems are:

- undeclared policy differences;
- equal encoded values producing unequal results;
- nontermination caused by incompatible algorithmic assumptions;
- false type tags and strict-boundary leaks;
- violations of canonical binary representation;
- an inaccessible recommended teaching route;
- tests and prose that claim something different from what they execute.

These findings do not by themselves justify a major architectural overhaul. The next conversation should decide which semantic differences are intentional teaching contrasts and which should be aligned before any phase-and-step improvement plan is written.
