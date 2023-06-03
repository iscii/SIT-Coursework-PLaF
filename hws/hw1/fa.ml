
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
type fa = { states: state list; start: state; tf: tf; final: state list}


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

let rec in_list: 'a -> 'a list -> bool = 
  fun i li ->
    match li with
    | [] -> false
    | h::t when (i = h) -> true
    | h::t -> in_list i t
  
(* applies a bool function to every item in 'a list against 'b list *)
let rec every: ('a -> 'b list -> bool) -> 'a list -> 'b list -> bool =
  fun f i li->
    match i with
    | [] -> true
    | h::t -> if (f h li) then every f t li else false

(* checks if list has any duplicate items *)
let rec has_duplicate: 'a list -> bool =
  fun li ->
    match li with
    | [] -> false
    | h::t -> if (List.mem h t) then true else has_duplicate t


(* sts = state start, sy = symbol, stf = state final *)
let get_sts (sts, sym, stf) = sts
let get_sym (sts, sym, stf) = sym
let get_stf (sts, sym, stf) = stf

(* ******************************************** *)
(* Simulating automata *)
(* ******************************************** *)

let rec apply_transition_function: tf -> symbol -> state -> state list =
  fun f sym st ->
    match f with
    | [] -> []
    | h::t when (get_sts h = st && get_sym h = sym) -> (get_stf h)::apply_transition_function t sym st
    | h::t -> apply_transition_function t sym st

(* MORE HELPERS ----- *)
(* apply transition function to a list of states and a given symbol, and get a list of resulting states *)
let rec get_result_states: fa -> symbol -> state list -> state list =
  fun fa sy stl ->
    match stl with
    | [] -> []
    | h::t -> apply_transition_function fa.tf sy h @ get_result_states fa sy t
let rec get_final_states: fa -> input -> state list -> state list = 
  fun fa i stl ->
    match i with
    | [] -> []
    | [h] -> get_result_states fa h stl (* t is [] -> last item -> get_Result_states fa h fa.start*)
    | h::t -> get_final_states fa t (get_result_states fa h stl) (* t is [] -> last item -> get_Result_states fa h fa.start*)
(* END MORE HELPERS --- *)

let rec accept: fa -> input -> bool =
  fun fa i ->
    let final_states = (get_final_states fa i [fa.start]) in
    let rec check_states states =
      match states with (* i is each char in the input str *)
      | [] -> false
      | h::t -> in_list h fa.final || check_states t
    in
    check_states final_states

let rec is_deterministic: fa -> bool =
  fun fa ->
    match fa.tf with
    | [] -> true
    | (sts, sym, stf)::t -> 
      if (List.length (get_final_states fa [sym] [sts]) > 1) then false 
      else is_deterministic {states = fa.states; start = fa.start; tf = t; final = fa.final}

(* if all states are reachable from the start state *)
let rec is_valid: fa -> bool =
  fun fa -> 
    not (has_duplicate fa.states) &&
    every in_list [fa.start] fa.states &&
    every in_list fa.final fa.states

let rec next: tf -> state -> state list =
  fun tf st -> List.map(fun (sts, sym, stf) -> stf) (List.filter(fun (sts, sym, stf) -> sts = st) tf) (* filter tuples of tf to the given start states, then map to return only stfs*)

(* BFS *)
let rec reachable: fa -> state list =
  fun fa ->
    let rec reachable_states states visited =
      match states with
      | [] -> visited
      | h::t -> if (in_list h visited) then reachable_states t visited
                else reachable_states (t @ (next fa.tf h)) (h::visited)
    in reachable_states [fa.start] []

let rec non_empty: fa -> bool =
  fun fa ->
    let reachable_states = reachable fa in
    let rec check_final states =
      match states with
      | [] -> false
      | h::t -> if (in_list h fa.final) then true else check_final t
    in check_final reachable_states

(* NOTE!!! as implied by the assignment's description, this function will only "work" on valid FAs. *)
let rec remove_dead_states: fa -> fa =
  fun fa -> 
    if not (is_valid fa) then fa else
    let n_states = List.filter(fun st -> in_list st (reachable fa)) fa.states in
    let n_tf = List.filter(fun (sts, sym, stf) -> in_list sts (reachable fa) && in_list stf (reachable fa)) fa.tf in
    let n_final = List.filter(fun st -> in_list st (reachable fa)) fa.final in
    { states = n_states; start = fa.start; tf = n_tf; final = n_final }

    