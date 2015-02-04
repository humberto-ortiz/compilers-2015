(* interp.sml - Functions to interpret the straight-line programs from
                 Chapter 1 of Modern Compiler Implementation in ML
   Copyright 2014 - Humberto Ortiz-Zuazaga <humberto.ortiz@upr.edu>
   Distributed under the GNU General Public Licence v3.
   http://www.gnu.org/copyleft/gpl.html
*)
use "slp.sml";

exception UnboundIdentifier

type table = (id * int) list

val mtenv = []

fun lookup (l: table, id: id): int =
  case l of [] =>
    raise UnboundIdentifier
  | (firstId, firstInt)::tail =>
    if firstId = id then firstInt else lookup(tail, id)

fun interpexp (IdExp id, env)  = (lookup (env, id), env)
  | interpexp (NumExp n, env) = (n, env)
  | interpexp (OpExp (e1, myop , e2), env) = 
    let
      val (v1, env1) = interpexp (e1, env) 
      val (v2, env2) = interpexp (e2, env1)
    in
      case myop of Plus => (v1+v2, env2)
    end
and interpstm (_, env) = env;
   
(*
  | maxexp (EseqExp (s1, e1)) = Int.max(2,Int.max(maxstm(s1), maxexp(e1)) )
and maxstm (CompoundStm (s1, s2)) = Int.max(2, Int.max(maxstm(s1), maxstm(s2)))
  | maxstm (AssignStm (_, e1)) = Int.max(2, maxexp e1)
  | maxstm (PrintStm es)  = Int.max(length es, foldl Int.max 0 (map maxexp es));
*)

interpexp (NumExp 5, mtenv);

interpexp (IdExp "a", [("a", 5)]); 

interpexp (OpExp (NumExp 3, Plus, (NumExp 5)), mtenv);

(*
maxstm prog;

val prog2 = 
 CompoundStm(AssignStm("a",OpExp(NumExp 5, Plus, NumExp 3)),
  CompoundStm(AssignStm("b",
      EseqExp(PrintStm[IdExp"a",OpExp(IdExp"a", Minus,NumExp 1)],
           OpExp(NumExp 10, Times, IdExp"a"))),
   PrintStm[IdExp "b", NumExp 5, NumExp 4, NumExp 3, NumExp 2, NumExp 1 ]));

maxstm prog2;
*)
