-- INTRODUCTION RULES

def n : Nat := Nat.zero
def m : Nat := Nat.succ n

def b : Bool := Bool.true
def c : Bool := Bool.false

def nb : Nat × Bool :=
  Prod.mk n b

def nb' : Nat × Bool :=
  (
    n,
    b
  )

def nb'' : Nat × Bool :=
  (
    Nat.zero,
    Bool.false
  )

-- ELIMINATION RULES

def NB2Nat : (Nat × Bool) → Nat :=
  fun (p : Nat × Bool) => -- 0    -- > introduction
    Prod.fst p

def NB2Nat' : (Nat × Bool) → Nat :=
  fun (p : Nat × Bool) => -- 0    -- > introduction
    p.1     -- Prod elim_1

#eval NB2Nat nb
#eval NB2Nat' nb



def NB2Bool : (Nat × Bool) → Bool :=
  fun p =>
    p.2     -- Prod elim_2


def nb2bn : Nat × Bool → Bool × Nat :=
  fun nb => -- you get → introduction, then x introduction, then elim for prod 1 and 2
    (nb.2, nb.1)


def nb2bn' : Nat × Bool → Bool × Nat :=
  fun nb => -- → introduction
    let n := nb.1 -- x elimination left/1
    let b := nb.2 -- x elimination left/2
    (b, n)


def nb2bn'' : Nat × Bool → Bool × Nat :=
  fun nb => -- you get → introduction, then x introduction, then elim for prod 1 and 2
    (nb.2, nb.1)


def andExample' : (7 > 0) ∧ (7 ≤ 10) := --- take a free variable Nat n and return a pair of proofs
  And.intro (by decide) (by decide)



--def andExample (n : Nat) : (n > 0) ∧ (n ≤ 10) :=
--  And.intro (by decide) (by decide)  -- And.intro is for proofs. Prod.mk is for computational data types

def impExample : (7 > 0) ∧ (7 ≤ 10) → (7 ≤ 10) ∧ (7 > 0) :=
  fun conj =>    -- → intro
    (           -- prod introduction
      And.intro   -- and intro
        conj.2    -- And.elim_2 meaning right
        conj.1    -- And.elim_1 meaning left
    )



def impEx2 {P Q : Prop} : P ∧ Q → Q ∧ P :=
  fun pq =>
    And.intro pq.right pq.left

-- we proved that logical conjunction is commutative


def disjunctionIsCommutative {P Q : Prop} : P ∨ Q → Q ∨ P :=
  fun pvq =>
    pvq.elim (fun p => Or.inr p) (fun q => Or.inl q)

def disjunctionIsCommutative' {P Q : Prop} : P ∨ Q → Q ∨ P :=
  fun pvq =>
    match pvq with
    | Or.inl p => Or.inr p
    | Or.inr q => Or.inl q
