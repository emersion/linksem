chapter {* Generated by Lem from adaptors/harness_interface.lem. *}

theory "Harness_interface" 

imports 
 	 Main
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_function" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_bool" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_maybe" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Show" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Missing_pervasives" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Error" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Byte_sequence" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Endianness" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_types_native_uint" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Default_printing" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_header" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/String_table" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_program_header_table" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_section_header_table" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_symbol_table" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_file" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_relocation" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Hex_printing" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_dynamic" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Gnu_ext_dynamic" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Gnu_ext_section_header_table" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Gnu_ext_section_to_segment_mapping" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Gnu_ext_symbol_versioning" 

begin 

(*open import Basic_classes*)
(*open import Bool*)
(*open import Function*)
(*open import Maybe*)
(*open import Num*)
(*open import String*)

(*open import Byte_sequence*)
(*open import Error*)
(*open import Hex_printing*)
(*open import Missing_pervasives*)
(*open import Show*)

(*open import Default_printing*)

(*open import Endianness*)
(*open import String_table*)

(*open import Elf_dynamic*)
(*open import Elf_file*)
(*open import Elf_header*)
(*open import Elf_program_header_table*)
(*open import Elf_relocation*)
(*open import Elf_section_header_table*)
(*open import Elf_symbol_table*)
(*open import Elf_types_native_uint*)

(*open import Gnu_ext_dynamic*)
(*open import Gnu_ext_section_header_table*)
(*open import Gnu_ext_section_to_segment_mapping*)
(*open import Gnu_ext_symbol_versioning*)
  
