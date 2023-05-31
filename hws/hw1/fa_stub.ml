
(* Issac Zheng *)
(* I pledge my honor that I have abided by the Stevens Honor System. *)

(* ******************************************** *)
(** Basic functions on finite automata *)
(* ******************************************** *)
(**
   Code stub for assignment 1
*)

type symbol = char
type input = char list (* synonym -> kinda like an alias, defining input with the same function as 'char list' so they can be used in place of it. Just for type definition and readability.*)

type state = string

(* transition function *)
type tf = (state * symbol * state) list

(* initial state * transition function * end state *)
type fa = { states: state list; start:state; tf: tf; final: state list}


(* ******************************************** *)
(* Examples of automata *)
(* ******************************************** *)

let a1 = {states = ["q0";"q1";"q2"];
         start = "q0";
         tf = [("q0",'a',"q1"); ("q1",'b',"q1"); ("q1",'c',"q2")];
         final = ["q2"]}

let a2 = {states = ["q0";"q1";"q2";"q3"];
          start = "q0";
          tf = [("q0",'a',"q1"); ("q0",'a',"q3"); ("q1",'b',"q1")
               ; ("q1",'c',"q2")];
          final= ["q2";"q3"]
         }

let a3 = {states = ["q0";"q1";"q2";"q3";"q4";"q5";];
          start = "q0";
          tf = [("q0",'a',"q1"); ("q1",'b',"q1"); ("q1",'b',"q3")
               ; ("q1",'c',"q2");  ("q3",'a',"q4"); ("q5",'a',"q4")];
          final= ["q2"]
         }

(* ******************************************** *)
(* Helper functions *)
(* ******************************************** *)

let input_of_string s =
  let rec exp i l = (* let rec is a recursive function declaration *)
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []


(* ******************************************** *)
(* Simulating automata *)
(* ******************************************** *)

(* let _ = print_char (List.nth (input_of_string "abc") 0); *)

(* apply_transition_function: tf -> symbol -> state -> state list *)

let rec apply_transition_function tf a q =
  match tf with
  | [] -> [] (* if tf is empty, return empty list *)
  | (q1, a1, q2)::t -> if (q1 = q && a1 = a) then q2::(apply_transition_function t a q) (* otherwise if q1 = q and a1 = a, return q2 and apply transition function to the rest of the list *)
                       else apply_transition_function t a q;; (* otherwise, apply transition function to the rest of the list *)

                       