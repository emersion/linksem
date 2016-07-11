chapter {* Generated by Lem from memory_image.lem. *}

theory "Memory_imageAuxiliary" 

imports 
 	 Main "~~/src/HOL/Library/Code_Target_Numeral"
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_list" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_set" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_function" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_bool" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_maybe" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_assert_extra" 
	 "Show" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_sorting" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_set_extra" 
	 "Missing_pervasives" 
	 "Byte_sequence" 
	 "Elf_types_native_uint" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_tuple" 
	 "Elf_header" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_map" 
	 "Elf_program_header_table" 
	 "Elf_section_header_table" 
	 "Elf_interpreted_section" 
	 "Elf_interpreted_segment" 
	 "Elf_symbol_table" 
	 "Elf_file" 
	 "Elf_relocation" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_map_extra" 
	 "Multimap" 
	 "GCD" 
	 "Memory_image" 

begin 


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

termination nat_range by lexicographic_order

termination expand_sorted_ranges by lexicographic_order

termination make_byte_pattern_revacc by lexicographic_order

termination relax_byte_pattern_revacc by lexicographic_order

termination concretise_byte_pattern by lexicographic_order

termination byte_list_matches_pattern by lexicographic_order

termination accum_pattern_possible_starts_in_one_byte_sequence by lexicographic_order

termination natural_to_le_byte_list by lexicographic_order


(****************************************************)
(*                                                  *)
(* Lemmata                                          *)
(*                                                  *)
(****************************************************)

lemma gcd_def_lemma:
" ((\<forall> a. \<forall> b.
   (if b = ( 0 :: nat) then a else GCD.gcd b (a mod b)) = GCD.gcd a b)) "
(* Theorem: gcd_def_lemma*)(* try *) by auto

lemma lcm_def_lemma:
" ((\<forall> a. \<forall> b.
   (
   (* let _ = errln (lcm of  ^ (show a) ^  and  ^ (show b) ^ ?)
    in *) (
   a * b) div (GCD.gcd a b)) = GCD.lcm a b)) "
(* Theorem: lcm_def_lemma*)(* try *) by auto



end
