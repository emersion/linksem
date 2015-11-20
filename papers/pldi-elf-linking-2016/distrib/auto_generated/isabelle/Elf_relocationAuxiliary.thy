chapter {* Generated by Lem from elf_relocation.lem. *}

theory "Elf_relocationAuxiliary" 

imports 
 	 Main "~~/src/HOL/Library/Code_Target_Numeral"
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

termination read_elf32_relocation_section' by lexicographic_order

termination read_elf64_relocation_section' by lexicographic_order

termination read_elf32_relocation_a_section' by lexicographic_order

termination read_elf64_relocation_a_section' by lexicographic_order



end
