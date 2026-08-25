```lean
import Mathlib.Data.Real.Basic

-- Specifications (Data)

#check Empty
#check Unit
#check Bool
#check Nat
#check Int
#check Rat
#check Real
#check String
#check List

-- Implementations (Data)

/--
don't know how to synthesize placeholder
context:
⊢ Empty
-/
def e : Empty := _


#check e
#reduce e

def u : Unit := PUnit.unit
def u' : Unit := ()
#check u'
#reduce u'

def b0 : Bool := true
def b1 : Bool := false

def n0 : Nat := 0
def n1 : Nat := 1
-- each value is finite, but they do go on forever

def i : Int := 0

def q : Rat := 0

def r : Real := 0.0

def s : String := ""

def l : List := _

-- Specifications (Total Functions)
-- Let's talk about functions
  -- domain of definition (for us, a type)
  -- codomain (for us, a type)
  -- collection of pairs (i, o) where i ∈ d.o.d. and o ∈ codomain
  -- domain (set of values in d.o.d. for which there are corresponding values in codomain)
  -- range (set of values in codomain for which there are corresponding values in d.o.d.)
-- A function is total if its domain is equal to its domain of definition

#check Empty → Empty
#check Empty → Bool
#check Bool → Empty
#check Bool → Bool
#check Bool → String
#check String → Bool
#check Empty → Bool
#check String → String

-- Implementations (Total Functions)
def e2e : Empty → Empty := _
```


<div style="background: #f0f4f8; border: 1px solid #d0d7de; border-radius: 6px; padding: 8px 12px; margin-top: 16px; font-size: 0.9em;">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

