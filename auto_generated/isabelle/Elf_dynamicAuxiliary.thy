chapter {* Generated by Lem from elf_dynamic.lem. *}

theory "Elf_dynamicAuxiliary" 

imports 
 	 Main "~~/src/HOL/Library/Code_Target_Numeral"
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_list" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_bool" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "Show" 
	 "Error" 
	 "Byte_sequence" 
	 "Endianness" 
	 "Elf_types_native_uint" 
	 "Elf_header" 
	 "String_table" 
	 "Elf_program_header_table" 
	 "Elf_section_header_table" 
	 "Elf_file" 
	 "Elf_relocation" 
	 "Elf_dynamic" 

begin 


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

termination obtain_elf32_dynamic_section_contents' by lexicographic_order

termination obtain_elf64_dynamic_section_contents' by lexicographic_order



end
