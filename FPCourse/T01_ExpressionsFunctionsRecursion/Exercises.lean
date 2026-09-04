--- E0.1

--- a: yes. Decidable predicate. Basic type, product
--- b: yes. decidable predicate. Basic type, sum
--- c: yes. decidable predicate. Basic type, a is uninhabited,
--- d: yes. decidable predicate. Basic type, product. a is uninhabited

#guard decide (2 < 3 ∧ 3 < 4) = true
#guard decide (2 < 3 ∨ 3 < 2) = true
#guard decide (¬ (2 = 3)) = true
#guard decide (¬ (2 < 3 ∧ 3 < 2)) = true

--- E0.2

/-! @@@
DERIVATION of twice : (α → α) → α → α
  goal: (α → α) → α → α
  step 1 [→I]  fun (f: α → α) => ? ⟶ goal: α → α, with f : α → α
  step 2 [→I]  fun (x : α) => ? ⟶ goal: α, with f : α → α, x: α
  step 3 [→E]  f (f x) : α          ⟶ closed
  ∎
@@@ -/

def twice : (α → α) → α → α :=
  fun f x => f (f x)

#guard twice (· * 2) 3 = 12
#guard twice (fun b => !b) false = false
#guard twice (· + 1) 0 = 2

--- it says that if you have a proof that P → P, and a proof of P, then it
--- implies P

--- E0.3
def mapOption : (α → β) → Option α → Option β :=
  fun f x => match x with
  | none => none
  | some n => some (f n)

--- It uses function and sum since option is basically a sum

--- E0.4
#eval (5 - 6) + 6 ≠ 5

--- Side condition: it holds when a ≥ b
