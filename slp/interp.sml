(* slp-eval.sml - Functions to process the straight-line programs from
                  Chapter 1 of Modern Compiler Implementation in ML
   Copyright 2014 - Humberto Ortiz-Zuazaga <humberto.ortiz@upr.edu>
*)
structure A = Absyn
structure Interp :
  sig val interp : A.stm  -> unit end =
struct
exception Unbound

type table = (string * int) list

fun interp(s1 : A.stm) : unit =
    let
	val env = []
	fun lookup ([], _) = raise Unbound
	  | lookup ((name, value) :: t, id) =
	    if id = name then value else lookup(t, id)
	and update (table, id, value) = (id, value) :: table
	and doop (n1, A.Plus, n2, env) = ((n1 + n2), env)
	  | doop (n1, A.Minus, n2, env) = ((n1 - n2), env)
	  | doop (n1, A.Times, n2, env) = ((n1 * n2), env)
	  | doop (n1, A.Div, n2, env) = ((n1 div n2), env)
	and evalexp (A.IdExp id, env) = (lookup(env, id), env)
	  | evalexp (A.NumExp n, env) = (n, env)
	  | evalexp (A.OpExp (n1, anop, n2), env) =
	    let
		val (v1, e1) = evalexp(n1, env);
		val (v2, e2) = evalexp(n2, e1)
	    in
		doop(v1, anop, v2, e2)
	    end
	  | evalexp (A.EseqExp(s1, exp1), env) =
	    let
		val env1 = evalstm(s1, env)
	    in
		evalexp(exp1, env1)
	    end
	and evalstm (A.PrintStm ([]), env) = env
	  | evalstm (A.PrintStm (h::t), env) =
	    let
		val (v, e) = evalexp(h, env)
	    in
		print (Int.toString v);
		print "\n";
		evalstm(A.PrintStm(t), e)
	    end
	  | evalstm (A.AssignStm (id, exp1), env1) =
	    let
		val (v1, env2) = evalexp(exp1, env1);
		val env3 = update(env2, id, v1)
	    in
		env3
	    end
	  | evalstm (A.CompoundStm(s1, s2), env) =
	    let
		val env1 = evalstm(s1, env)
	    in
		evalstm(s2, env1)
	    end
    in
	evalstm(s1, env) ; ()
    end
end
