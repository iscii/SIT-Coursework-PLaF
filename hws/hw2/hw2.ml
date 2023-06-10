(*  
  * Issac Zheng
  * CS 496
  * I pledge my honor that I have abided by the Stevens Honor System   
*)

(* Nodes of binary decision trees must have two leaves or none at all. *)
type dTree = 
  | Leaf of int
  | Node of char * dTree * dTree

let tLeft = Node('w', Node('x', Leaf(2), Leaf(5)), Leaf(8))
let tRight = Node('w', Node('x', Leaf(2), Leaf(5)), Node('y', Leaf(7), Leaf(5)))

(* let rec height (t: dTree): int = ... is apparently viable syntax that actually type defines its variables for better readability? *)
let rec height: dTree -> int = 
  fun t ->
    match t with
    | Leaf(v) -> 1
    | Node(v, l, r) -> 1 + max (height l) (height r)

let rec size: dTree -> int = 
  fun t ->
    match t with
    | Leaf(v) -> 1
    | Node(v, l, r) -> 1 + (size l) + (size r)

(* 0: left, 1: right *)
let rec paths: dTree -> int list list = 
  fun t ->
    match t with
    | Leaf(v) -> [[]]
    | Node(v, l, r) -> 
      let left = List.map (fun x -> 0::x) (paths l) in
      let right = List.map (fun x -> 1::x) (paths r) in
      left @ right

(* a tree is perfect if the number of nodes = 2^height - 1 *)
let rec is_perfect: dTree -> bool =
  fun t -> (size t) = int_of_float (2.0**(float_of_int (height t))) - 1

let rec map: (char -> char) -> (int -> int) -> dTree -> dTree = 
  fun f g t -> 
    match t with
    | Leaf(v) -> Leaf(g v)
    | Node(v, l, r) -> Node(f v, map f g l, map f g r)

let rec list_to_tree: char list -> dTree = 
  fun l ->
    match l with
    | [] -> Leaf(0)
    | h::t -> Node(h, list_to_tree t, list_to_tree t)

let rec set_leaf: dTree -> int list -> int -> dTree = 
  fun tr p vl ->
    match tr with
    | Leaf(v) -> Leaf(vl)
    | Node(v, l, r) ->
      match p with 
      | [] -> Node(v, l, r)
      | h::t ->
        if h==0 then
          Node(v, set_leaf l t vl, r)
        else
          Node(v, l, set_leaf r t vl)

let rec replace_leaf_at: dTree -> (int list * int) list -> dTree = 
  fun tr f ->
    match f with
    | [] -> tr
    | (p, vl)::t -> replace_leaf_at (set_leaf tr p vl) t

let rec bf_to_tree: (char list) * ((int list * int) list) -> dTree = 
  fun (l, f) -> replace_leaf_at (list_to_tree l) f

(* bf_to_tree (['x';'y';'z'], [([0;0;0], 0);([0;0;1] , 1);([0;1;0] , 1);([0;1;1] , 0);([1;0;0] , 1);([1;0;1] , 0);([1;1;0] , 0);([1;1;1] , 1)]);; *)
(* - : dTree =
  Node ('x', Node ('y', Node ('z', Leaf 0, Leaf 1), Node ('z', Leaf 1, Leaf 0)),
  Node ('y', Node ('z', Leaf 1, Leaf 0), Node ('z', Leaf 0, Leaf 1)))
*)