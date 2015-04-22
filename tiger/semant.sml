structure Semant :
     sig val transProg : Absyn.exp -> unit end =
struct
  structure A = Absyn

  (* dummy translate for chapter 5 *)
  structure Translate = struct type exp = unit end

  type expty = {exp: Translate.exp, ty: Types.ty}
  type venv = Env.enventry Symbol.table
  type tenv = Types.ty Symbol.table

  fun checkInt ({ty=Types.INT, exp=_}, pos) = ()
  | checkInt ({ty=_,exp=_},pos) = ErrorMsg.error pos "integer required"

  fun transProg (exp:A.exp) : unit =
    let
      val {ty=_, exp=prog} = transExp (Env.base_venv, Env.base_tenv) exp
    in
      prog
    end
  and transDecs (venv:venv, tenv:tenv, nil) = {venv=venv, tenv=tenv}
    | transDecs (venv:venv, tenv:tenv, dec::decs) =
        let
          val {venv=venv', tenv=tenv'} = transDec (venv, tenv, dec)
        in
          transDecs (venv', tenv', decs)
        end
  and transDec (venv:venv, tenv:tenv, A.TypeDec [{name,ty,pos}]) =
        (* fix me too, may have more typedecs *)
        {venv=venv, tenv=Symbol.enter (tenv, name, transTy (tenv,ty))}
    | transDec (venv:venv, tenv:tenv, A.VarDec {name,escape,typ,init,pos}) =
        case typ of NONE =>
          let
            val {exp, ty} = transExp (venv, tenv) init
          in
            {venv=Symbol.enter (venv, name, Env.VarEntry {ty=ty}), tenv=tenv}
          end
        | SOME((id, pos2)) =>
          let
            val {exp, ty=initty} = transExp (venv, tenv) init
            val ty' = Symbol.look(tenv, id)
          in
            case ty' of
            NONE =>
              ( ErrorMsg.error pos "Declared type unbound.";
              {venv=venv, tenv=tenv})
            | SOME(decty) =>
              if decty = initty then
                (* declared and actual type match *)
                {venv=Symbol.enter (venv, name, Env.VarEntry {ty=initty}), tenv=tenv}
              else
                ( ErrorMsg.error pos "Declared type and initializer do not match.";
                {venv=venv, tenv=tenv})
          end
  and transExp(venv:venv,tenv:tenv) : A.exp -> expty =
    let fun trexp (A.OpExp{left, oper, right, pos}) =
          (checkInt (trexp left, pos);
          checkInt (trexp right, pos);
          {ty=Types.INT, exp=()})
       | trexp (A.IntExp _) = {ty=Types.INT, exp=()}
       | trexp (A.NilExp) = {ty=Types.NIL, exp=()}
       | trexp (A.VarExp var) = trvar var
       | trexp (A.StringExp (_,_)) = {ty=Types.STRING, exp=()}
       | trexp (A.SeqExp exps) =
            let
              fun trseq nil = {ty=Types.NIL, exp=()}
                | trseq ((exp, pos)::nil) = trexp exp
                | trseq ((exp,pos)::rest) = (trexp exp; trseq rest)
            in
              trseq exps
            end
       | trexp (A.LetExp{decs,body,pos}) =
           let
             val {venv=venv',tenv=tenv'} = transDecs (venv, tenv, decs)
           in
             transExp (venv', tenv') body
           end
       | trexp _ = {ty=Types.NIL, exp=ErrorMsg.error 0 "Can't typecheck this yet"}
      and trvar (A.SimpleVar (id, pos)) =
        (case Symbol.look(venv,id)
          of SOME(Env.VarEntry{ty}) =>
            {exp=(), ty=actual_ty ty}
          | NONE => {ty=Types.NIL, exp=ErrorMsg.error pos ("Undefined variable " ^ Symbol.name id)})
        | trvar _ = {ty=Types.NIL, exp=ErrorMsg.error 0 "Can't typecheck this yet"}
      and actual_ty (Types.NAME (id, ref typ)) : Types.ty =
            (case typ of NONE => (ErrorMsg.error 0 ("Undefined type " ^ Symbol.name id);
                                                 Types.NIL)
                      | SOME(ty') => actual_ty ty')
         | actual_ty typ = typ
    in
      trexp
    end
  and transTy (tenv, A.NameTy (id, pos)) =
        case  Symbol.look(tenv, id)
          of SOME(ty) => ty
            |NONE => (ErrorMsg.error pos ("Unknown type " ^ Symbol.name id); Types.NIL)

end
