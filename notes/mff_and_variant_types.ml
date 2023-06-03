(* 
   Useful higher-order function schemes 
   30 May 2023
*)

(* map *)

let succ i = i+1
let upper c = Char.uppercase_ascii c
let isz i = i=0
            
let rec succl : int list -> int list =
  fun l ->
  match l with
  | [] -> []
  | h::t -> succ h :: succl t

let rec upperl : char list -> char list =
  fun l ->
  match l with
  | [] -> []
  | h::t -> upper h :: upperl t

let rec is_zerol : int list -> bool list =
  fun l ->
  match l with
  | [] -> []
  | h::t -> isz h :: is_zerol t

let rec map : ('a -> 'b) -> 'a list -> 'b list =
  fun f l ->
  match l with
  | [] -> []
  | h::t -> f h :: map f t

let succl' l = map succ l
let upperl' l = map upper l
let is_zerol' l = map isz l

let succl'' l = map ((+)1) l
let upperl'' l = map Char.uppercase_ascii l
let is_zerol'' l = map (fun i -> i>0) l

(* filter *)
    
let is_positive i = i>0
let is_upper c = c=Char.uppercase_ascii c
let is_ne l = l!=[] 

let rec fgz : int list -> int list =
  fun l ->
  match l with
  | [] -> []
  | h::t ->
    if is_positive h
    then h::fgz t
    else fgz t

let rec fupper : char list -> char list =
  fun l ->
  match l with
  | [] -> []
  | h::t ->
    if is_upper h
    then h::fupper t
    else fupper t

let rec fne : 'a list list -> 'a list list =
  fun l ->
  match l with
  | [] -> []
  | h::t ->
    if is_ne h
    then h::fne t
    else fne t
          

let rec filter : ('a -> bool) -> 'a list -> 'a list =
  fun p l ->
  match l with
  | [] -> []
  | h::t ->
    if p h
    then h::filter p t
    else filter p  t

let fgz' l = filter is_positive l
let fupper' l = filter is_upper l
let fne' l = filter is_ne l

(* fold *)

let rec suml : int list -> int =
  fun l ->
  match l with
  | [] -> 0
  | h::t -> h + suml t

let rec andl : bool list -> bool =
  fun l ->
  match l with
  | [] -> true
  | h::t -> h && andl t

let rec flatten : 'a list list -> 'a list =
  fun l ->
  match l with
  | [] -> []
  | h::t -> h @ flatten t

let rec foldr : ('a -> 'b -> 'b ) -> 'b -> 'a list -> 'b =
  fun f a l ->
  match l with
  | [] -> a
  | h::t -> f h (foldr f a t)

(* foldr f [x;y;z]
==>
 f x (f y (f z a))
*)
              
let suml' l = foldr (+) 0 l
let andl' l = foldr (&&) true l
let flatten' l = foldr (@) [] l
(*

andl [true;true]
=>
true && andl [true]
=>
true && (true && andl [])
=>
true && (true && false)

*)

(* Variant Types or Algebraic Data Types *)


(* enums *)
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
type ic = Cup of flavor | Cone of flavor*flavor | Bucket of flavor list

let ic1 = Cup(Van)
let ic2 = Cone(Van,Cho)
let ic3 = Bucket([Van;Cho;Van;Str])

(* Disjoint Unions allow for lists of different types ( using constructors ) *)
(* [1, true] -> error *)
type ('a, 'b) either = Left of 'a | Right of 'b
(* [Left 1, Right true] -> list of (int, bool), Left types represent ints, Right types represent true. *)
