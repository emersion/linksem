(*Generated by Lem from missing_pervasives.lem.*)
open Lem_basic_classes
open Lem_bool
open Lem_list
open Lem_maybe
open Lem_num
open Lem_string
open Lem_assert_extra

(*type byte*)

(*val char_of_byte : byte -> char*)

(*val natural_of_bool : bool -> natural*)
let natural_of_bool b =  
((match b with
    | true  ->Big_int.big_int_of_int 1
    | false ->Big_int.big_int_of_int 0
  ))

(*val unsafe_nat_of_natural : natural -> nat*)

(*val unsafe_int_of_natural   : natural -> int*)

(*val byte_of_natural : natural -> byte*)

(*type ordering
  = Equal
  | Less
  | Greater*)

(*val natural_ordering : natural -> natural -> ordering*)
(*let natural_ordering left right =
  if (Instance_Basic_classes_Eq_Num_natural.=) left right then
    Equal
  else if (Instance_Basic_classes_Ord_Num_natural.<) left right then
    Less
  else
    Greater*)

(*val sort_by : forall 'a. ('a -> 'a -> ordering) -> list 'a -> list 'a*)

(** [intercalate sep xs] places [sep] between all elements of [xs]. *)
(*val intercalate : forall 'a. 'a -> list 'a -> list 'a*)
let rec intercalate sep xs =	
((match xs with
		| []    -> []
		| [x]   -> [x]
		| x::xs -> x::(sep::intercalate sep xs)
	))

(** [mapMaybei f xs] maps a function expecting an index (the position in the list
  * [xs] that it is currently viewing) and producing a [maybe] type across a list.
  * Elements that produce [Nothing] under [f] are discarded in the output, whilst
  * those producing [Just e] for some [e] are kept.
  *)
(*val mapMaybei' : forall 'a 'b. (natural -> 'a -> maybe 'b) -> natural -> list 'a -> list 'b*)
let rec mapMaybei' f idx xs =  
((match xs with
  | []    -> []
  | x::xs ->
      (match f idx x with
      | None -> mapMaybei' f ( Big_int.add_big_int(Big_int.big_int_of_int 1) idx) xs
      | Some e  -> e :: mapMaybei' f ( Big_int.add_big_int(Big_int.big_int_of_int 1) idx) xs
      )
  ))

(*val mapMaybei : forall 'a 'b. (natural -> 'a -> maybe 'b) -> list 'a -> list 'b*)
    
let mapMaybei f xs =  
(mapMaybei' f(Big_int.big_int_of_int 0) xs)

(** [unlines xs] concatenates a list of strings [xs], placing each entry
  * on a new line.
  *)
(*val unlines : list string -> string*)
let unlines xs =  
(List.fold_right (^) (intercalate "\n" xs) "")

(** [bracket xs] concatenates a list of strings [xs], separating each entry with a
  * space, and bracketing the resulting string.
  *)
(*val bracket : list string -> string*)
let bracket xs =  
("(" ^ (List.fold_right (^) (intercalate " " xs) "" ^ ")"))

(** [null_char] is the null character. *)
(*val null_char : byte*)

(** [split_string_on_char s c] splits a string [s] into a list of substrings
  * on character [c], otherwise returning the singleton list containing [s]
  * if [c] is not found in [s].
  *)
(*val split_string_on_char : string -> char -> list string*)

(** [println s] prints [s] to stdout, adding a trailing newline. *)
(*val println : string -> unit*)

(** [prints s] prints [s] to stdout, without adding a trailing newline. *)
(*val prints : string -> unit*)

(** [string_of_nat m] produces a string representation of natural number [m]. *)
(*val string_of_nat : nat -> string*)

(** [string_suffix i s] chops [i] characters off [s], returning a new string.
  * Fails if the index is negative, or beyond the end of the string.
  *)
(*val string_suffix : natural -> string -> maybe string*)

(*val index : forall 'a. natural -> list 'a -> maybe 'a*)

(*val find_index_helper : forall 'a. natural -> ('a -> bool) -> list 'a -> maybe natural*)
let rec find_index_helper count p xs =	
((match xs with
		| []    -> None
		| y::ys ->
			if p y then
				Some count
			else
				find_index_helper ( Big_int.add_big_int count(Big_int.big_int_of_int 1)) p ys
	))

(*val find_index : forall 'a. ('a -> bool) -> list 'a -> maybe natural*)
let find_index0 p xs = (find_index_helper(Big_int.big_int_of_int 0) p xs)

(*val length : forall 'a. list 'a -> natural*)

(*val nat_length : forall 'a. list 'a -> nat*)

let length xs = (Big_int.big_int_of_int (List.length xs))

(*val argv : list string*)

(*val replicate : forall 'a. natural -> 'a -> list 'a*)
let rec replicate0 len e = 
  (
  if(Big_int.eq_big_int len (Big_int.big_int_of_int 0)) then ([]) else
    (e ::
       replicate0 ( Nat_num.natural_monus len (Big_int.big_int_of_int 1)) e))

(*val hd : forall 'a. list 'a -> 'a*)
let hd l =     
((match l with
        | [] -> failwith "hd of empty list"
        | x :: xs -> x
    ))

(*val tl : forall 'a. list 'a -> list 'a*)
let tl l =     
((match l with
        | [] -> failwith "tl of empty list"
        | x :: xs -> xs
    ))
