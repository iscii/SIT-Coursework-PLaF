open ReM
open Dst
open Parser_plaf.Ast
open Parser_plaf.Parser
       
let rec chk_expr : expr -> texpr tea_result =
  fun e ->
  match e with
  | Int _n -> return IntType
  | Var id -> apply_tenv id
  | IsZero(e) ->
    chk_expr e >>= fun t ->
    if t=IntType
    then return BoolType
    else error "isZero: expected argument of type int"
  | Add(e1,e2) | Sub(e1,e2) | Mul(e1,e2)| Div(e1,e2) ->
    chk_expr e1 >>= fun t1 ->
    chk_expr e2 >>= fun t2 ->
    if (t1=IntType && t2=IntType)
    then return IntType
    else error "arith: arguments must be ints"
  | ITE(e1,e2,e3) ->
    chk_expr e1 >>= fun t1 ->
    chk_expr e2 >>= fun t2 ->
    chk_expr e3 >>= fun t3 ->
    if (t1=BoolType && t2=t3)
    then return t2
    else error "ITE: condition not boolean or types of then and else do not match"
  | Let(id,e,body) ->
    chk_expr e >>= fun t ->
    extend_tenv id t >>+
    chk_expr body
  | Proc(var,Some t1,e) ->
    extend_tenv var t1 >>+
    chk_expr e >>= fun t2 ->
    return @@ FuncType(t1,t2)
  | Proc(_var,None,_e) ->
    error "proc: type declaration missing"
  | App(e1,e2) ->
    chk_expr e1 >>=
    pair_of_funcType "app: " >>= fun (t1,t2) ->
    chk_expr e2 >>= fun t3 ->
    if t1=t3
    then return t2
    else error "app: type of argument incorrect"
  | Letrec([(_id,_param,None,_,_body)],_target) | Letrec([(_id,_param,_,None,_body)],_target) ->
    error "letrec: type declaration missing"
  | Letrec([(id,param,Some tParam,Some tRes,body)],target) ->
    extend_tenv id (FuncType(tParam,tRes)) >>+
    (extend_tenv param tParam >>+
     chk_expr body >>= fun t ->
     if t=tRes 
     then chk_expr target
     else error "LetRec: type of recursive function does not match declaration")
   | Pair(e1,e2) ->
    chk_expr e1 >>= fun t1 ->
    chk_expr e2 >>= fun t2 ->
    return @@ PairType(t1,t2)
  | Unpair(id1,id2,e1,e2) ->
    chk_expr e1 >>= fun t ->
    (match t with
     | PairType(t1,t2) ->
    extend_tenv id1 t1 >>+
    extend_tenv id2 t2 >>+
    chk_expr e2
     | _ -> error "unpair: expected a pair")
      
  (* EXPLICIT-REFS *)
  | BeginEnd([]) ->
    return UnitType
  | BeginEnd(es) ->
    let rec check = function
      | [] -> return UnitType
      | [h] -> chk_expr h
      | h::t -> chk_expr h >>= fun _ -> 
                check t
    in check es
  | NewRef(e) ->
    chk_expr e >>= fun t ->
    return @@ RefType(t)
  | DeRef(e) ->
    chk_expr e >>= fun t ->
    (match t with
      | RefType(t) -> return t
      | _ -> error "deref: expected a reference type"
    )
  | SetRef(e1,e2) ->
    chk_expr e1 >>= fun t1 ->
    chk_expr e2 >>= fun t2 ->
    (* check e1 is a ref, then check e2 = e1's type *)
    (match t1 with
      | RefType(t) -> if(t=t2) 
                      then return UnitType 
                      else error "setref: types of ref and expr don't match"
      | _ -> error "setref: expected a reference type"
    )
  (* list *)
  | EmptyList(None) ->
    return @@ ListType(UnitType)
  | EmptyList(Some t) ->
    return @@ ListType(t)
  | Cons(h, t) ->
    chk_expr h >>= fun t1 ->
    chk_expr t >>= fun t2 ->
    (match t2 with
      | ListType(t) -> if(t1=t) 
                       then return @@ ListType(t) 
                       else error "cons: type of head and tail don't match"
      | _ -> error "cons: expected a list type"
    )
  | IsEmpty(e) ->
    chk_expr e >>= fun t ->
    (match t with
      | ListType(_) -> return BoolType
      | TreeType(_) -> return BoolType
      | _ -> error "isempty: expected a list type"
    )
  | Hd(e) ->
    chk_expr e >>= fun te ->
    (match te with
      | ListType(t) -> return t
      | _ -> error "hd: expected a list type"
    )
  | Tl(e) ->
    chk_expr e >>= fun te ->
    (match te with
      | ListType(t) -> return @@ ListType(t)
      | _ -> error "tl: expected a list type"
    )

  (* tree *)
  | EmptyTree(None) ->
    return @@ TreeType(UnitType)
  | EmptyTree(Some t) ->
    return @@ TreeType(t)
  | Node(de, le, re) ->
    chk_expr de >>= fun t1 ->
    chk_expr le >>= fun t2 ->
    chk_expr re >>= fun t3 ->
    (* t2 and t3 must be trees of same type as t1. *)
    if t2=TreeType(t1) && t3=TreeType(t1)
    then return @@ TreeType(t1)
    else error "node: types of data and subtrees don't match or subtrees aren't trees"
  | CaseT(target,emptycase,id1,id2,id3,nodecase) ->
    chk_expr target >>= fun tr ->
    chk_expr emptycase >>= fun tec ->
      (match tr with
      | TreeType(t) ->
          extend_tenv id1 t >>+
          extend_tenv id2 (TreeType(t)) >>+
          extend_tenv id3 (TreeType(t)) >>+
          chk_expr nodecase >>= fun tnc ->
          (* e2 and e3 must be of same type s *)
          if(tec=tnc)
          then return tnc
          else error "caseT: types of emptycase and nodecase don't match"
    | _ -> error "caseT: expected a tree type"
    )
  | Debug(_e) ->
    string_of_tenv >>= fun str ->
    print_endline str;
    error "Debug: reached breakpoint"
  | _ -> failwith "chk_expr: implement"    
and
  chk_exprs =
  fun es ->
  match es with
  | [] -> return []
  | h::tl -> chk_expr h >>= fun t ->
    chk_exprs tl >>= fun ts ->
    return (t::ts)
and
  chk_prog (AProg(_,e)) =
  chk_expr e

(* Type-check an expression *)
let chk (e:string) : texpr result =
  let c = e |> parse |> chk_prog
  in run_teac c

let chkpp (e:string) : string result =
  let c = e |> parse |> chk_prog
  in run_teac (c >>= fun t -> return @@ string_of_texpr t)