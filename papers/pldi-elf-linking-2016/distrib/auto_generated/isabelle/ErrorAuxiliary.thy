chapter {* Generated by Lem from error.lem. *}

theory "ErrorAuxiliary" 

imports 
 	 Main "~~/src/HOL/Library/Code_Target_Numeral"
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

termination repeatM by lexicographic_order

termination repeatM' by lexicographic_order

termination mapM by lexicographic_order

termination foldM by lexicographic_order



end
