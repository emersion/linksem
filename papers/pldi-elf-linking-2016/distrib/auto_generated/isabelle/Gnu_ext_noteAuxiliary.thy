chapter {* Generated by Lem from gnu_extensions/gnu_ext_note.lem. *}

theory "Gnu_ext_noteAuxiliary" 

imports 
 	 Main "~~/src/HOL/Library/Code_Target_Numeral"
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

termination group_elf32_words by lexicographic_order

termination group_elf64_words by lexicographic_order



end
