(* 
    Linked lists 
    15 June 2023

    This code illustrates the use of mutable fields in records as a
 means to implement mutable data structures, in particular linked
 lists.
    
*)

type 'a node = { mutable data: 'a;
                 mutable next: 'a node option}

type 'a ll = { mutable head: 'a node option;
               mutable size: int }

let l1 : 'a ll = (* Empty list *)
  { head = None ;
    size = 0}

let l2 : int ll = 
  { head = Some ( { data = 1;
                    next = Some ( { data=2;
                                    next=None})});
    size = 2}

let add_first : 'a ll -> 'a -> unit =
  fun l item ->
  l.head <- Some ({ data=item; next=l.head});
  l.size <- l.size+1

let map : ('a -> 'b) -> 'a ll -> unit =
  fun f l ->
  let rec maph : ('a node) option -> unit =
    fun no ->
    match no with
    | None -> ()
    | Some n ->
      n.data <- f n.data;
      maph n.next
  in maph l.head

let clone : 'a ll -> 'a ll =
  fun l ->
  let rec cloneh no =
    match no with
    | None -> None
    | Some n ->
      Some (
        { data = n.data;
          next = cloneh n.next
        })
  in
  { head = cloneh l.head;
    size = l.size } 

let string_of_ll : 'a ll -> ('a -> string) -> string =
  fun l f ->
  let rec solh on =
    match on with
    | None -> ""
    | Some n ->
        f (n.data) ^ ";" ^ solh n.next
    in solh l.head

let list_of_ll : 'a ll -> 'a list =
  fun l ->
  let rec lolh on =
    match on with
    | None -> []
    | Some n -> n.data :: lolh n.next
    in lolh l.head

let string_of_ll' : 'a ll -> ('a -> string) -> string =
  fun l f  ->
  "[" ^ (String.concat ";" @@ List.map f (list_of_ll l)) ^ "]"


(** [add l item i] adds [item] at index [i] in [l]. If i is out of
 ** bounds then it issues a Failure exception (failwith) *)
let add : 'a ll -> 'a -> int -> unit =
  fun l item i ->
  failwith "implement"  

(** Issues a Failure exception (failwith) if list is empty *)
let remove_first : 'a ll -> unit =
  fun l ->
  failwith "implement"

(** Issues a Failure exception (failwith) if list is empty *)
let remove_last : 'a ll -> unit =
  fun l ->
  failwith "implement"

(** [remove l i] removes item at index [i] in [l]. If i is out of
 ** bounds then it issues a Failure exception (failwith) *)
let remove : 'a ll -> int -> unit =
  fun l i ->
  failwith "implement"



 
