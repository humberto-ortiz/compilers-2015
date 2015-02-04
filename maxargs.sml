(* maxargs.sml - Functions to process the straight-line programs from
                 Chapter 1 of Modern Compiler Implementation in ML
   Copyright 2014 - Humberto Ortiz-Zuazaga <humberto.ortiz@upr.edu>
*)
use "slp.sml";

(* mutually recursive functions to process stm and exp *)
fun maxargs( PrintStm (l)) = Int.max(length (l), foldl Int.max 0 (List.map maxexp l))
  | maxargs( CompoundStm (s1, s2)) = Int.max(maxargs(s1), maxargs(s2))
  | maxargs( AssignStm (_, e1) ) = maxexp(e1)
and maxexp (EseqExp(s1, e1)) = Int.max(maxargs(s1), maxexp(e1))
  | maxexp (OpExp (e1, _, e2)) = Int.max(maxexp(e1), maxexp(e2))
  | maxexp (_) = 0;

maxargs(PrintStm[IdExp "a", IdExp "b"]);
maxargs(prog);


