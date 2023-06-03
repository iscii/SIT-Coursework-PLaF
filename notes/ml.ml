
(* Practice exercises: Mini Logo 
   30 May 2023
*)

type program = int list (* synonyms *)

let square : program = [0; 2; 2; 3; 3; 4; 4; 5; 5; 1]
let letter_e : program = [0;2;2;3;3;5;5;4;3;5;4;3;3;5;5;1]

let mirror_image_instr : int -> int =
  fun i ->
  match i with
  | 0 | 1 -> i
  | 2 -> 4
  | 3 -> 5
  | 4 -> 2
  | 5 -> 3
  | _ -> assert false
    
let rec mirror_image : program -> program =
  fun p ->
  match p with
  | [] -> []
  | h::t ->  mirror_image_instr h :: mirror_image t

let rotate_90_instr : int -> int =
  fun i ->
  match i with
  | 0 | 1 -> i
  | 2 -> 3
  | 3 -> 4
  | 4 -> 5
  | 5 -> 2
  | _ -> assert false
    
let rec rotate_90 : program -> program =
  fun p ->
  match p with
  | [] -> []
  | h::t ->  rotate_90_instr h :: rotate_90 t

let rec repeat : int -> 'a -> 'a list =
  fun n e ->
  match n with
  | 0 -> []
  | m -> e :: repeat (n-1) e


let rec pantograph : int -> program -> program =
  fun n p ->
  match p with
  | [] -> []
  | 0::t -> 0::pantograph n t
  | 1::t -> 1::pantograph n t
  | h::t -> repeat n h @ pantograph n t

let next : int*int -> int -> int*int =
  fun (x,y) i ->
  match i with
  | 0 | 1 -> (x,y)
  | 2 -> (x,y+1)
  | 3 -> (x+1,y)
  | 4 -> (x,y-1)
  | 5 -> (x-1,y)
  | _ -> assert false
    
let rec coverage (x,y) p =
  match p with
  | [] -> [(x,y)]
  | h::t -> (x,y) :: coverage (next (x,y) h) t 

let rec compress_helper n p =
  match p with
  | [] -> []
  | [h] -> [(n+1,h)]
  | h1::h2::t when h1=h2 -> compress_helper (n+1) (h2::t)
  | h1::h2::t -> (n+1,h1)::compress_helper 0 (h2::t)
    
let compress p =
  compress_helper 0 p 

