open Parser_plaf.Ast
open Parser_plaf.Parser
open Ds

(* SHIFT ENTER TO OPEN UTOP?? *)
let rec eval_expr : expr -> exp_val ea_result = fun e ->
  match e with
  | Int(n) ->
    return @@ NumVal n
  | Var(id) ->
    apply_env id
  | Add(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    return @@ NumVal (n1+n2)
  | Sub(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    return @@ NumVal (n1-n2)
  | Mul(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    return @@ NumVal (n1*n2)
  | Div(e1,e2) ->
    eval_expr e1 >>=
    int_of_numVal >>= fun n1 ->
    eval_expr e2 >>=
    int_of_numVal >>= fun n2 ->
    if n2==0
    then error "Division by zero"
    else return @@ NumVal (n1/n2)
  | Let(id,def,body) ->
    eval_expr def >>=
    extend_env id >>+
    eval_expr body
  | ITE(e1,e2,e3) ->
    eval_expr e1 >>=
    bool_of_boolVal >>= fun b ->
    if b
    then eval_expr e2
    else eval_expr e3
  | IsZero(e) ->
    eval_expr e >>=
    int_of_numVal >>= fun n ->
    return @@ BoolVal (n = 0)
  | Proc(id,_,e)  ->
    lookup_env >>= fun en ->
    return (ProcVal(id,e,en))
  | App(e1,e2)  -> 
    eval_expr e1 >>= 
    clos_of_procVal >>= fun (id,e,en) ->
    eval_expr e2 >>= fun ev ->
    return en >>+
    extend_env id ev >>+
    eval_expr e
  | Abs(e1)      ->
    eval_expr e1  >>=
    int_of_numVal >>= fun n ->
    return @@ NumVal (abs n)
  (* sequence [map ids to get id list] [map evs to get ev list] *)
  (* then extend env list *)
  | Record(fs) -> (* there's a bool before the value that we can disregard. *)
    sequence (List.map (fun (_,(_,e)) -> eval_expr e) fs) >>= fun evs ->
    let ids = List.map (fun (id,(_,_)) -> id) fs in (* need id to evaluate to type string *)
    extend_env_list ids evs >>+ 
    return @@ RecordVal (List.combine ids evs)
  | Proj(e,id) ->
    eval_expr e >>=
    fields_of_recordVal >>= fun f ->
    (match List.assoc_opt id f with
    | None -> error "Proj: field does not exist"
    | Some v -> return v
    )
  | Cons(e1, e2) ->
    failwith "implement me"
  | Hd(e1) ->
    failwith "implement me"
  | Tl(e1) ->
    failwith "implement me"
  | IsEmpty(e1)  ->
    eval_expr e1 >>=
    tree_of_treeVal >>= fun t ->
    return @@ BoolVal (t = Empty)
  | EmptyList(_)    ->
    failwith "implement me"
  | EmptyTree(_) ->
    return @@ TreeVal(Empty)
  | Node(e1,lte,rte) ->
    eval_expr e1 >>= fun v ->
    eval_expr lte >>=
    tree_of_treeVal >>= fun lnode ->
    eval_expr rte >>=
    tree_of_treeVal >>= fun rnode ->
    return @@ TreeVal(Node(v,lnode,rnode))
  | CaseT(target,emptycase,id1,id2,id3,nodecase) ->
    eval_expr target >>=
    tree_of_treeVal >>= fun t ->
    (match t with
    | Empty -> eval_expr emptycase
    | Node(v,l,r) -> 
      extend_env id1 v >>+
      extend_env id2 (TreeVal(l)) >>+ 
      extend_env id3 (TreeVal(r)) >>+
      eval_expr nodecase
    )
  | Tuple(es) ->
    failwith "implement me"
  | Untuple(ids,e1,e2) ->
    failwith "implement me"
  | Debug(_e) ->
    string_of_env >>= fun str ->
    print_endline str; 
    error "Debug called"
  | _ -> failwith "Not implemented yet!"
and
  eval_exprs : expr list -> (exp_val list) ea_result  = 
  fun es -> 
  match es with 
  | [] -> return [] 
  | h::t -> eval_expr h >>= fun i -> 
    eval_exprs t >>= fun l -> 
    return (i::l)
      
(** [eval_prog e] evaluates program [e] *)
let eval_prog (AProg(_,e)) =
  eval_expr e

(** [interp s] parses [s] and then evaluates it *)
let interp (e:string) : exp_val result =
  let c = e |> parse |> eval_prog
  in run c