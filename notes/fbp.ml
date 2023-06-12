(*
       Quiz 2 - Fruit Basket Processors
  
       8 Feb 2023

       Name 1:
       Name 2:
       Pledge:
*)

type 'a result = Ok of 'a | Error
type fruit = A | O | K
(* type 'a basket = Empty | Add of 'a*'a basket *)
type 'a basket = 'a list

(* Sample fruit baskets *)
(* let fb1 : fruit basket = Add(A,Add(A,Add(O,Add(A,Add(K,Add(K,Empty)))))) *)
(* let fb2 : fruit basket = Add(A,Add(A,Add(A,Add(A,Empty)))) *)
let fb1 : fruit basket = [A;A;O;A;K;K]
let fb2 : fruit basket = [A;A;A;A]

(* 
   A fruit basket processor is any expression whose type is:

      fruit basket -> t result

   for any type t. Some examples of types that have this form are: 
   Eg. fruit basket -> int result
   Eg. fruit basket -> bool result
   Eg. fruit basket -> (fruit basket) result

   A fruit basket processor analyzes a fruit basket and can:
   1. Either, fail (Error)
   2. Or, succeed (Ok v, where v the result of processing it)
*)

(* 
   Implement the following fruit basket processors.
   NOTE: You are free to add the "rec" keyword just after the "let", if needed.
 *)
    
(** [no_of_oranges fb] fruit basket processor that returns the number of oranges in the fruit basket [fb].
    Eg. no_of_oranges fb1 => Ok 1
*)
                   
let no_of_oranges : fruit basket -> int result =
  fun fb ->
  Ok (List.length (List.filter ((=)O) fb))
    
let no_of_apples : fruit basket -> int result =
  fun fb ->
  Ok (List.length (List.filter ((=)A) fb))

(** [has_apples fb] fruit basket processor that determines whether there are apples in [fb] 
    Eg. has_apples fb1 => Ok true *)
let has_apples : fruit basket -> bool result =
  fun fb ->
   Ok (List.mem A fb)


(** [apples_to_oranges_ratio fb] fruit basket processor that returns
    the quotient between the number of apples and the number of
    oranges in [fb].
    It should return [Error] if there are no oranges. 
    Eg. apples_to_oranges_ratio fb1 => Ok 3
        apples_to_oranges_ratio fb2 => Error
*)


let apples_to_oranges_ratio : fruit basket -> int result =
  fun fb ->
  let a = List.length (List.filter ((=)A) fb)
  and o = List.length (List.filter ((=)O) fb)
  in if o=0
  then Error
  else Ok (a/o)


(** [apples_to_kiwis_ratio fb] fruit basket processor that returns
    the quotient between the number of apples and the number of
    kiwis in [fb].
    It should return [Error] if there are no kiwis. 
    Eg. apples_to_kiwis_ratio fb1 => Ok 1
        apples_to_kiwis_ratio fb2 => Error
*)
let apples_to_kiwis_ratio : fruit basket -> int result =
  fun fb ->
  let a = List.length (List.filter ((=)A) fb)
  and k = List.length (List.filter ((=)K) fb)
  in if k=0
  then Error
  else Ok (a/k)


(*

no_of_oranges : fruit basket -> int result 
no_of_apples : fruit basket -> int result 
has_apples : fruit basket -> bool result 
apples_to_oranges_ratio : fruit basket -> int result 
apples_to_kiwis_ratio : fruit basket -> int result 

*)

(** [ratio_sum fb] fruit basket processor that returns the sum of the
    apples-to-oranges ratio and the apples-to-kiwis ration in [fb].
    IMPORTANT: YOU MUST USE [apples_to_oranges_ratio] AND
    [apples_to_kiwis_ratio] FROM ABOVE.
    Eg. ratio_sum fb1 => Ok 4
        ratio_sum fb2 => Error
*)
let ratio_sum : fruit basket -> int result =
  fun fb ->
  match apples_to_oranges_ratio fb with
  | Error -> Error
  | Ok m ->
    (match apples_to_kiwis_ratio fb with
     | Error -> Error
     | Ok n -> Ok (m+n))

let ratio_pair : fruit basket -> (int*int) result =
  fun fb ->
  match apples_to_oranges_ratio fb with
  | Error -> Error
  | Ok m ->
    (match apples_to_kiwis_ratio fb with
     | Error -> Error
     | Ok n -> Ok (m,n))

let (>>=) =
  fun c f ->
  fun fb ->
  match c fb with
  | Error -> Error
  | Ok m -> f m fb

let ratio_sum' =
  apples_to_oranges_ratio >>= fun m ->
  apples_to_kiwis_ratio >>= fun n ->
  (fun _fb -> Ok (m+n))

let ratio_pair' =
  apples_to_oranges_ratio >>= fun m ->
  apples_to_kiwis_ratio >>= fun n ->
  (fun _fb -> Ok (m,n))
  
