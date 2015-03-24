structure Absyn = struct
  datatype binop = Plus | Minus | Times | Div

  datatype stm = CompoundStm of stm * stm
             | AssignStm of string * exp
             | PrintStm of exp list

  and exp = IdExp of string
             | NumExp of int
       | OpExp of exp * binop * exp
       | EseqExp of stm * exp
end
