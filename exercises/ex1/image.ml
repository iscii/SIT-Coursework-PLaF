(* > OCaml: Open with REPL *)
(* # #cd "SIT-Coursewprk-PLaF";; *) (* ... *)
(* # #use "image.ml";; *)

(* h for head, t for tail. if function has head and tail... *)

let letter_e = [0;2;2;3;3;5;5;4;3;5;4;3;3;5;5;1]

let rotate_90_instr i = 
  match i with
  | 0 | 1 -> i
  | 2 -> 3
  | 3 -> 4
  | 4 -> 5
  | 5 -> 2

(* let rec rotate_90 : program - > program = *)
let rec rotate_90 p = 
  match p with
  | [] -> []
  | h::t -> rotate_90_instr h :: rotate_90 t

(* let rec repeat: int -> 'a -> 'a list = *)
let rec repeat n e =
  match n with 
  | 0 -> [] 
  | m -> e :: repeat (n-1) e

(* let rec pantagraph : int -> program -> program = *)
let rec pantagraph n p =
  match p with
  | [] -> []
  | 0::t -> 0::pantagraph n t
  | 1::t -> 1::pantagraph n t
  | h::t -> repeat n h @ pantagraph n t (* @ allows adding a list of lists. *)
  (* | h::t -> repeat n h :: pantagraph n t *) (* repeat n h returns a list but we need only a single element. we can only either add a list of elements or a list of lists. *)

let next (x,y) i =
  match i with
  | 0 | 1 -> (x,y)
  | 2 -> (x,y+1)
  | 3 -> (x+1,y)
  | 4 -> (x,y-1)
  | 5 -> (x-1,y)
  | _ -> failwith "invalid instruction" (* _ is a wildcard. "anything else shouldn't happen. could assert false or failwith message." *)

let rec coverage (x,y) p = 
  match p with
  | [] -> [(x,y)]
  | h::t -> (x,y) :: coverage (next (x,y) h) t

(* needs to somehow have a counter that counts when we see an instruction and stop when we see a new instruction *)
let rec compress_helper n p = (* instruction counter *)
  match p with
  | [] -> [] (* if the list is empty, there are no more instructions inside to account for *)
  | [h] -> [(n+1,h)] (* h is a var that represents any instruction we might have -> if the list has one element inside*)
  | h1::h2::t when h1=h2 -> compress_helper (n+1) (h2::t) (* if the list has two or more elements inside. ::t -> or more. h1=h2 when first and second element are equal. increment counter by 1 if h1=h2.*)
  | h1::h2::t -> (n+1,h1)::compress_helper 0 (h2::t)(* t is tail. when list has h1 and h2 but h1 != h2. when h1!=h2, counter goes down to 0*)  
    
(* get list of occurences of each number in letter_e *)
let compress p = 
  compress_helper 0 p


(* 
  if we load the file, it defines all the functions in the utop session.
  we can comment out the function, and
if we load it again in the same session, even if the function is being used
  in another function that is not commented out/defined, there will be no errors.
  bc the function was defined by a previous load of the file.
  must restart utop session to clear function definitions and avoid errors.
*)
(* do uncompress and optimize *)

(* h::t -> t can be broken down into h1::h2::t, a list of patterns) *)

(* 
  high order: takes in or returns a function
  polymorphic: can evaluate or be applied to values of different types (generalized)
  + is an infix operator and needs to be between two operands.
    can be turned into a function with # (+)
    ((+)1) now is a function that waits for a number to return the num + 1.
*)

(* @ is append *)

(* Constructors start with a capital letter *)

(* quizzes in groups of 2 *)
(* coding exercise -> ocaml, exercise on lists *)
(* take a look at inductive definitions *)