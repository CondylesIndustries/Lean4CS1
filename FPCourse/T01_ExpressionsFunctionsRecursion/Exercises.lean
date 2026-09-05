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



--- E1.1

#check Nat.add 3 4
-- adds two natural numbers, yes curried since x -> x ->. 2
#check Nat.mul 3 4
-- multiplies two natural numbers, yes curried since x -> x ->. 2
#check String.append "hello" "Kevin"
-- appends two strings and not curried. 2

-- Every inhabitant can return one of the two types. It cannot compare or process the values passed in any way
-- because this is for all possible types, so any operation must be able to be applied to any type. Not
-- even equality works because you need the DecidableEQ condition.


--- E.1.2

def myStrNat : String × Nat := ("lean", 4)

def MyStrNatSpec : Prop := myStrNat.1 = "lean" ∧ myStrNat.2 > 0
#guard myStrNat.1 = "lean"
#guard myStrNat.2 = 4
#guard decide (myStrNat.1 = "lean" ∧ myStrNat.2 > 0) = true


-- E.1.3

-- a) decide can close it rfl. atomic, yes carries decision procedure.
-- b) decide can close it rfl. built from connectives, yes carries decision procedure.
-- c) decide can close it rfl. built from connectives, yes carries decision procedure.
-- d) no. float equality is undecidable on computers. No decidableEq instance. atomic. no decision procedure.
-- NaN is not equal to itself so it breaks propositional equality

#guard decide (17 * 23 = 391) = true
#guard decide (100 < 200 ∧ 200 < 300) = true
#guard decide (¬ (5 * 5 = 26)) = true
-- (d) has no check on purpose: say why `decide` cannot close Float equality.
--     (Hint: what would DecidableEq Float have to certify about NaN?  §1.2, revisited Week 7.)


-- E.1.4

#guard 3 - 5 + 5 ≠ 3
--- Side condition: it holds when a ≥ b
