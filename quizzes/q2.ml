(* 
     Quiz 2 - 6 June 2023

     Name1: Issac Zheng

     Name2: Ryan Hu

 *)

type 'a bt = Empty |  Node of 'a*'a bt*'a bt

(* Helper function that builds a leaf *)
let leaf n = Node(n,Empty,Empty)

(* Two sample binary trees.
   The first one is a BST, but not the second one *)
let t1 : int bt = Node(12,
                       Node(7,Empty,leaf 10),
                       Node(24,
                            leaf 14,
                            Empty))

let t2 : int bt = Node(12,
                       leaf 7,
                       Node(24,
                            leaf 30,
                            Empty))

(** returns smallest element in non-empty tree [t].
    Fails if [t] is empty, it should fail. 
    Note: the tree [t] is not assumed to be a bst *)
let rec mint : 'a bt -> 'a =
  fun t ->
    match t with
    | Empty -> failwith "Empty tree"
    | Node (v, Empty, Empty) -> v
    | Node (v, Empty, r) -> min v (mint r)
    | Node (v, l, Empty) -> min v (mint l)
    | Node (v, l, r) -> min v (min (mint l) (mint r))
  
(** returns largest element in non-empty tree [t].
    Fails if [t] is empty, it should fail. 
    Note: the tree [t] is not assumed to be a bst *)
let rec maxt : 'a bt -> 'a =
  fun t ->
    match t with
    | Empty -> failwith "Empty tree"
    | Node (v, Empty, Empty) -> v
    | Node (v, Empty, r) -> max v (maxt r)
    | Node (v, l, Empty) -> max v (maxt l)
    | Node (v, l, r) -> max v (max (maxt l) (maxt r))

(** [is_bst t] determines whether the binary tree [t] is a binary search tree *)
let rec is_bst : 'a bt -> bool =
  fun t ->
    match t with
    | Empty -> true
    | Node (v, Empty, Empty) -> true
    | Node (v, Empty, r) -> (v < (mint r)) && (is_bst r)
    | Node (v, l, Empty) -> (v > (maxt l)) && (is_bst l)
    | Node (v, l, r) -> (v < (mint r)) && (v > (maxt l)) && (is_bst l) && (is_bst r)

(** [add k t] adds key [k] to the bst [t]. 
    Should fail with failwith if [k] is already in the tree.
    Otherwise, returns updated tree *)
let rec add : 'a -> 'a bt -> 'a bt =
  fun k t ->
    match t with
    | Empty -> leaf k
    | Node (v, l, r) -> 
      if k = v then failwith "Key already in tree"
      else if k < v then Node (v, (add k l), r)
      else Node (v, l, (add k r))
           
(** [rem k t] removes key [v] from the BST [t] 
   Should fail with failwith if [k] is not in tree
   (Extra-credit) *)
(* grab the inorder predecessor or successor *)
(* use a helper function *)
let rec rem : 'a -> 'a bt -> 'a bt =
   fun k t ->
    match t with
    | Empty -> failwith "Key not in tree"
    | Node (v, Empty, Empty) -> 
      if k = v then Empty else failwith "Key not in tree"
    | Node (v, Empty, r) -> 
      if k = v then r else Node (v, Empty, (rem k r))
    | Node (v, l, Empty) ->
      if k = v then l else Node (v, (rem k l), Empty)
    | Node (v, l, r) -> 
      if k = v then Node ((mint l), (rem (mint l) l), r)
      else if k < v then Node (v, (rem k l), r)
      else Node (v, l, (rem k r))

let rec rem': 'a -> 'a bt -> 'a bt =
  fun k t ->
    match t with
    | Empty -> failwith "Key not in tree"
    | Node(v, l, r) when k=v ->
      (match l, r with
        | Empty, Empty -> Empty
        | l, Empty -> l
        | Empty, r -> r
        | l, r -> 
          let max_in_l = maxt l (* take the largest child (rightmost) node *)
          in Node(max_in_l, rem max_in_l l, r))
    | Node(v, l, r) -> 
      if k<v
      then Node(v, rem k l, r)
      else Node(v, l, rem k r)