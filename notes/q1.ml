(* Quiz 1 - 1 June 2023 

   Student name 1: 
   Student name 2:
   Pledge:
*)


(* Notes: 
    a. You may add helper functions.
    b. "let rec" allows your function to be recursive, but it doesn't
    have to be. 
*)

(* Sample Directed Graph *)

let ex = [(1, 2); (2, 3); (3, 1); (3, 4)]


(*
  1 <------ 3
  |      //||
  |     /   | 
  |    /    | 
 \/  /     \/
  2        4
*)
       

(** [outgoing g n] returns the list of all the nodes that are
    immediate neighbors of [n] in [g].
    Eg. outgoing ex 3 => [1,4] 
*)
let rec outgoing_nodes g n =
  match g with
  | [] -> []
  | (src,tgt)::t ->
    if src=n
       then tgt::outgoing_nodes t n
       else outgoing_nodes t n

let outgoing_nodes' g n =
  List.map snd @@ List.filter (fun (src,tgt) -> src=n) g

let rec outgoing_nodes'' g n =
  match g with
  | [] -> []
  | h::t ->
    if fst h =n
       then snd h::outgoing_nodes'' t n
       else outgoing_nodes'' t n
           
(** [nodes g] returns the list of nodes of the graph [g] without duplicates. 
   The order of the nodes in the list is irrelevant.
   eg. nodes ex => [1,2,3,4] 
*)
           
let rec nodes_helper g =
  match g with
  | [] -> []
  | (src,tgt)::t ->
    src::tgt::nodes_helper t

let rec mem e l =
  match l with
  | [] -> false
  | h::t -> (e=h) || mem e t
              
let rec rem_dups l =
  match l with
  | [] -> []
  | h::t ->
    if List.mem h t
    then rem_dups t
    else h::rem_dups t
           
let rec nodes g =
  rem_dups (nodes_helper g)

(** [degree g] returns the degree of [g]. The degree of a graph is 
    the maximum number of outgoing edges that any node has. 
*)

let rec maxl l =
  match l with
  | [] -> failwith "maxl: undefined"
  | [i] -> i
  | h1::h2::t -> max h1 (maxl (h2::t))
                   
let rec degree g =
  maxl (List.map List.length (List.map (outgoing_nodes g) (nodes g)))

(** [remove g n] removes node [n] and all the edges involving [n], from
   the graph [g].
   Eg. remove ex 2 =>  [(3, 1); (3, 4)] 
*)
let rec remove g n =
  List.filter (fun (src,tgt) -> src!=n && tgt!=n) g
  
(** [reachable g n] returns the list of all the reachable nodes from
   node [n] in [g]. (Extra-credit)
   Eg. reachable ex 3 => [1,4,2,3] 
*)

let rec diff l1 l2 =
  match l1 with
  | [] -> []
  | h::t ->
    if List.mem h l2
    then diff t l2
    else h::diff t l2
           
let rec reachable g n =
  let rec helper visited current =
    match current with
    | [] -> visited
    | h::t ->
      let next = outgoing_nodes g h
      in helper (h::visited) (t @ diff next visited)
    in helper [] [n]

