(*Generated by Lem from set_extra.lem.*)
(******************************************************************************)
(* A library for sets                                                         *)
(*                                                                            *)
(* It mainly follows the Haskell Set-library                                  *)
(******************************************************************************)

(* ========================================================================== *)
(* Header                                                                     *)
(* ========================================================================== *)

open Lem_bool
open Lem_basic_classes
open Lem_maybe
open Lem_function
open Lem_num
open Lem_list
open Lem_sorting
open Lem_set


(* ----------------------------*)
(* set choose (be careful !)   *)
(* --------------------------- *)

(*val choose : forall 'a. SetType 'a => set 'a -> 'a*)


(* ----------------------------*)
(* universal set               *)
(* --------------------------- *)

(*val universal : forall 'a. SetType 'a => set 'a*)


(* ----------------------------*)
(* toList                      *)
(* --------------------------- *)

(*val toList        : forall 'a. SetType 'a => set 'a -> list 'a*)


(* ----------------------------*)
(* toOrderedList               *)
(* --------------------------- *)

(* "toOrderedList" returns a sorted list. Therefore the result is (given a suitable order) deterministic.
   Therefore, it is much preferred to "toList". However, it still is only defined for finite sets. So, please
   use carefully and consider using set-operations instead of translating sets to lists, performing list manipulations
   and then transforming back to sets. *) 

(*val toOrderedListBy : forall 'a. ('a -> 'a -> bool) -> set 'a -> list 'a*)

(*val toOrderedList : forall 'a. SetType 'a, Ord 'a => set 'a -> list 'a*)

(* ----------------------------*)
(* unbounded fixed point       *)
(* --------------------------- *)

(* Is NOT supported by the coq backend! *)
(*val leastFixedPointUnbounded : forall 'a. SetType 'a => (set 'a -> set 'a) -> set 'a -> set 'a*)
let rec leastFixedPointUnbounded dict_Basic_classes_SetType_a f x =   
(let fx = (f x) in
   if Pset.subset fx x then x
   else leastFixedPointUnbounded 
  dict_Basic_classes_SetType_a f ( Pset.(union) fx x))
