chapter {* Generated by Lem from abis/amd64/abi_amd64_section_header_table.lem. *}

theory "Abi_amd64_section_header_table" 

imports 
 	 Main
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 

(** [abi_amd64_section_header_table] module contains section header table
  * specific definitions for the AMD64 ABI.
  *)

(*open import Basic_classes*)
(*open import Map*)
(*open import Num*)

(*open import Elf_section_header_table*)

(** AMD64 specific flags.  See Section 4.2.1. *)

definition shf_abi_amd64_large  :: " nat "  where 
     " shf_abi_amd64_large = (( 67108864 :: nat) *( 4 :: nat))"
 (* 0x10000000 *)

(** AMD64 specific section types.  See Section 4.2.2 *)

definition sht_abi_amd64_unwind  :: " nat "  where 
     " sht_abi_amd64_unwind = ( (( 939524096 :: nat) *( 2 :: nat)) +( 1 :: nat))"
 (* 0x70000001 *)

(** [string_of_abi_amd64_section_type m] produces a string based representation
  * of AMD64 section type [m].
  *)
(*val string_of_abi_amd64_section_type : natural -> string*)
    
(** Special sections *)

(*val abi_amd64_special_sections : Map.map string (natural * natural)*)
definition abi_amg64_special_sections  :: "((string),(nat*nat))Map.map "  where 
     " abi_amg64_special_sections = (
  Map.map_of (List.rev [
    ((''.got''), (sht_progbits, (shf_alloc + shf_write)))
  , ((''.plt''), (sht_progbits, (shf_alloc + shf_execinstr)))
  , ((''.eh_frame''), (sht_abi_amd64_unwind, shf_alloc))
  ]))"

  
(*val abi_amd64_special_sections_large_code_model : Map.map string (natural * natural)*)
definition abi_amd64_special_sections_large_code_model  :: "((string),(nat*nat))Map.map "  where 
     " abi_amd64_special_sections_large_code_model = (
  Map.map_of (List.rev [
    ((''.lbss''), (sht_nobits, ((shf_alloc + shf_write) + shf_abi_amd64_large)))
  , ((''.ldata''), (sht_progbits, ((shf_alloc + shf_write) + shf_abi_amd64_large)))
  , ((''.ldata1''), (sht_progbits, ((shf_alloc + shf_write) + shf_abi_amd64_large)))
  , ((''.lgot''), (sht_progbits, ((shf_alloc + shf_write) + shf_abi_amd64_large)))
  , ((''.lplt''), (sht_progbits, ((shf_alloc + shf_execinstr) + shf_abi_amd64_large)))
  , ((''.lrodata''), (sht_progbits, (shf_alloc + shf_abi_amd64_large)))
  , ((''.lrodata1''), (sht_progbits, (shf_alloc + shf_abi_amd64_large)))
  , ((''.ltext''), (sht_progbits, ((shf_alloc + shf_execinstr) + shf_abi_amd64_large)))
  ]))"

end