(*val concatS' : list string -> string -> string*)
function (sequential,domintros)  concatS'  :: "(string)list \<Rightarrow> string \<Rightarrow> string "  where 
     " concatS' ([]) accum = ( accum )"
|" concatS' (s # ss) accum = ( concatS' ss (accum@s))" 
by pat_completeness auto


(*val concatS : list string -> string*)
definition concatS  :: "(string)list \<Rightarrow> string "  where 
     " concatS ss = ( concatS' ss (''''))"


(*val harness_string_of_elf32_file_header : elf32_header -> string*)
  
(*val harness_string_of_elf64_file_header : elf64_header -> string*)
  
(*val harness_string_of_elf32_program_header_table_entry : (natural -> string) -> (natural -> string) -> byte_sequence -> elf32_program_header_table_entry -> string*)
      
(*val harness_string_of_elf64_program_header_table_entry : (natural -> string) -> (natural -> string) -> byte_sequence -> elf64_program_header_table_entry -> string*)
  
(*val harness_string_of_efl32_pht : (natural -> string) -> (natural -> string) -> elf32_program_header_table -> byte_sequence -> string*)

(*val harness_string_of_efl64_pht : (natural -> string) -> (natural -> string) -> elf64_program_header_table -> byte_sequence -> string*)

(*val harness_string_of_elf32_segment_section_mappings : elf32_header -> elf32_program_header_table -> elf32_section_header_table -> string_table -> string*)
    
(*val harness_string_of_elf64_segment_section_mappings : elf64_header -> elf64_program_header_table -> elf64_section_header_table -> string_table -> string*)
  
(*val harness_string_of_elf32_program_headers : (natural -> string) -> (natural -> string) -> elf32_header -> elf32_program_header_table -> elf32_section_header_table -> string_table -> byte_sequence -> string*)
  
(*val harness_string_of_elf64_program_headers : (natural -> string) -> (natural -> string) -> elf64_header -> elf64_program_header_table -> elf64_section_header_table -> string_table -> byte_sequence -> string*)
  
(*val harness_sht32_flag_legend : string*)
  
(*val harness_sht64_flag_legend : natural -> string*)
  
(*val harness_string_of_elf32_sht : (natural -> string) -> (natural -> string) -> (natural -> string) -> elf32_section_header_table -> string_table -> string*)
    
(*val harness_string_of_elf64_sht : (natural -> string) -> (natural -> string) -> (natural -> string) -> elf64_section_header_table -> string_table -> string*)
    

(*val harness_string_of_elf32_section_headers : (natural -> string) -> (natural -> string) -> (natural -> string) -> elf32_header -> elf32_section_header_table -> string_table -> string*)
  
(*val harness_string_of_elf64_section_headers : (natural -> string) -> (natural -> string) -> (natural -> string) -> elf64_header -> elf64_section_header_table -> string_table -> string*)
  
(*val harness_string_of_elf32_reloc_entry : (natural -> string) -> elf32_section_header_table ->
  elf32_symbol_table -> string_table -> string_table -> elf32_relocation -> string*)
    
(*val harness_string_of_elf64_reloc_a_entry : (natural -> string) -> elf64_symbol_table ->
  elf64_section_header_table -> string_table -> string_table -> elf64_relocation_a -> string*)
    
(*val harness_string_of_elf32_relocs' : endianness -> (natural -> string) -> elf32_file -> elf32_section_header_table ->
  elf32_section_header_table -> string_table -> string_table -> byte_sequence -> string*)
    
(*val harness_string_of_elf64_relocs' : endianness -> (natural -> string) -> elf64_file ->
  elf64_section_header_table -> elf64_section_header_table ->
  string_table -> string_table -> byte_sequence -> string*)
  
(*val harness_string_of_elf32_relocs : elf32_file -> (natural -> string) -> byte_sequence -> string*)
    
(*val harness_string_of_elf64_relocs : elf64_file -> (natural -> string) -> byte_sequence -> string*)
    
(*val harness_string_of_elf32_symbol_table_entry : nat -> (natural -> string) -> (natural -> string) -> gnu_ext_elf32_symbol_version_table ->
  list (gnu_ext_elf32_verneed * list gnu_ext_elf32_vernaux) -> byte_sequence -> string_table -> elf32_symbol_table_entry -> string*)
    
(*val harness_string_of_elf32_syms' : endianness -> (natural -> string) -> (natural -> string) -> elf32_file -> elf32_section_header_table -> elf32_section_header_table -> string_table -> byte_sequence -> string*)
    
(*val harness_string_of_elf32_syms : elf32_file -> (natural -> string) -> (natural -> string) -> byte_sequence -> string*)
    
(*val harness_string_of_elf64_symbol_table_entry : nat -> (natural -> string) -> (natural -> string) -> string_table -> elf64_symbol_table_entry -> string*)
    
(*val harness_string_of_elf64_syms' : endianness -> (natural -> string) -> (natural -> string) -> elf64_file -> elf64_section_header_table -> elf64_section_header_table -> string_table -> byte_sequence -> string*)
    
(*val harness_string_of_elf64_syms : elf64_file -> (natural -> string) -> (natural -> string) -> byte_sequence -> string*)
    
(*val string_of_unix_time : natural -> string*)    
    
(*val string_of_dyn_value : forall 'addr 'size. dyn_value 'addr 'size ->
  ('addr -> string) -> ('size -> string) -> string*)

(*val string_of_elf32_dyn_value : elf32_dyn_value -> string*)
    
(*val string_of_elf64_dyn_value : elf64_dyn_value -> string*)
    
(*val harness_string_of_elf32_dyn_entry : bool -> elf32_dyn -> (natural -> bool) -> (natural -> string) ->
  (elf32_dyn -> string_table -> error elf32_dyn_value) ->
    (elf32_dyn -> string_table -> error elf32_dyn_value) -> string_table -> string*)
    
(*val harness_string_of_elf32_dynamic_section' : elf32_file -> elf32_program_header_table_entry ->
    byte_sequence -> (natural -> bool) -> (natural -> error tag_correspondence) ->
    (natural -> error tag_correspondence) -> (natural -> string) ->
      (elf32_dyn -> string_table -> error elf32_dyn_value) ->
        (elf32_dyn -> string_table -> error elf32_dyn_value) -> string*)
    
(*val harness_string_of_elf32_dynamic_section : elf32_file -> byte_sequence ->
  (natural -> bool) -> (natural -> error tag_correspondence) ->
    (natural -> error tag_correspondence) -> (natural -> string) ->
      (elf32_dyn -> string_table -> error elf32_dyn_value) ->
        (elf32_dyn -> string_table -> error elf32_dyn_value) -> string*)
    
(*val harness_string_of_elf64_dyn_entry : bool -> elf64_dyn -> (natural -> bool) -> (natural -> string) ->
  (elf64_dyn -> string_table -> error elf64_dyn_value) ->
    (elf64_dyn -> string_table -> error elf64_dyn_value) -> string_table -> string*)
    
(*val harness_string_of_elf64_dynamic_section' : elf64_file -> elf64_program_header_table_entry ->
    byte_sequence -> (natural -> bool) -> (natural -> error tag_correspondence) ->
    (natural -> error tag_correspondence) -> (natural -> string) ->
      (elf64_dyn -> string_table -> error elf64_dyn_value) ->
        (elf64_dyn -> string_table -> error elf64_dyn_value) -> string*)
    
(*val harness_string_of_elf64_dynamic_section : elf64_file -> byte_sequence ->
  (natural -> bool) -> (natural -> error tag_correspondence) ->
    (natural -> error tag_correspondence) -> (natural -> string) ->
      (elf64_dyn -> string_table -> error elf64_dyn_value) ->
        (elf64_dyn -> string_table -> error elf64_dyn_value) -> string*)
end
