(* 
   Variant Types
   1 June 2023
*)


(* Variant Types or Algebraic Data Types *)


type dow = Mon | Tue | Wed | Thu | Fri | Sat | Sun

let next d =
  match d with
  | Mon -> Tue
  | Tue -> Wed
  | Wed -> Thu
  | Thu -> Fri
  | Fri -> Sat
  | Sat -> Sun
  | Sun -> Mon

let is_weekend d =
  match d with
  | Sat | Sun -> true
  | _ -> false

(* Example of constructors with arguments *)
    
type flavor = Van | Cho | Str
type ic = Cup of flavor | Cone of flavor*flavor |
          Bucket of flavor list

let ic1 = Cup(Van)
let ic2 = Cone(Van,Cho)
let ic3 = Bucket ([Van;Cho;Van;Str])

let cost ic =
  match ic with
  | Cup(_) -> 1
  | Cone(_,_) -> 2
  | Bucket(_) -> 5

let is_boring ic =
  match ic with
  | Cup(Van) -> true
  | Cone(Van,Van) -> true
  | Bucket l -> List.for_all ((=)Van) l
  | _ -> false

(* polymorphic variants *)

(* let rec find k d = *)
(*   match d with *)
(*   | [] -> -1 *)
(*   | (k',v)::t -> *)
(*     if k=k' *)
(*     then v *)
(*     else find k t *)

type 'a option = None | Some of 'a
               
let rec find : 'a -> ('a*'b) list -> 'b option =
  fun k d ->
  match d with
  | [] -> None
  | (k',v)::t ->
    if k=k'
    then Some v
    else find k t


type ('a,'b) either = Left of 'a | Right of 'b

(* recursive variants *)

type 'a bt = Empty | Node of 'a *'a bt*'a bt

(*

       33
      /  \
     12   44
         /  \
        37   77

[33;12;44;37;77]
[12;33;37;44;77]
*)

let t:int bt =
  Node(33,
       Node(12,Empty,Empty),
       Node(44,
            Node(37,Empty,Empty),
            Node(77,Empty,Empty)))


let rec size t =
  match t with
  | Empty -> 0
  | Node(d,lt,rt) -> 1 + size lt + size rt

let rec sum t =
  match t with
  | Empty -> 0
  | Node(d,lt,rt) -> d + sum lt + sum rt

let rec po t =
  match t with
  | Empty -> []
  | Node(d,lt,rt) -> [d] @ po lt @ po rt

let rec io t =
  match t with
  | Empty -> []
  | Node(d,lt,rt) -> io lt @ [d] @ io rt

let rec mirror t =
  match t with
  | Empty -> Empty
  | Node(d,lt,rt) -> Node(d,mirror rt,mirror lt)

let rec map f t =
  match t with
  | Empty -> Empty
  | Node(d,lt,rt) -> Node(f d,map f lt, map f rt)

let rec no_of_leaves t =
  match t with
  | Empty -> 0
  | Node(d,Empty,Empty) -> 1
  | Node(d,lt,rt) -> no_of_leaves lt + no_of_leaves rt




                        
