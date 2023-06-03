(* Quiz 1 - 1 June 2023 

   Student name 1: Issac Zheng
   Student name 2: Ryan Hu
   Pledge: I pledge my honor that I have abided by the Stevens Honor System.
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
(* fst (x,y) = x, snd (x,y) = y *)

let rec outgoing_nodes g n =
  match g with
  | [] -> []
  | h::t -> if fst h = n then snd h :: outgoing_nodes t n else outgoing_nodes t n

(** [nodes g] returns the list of nodes of the graph [g] without duplicates. 
   The order of the nodes in the list is irrelevant.
   eg. nodes ex => [1,2,3,4] 
*)

let rec nodes g =
  match g with
  | [] -> []
  | (x,y)::t ->
    if (List.mem x (nodes t)) && (List.mem y (nodes t)) then nodes t
    else if (List.mem x (nodes t)) then y::nodes t
    else if (List.mem y (nodes t)) then x::nodes t
    else x::y::nodes t
  
(** [degree g] returns the degree of [g]. The degree of a graph is 
    the maximum number of outgoing edges that any node has. 
*)
let rec degree g =
  match g with
  | [] -> 0
  | h::t -> 
    if List.length (outgoing_nodes g (fst h)) > degree t 
    then List.length (outgoing_nodes g (fst h)) 
    else degree t

(** [remove g n] removes node [n] and all the edges involving [n], from
   the graph [g].
   Eg. remove ex 2 =>  [(3, 1); (3, 4)] 
*)
let rec remove g n =
  match g with
  | [] -> []
  | h::t ->
    if fst h != n && snd h != n
    then h::remove t n
    else  remove t n
  
(** [reachable g n] returns the list of all the reachable nodes from
   node [n] in [g]. (Extra-credit)
   Eg. reachable ex 3 => [1,4,2,3] 
*)

let rec reachable g n =
  match g with
  | [] -> []
  | h::t -> 
    if fst h = n then snd h :: reachable t n
    else if snd h = n then fst h :: reachable t n
    else reachable t n 
    (* missing 3, figure how to include *)


(* teacher answers *)
let rec outgoing_nodes' g n =
  match g with 
  | [] -> []
  | (src,tgt)::t -> 
    if src = n \
      then y::outgoing_nodes tgt n 
    else outgoing_nodes tgt n

let outgoing_nodes'' g n =
  List.map snd @@ List.filter (fun (src, tgt) -> src = n) g


let rec nodes_helper g = (* makes a list of all items in tuples in g *)
  match g with
  | [] -> []
  | (src, tgt)::t -> src::tgt::nodes_helper t

let rec rem_dupes l =
  match l with
  | [] -> []
  | h::t ->
    if List.mem h t 
    then rem_dupes t
    else h::rem_dupes t

let rec nodes' g =
  rem_dupes (nodes_helper g)

let rec maxl l =
  match l with
  | [] -> failwith "maxl: undefined"
  | [i] -> i
  | h1::h2::t -> max h1 (max (h2::t))
  
let rec degree' g = 
  maxl (List.map List.length (List.map (outgoing_nodes g) (nodes g)))
  (* could also sort the list of lengths and return first el*)

let rec remove' g n =
  List.filter (fun (src, tgt) -> src != n && tgt != n) g
  
(* reachable is bst ;=; *)
let rec diff l1 l2 =
  match l1 with
  | [] -> []
  | h::t ->
    if List.mem h l2
    then diff t l2
    else h::diff t l2
  
let rec reachable' g n =
  let rec helper visited current = 
    match current with
    | [] -> visited
    | h::t ->
      let next = outgoing_nodes g h
      in helper (h::visited) (t @ diff next visited)
  in helper [] [n]
