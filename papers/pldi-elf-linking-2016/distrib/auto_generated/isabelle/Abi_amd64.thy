chapter {* Generated by Lem from abis/amd64/abi_amd64.lem. *}

theory "Abi_amd64" 

imports 
 	 Main
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 

(** [abi_amd64] contains top-level definition for the AMD64 ABI.
  *)

(*open import Basic_classes*)
(*open import Bool*)
(*open import List*)
(*open import Num*)
(*open import Maybe*)
(*open import Error*)
(*open import Map*)
(*open import Assert_extra*)

(*open import Missing_pervasives*)
(*open import Elf_header*)
(*open import Elf_types_native_uint*)
(*open import Elf_file*)
(*open import Elf_interpreted_segment*)
(*open import Elf_interpreted_section*)

(*open import Endianness*)
(*open import Memory_image*)
(* open import Elf_memory_image *)

(*open import Abi_classes*)
(*open import Abi_amd64_relocation*)
(*open import Abi_amd64_elf_header*)

(** [abi_amd64_compute_program_entry_point segs entry] computes the program
  * entry point using ABI-specific conventions.  On AMD64 the entry point in
  * the ELF header ([entry] here) is the real entry point.  On other ABIs, e.g.
  * PowerPC64, the entry point [entry] is a pointer into one of the segments
  * constituting the process image (passed in as [segs] here for a uniform
  * interface).
  *)
(*val abi_amd64_compute_program_entry_point : list elf64_interpreted_segments -> elf64_addr -> error elf64_addr*)
definition abi_amd64_compute_program_entry_point  :: "(elf64_interpreted_segments)list \<Rightarrow> Elf_Types_Local.uint64 \<Rightarrow>(Elf_Types_Local.uint64)error "  where 
     " abi_amd64_compute_program_entry_point segs entry = (
	error_return entry )"


(*val header_is_amd64 : elf64_header -> bool*)
definition header_is_amd64  :: " elf64_header \<Rightarrow> bool "  where 
     " header_is_amd64 h = (  
    is_valid_elf64_header h
    \<and> ((index(elf64_ident   h) (id elf_ii_data) = Some (Elf_Types_Local.unsigned_char_of_nat elf_data_2lsb))
    \<and> (is_valid_abi_amd64_machine_architecture (unat(elf64_machine   h))
    \<and> is_valid_abi_amd64_magic_number(elf64_ident   h))))"


definition shf_x86_64_large  :: " nat "  where 
     " shf_x86_64_large = ( (( 256 :: nat) *( 1048576 :: nat)))"
 (* 0x10000000 a.k.a. 2^28 *)

datatype amd64_abi_feature = 
    GOT0 "  ( (string * (( element_range option) * symbol_reference_and_reloc_site))list)"
    | PLT0 (* placeholder / FIXME *)
    
(*val abiFeatureCompare : amd64_abi_feature -> amd64_abi_feature -> Basic_classes.ordering*)
fun abiFeatureCompare0  :: " amd64_abi_feature \<Rightarrow> amd64_abi_feature \<Rightarrow> ordering "  where 
     " abiFeatureCompare0 (GOT0(_)) (GOT0(_)) = ( EQ )"
|" abiFeatureCompare0 (GOT0(_)) PLT0 = ( LT )"
|" abiFeatureCompare0 PLT0 PLT0 = ( EQ )"
|" abiFeatureCompare0 PLT0 (GOT0(_)) = ( GT )" 
declare abiFeatureCompare0.simps [simp del]


(*val abiFeatureTagEq : amd64_abi_feature -> amd64_abi_feature -> bool*)
fun abiFeatureTagEq0  :: " amd64_abi_feature \<Rightarrow> amd64_abi_feature \<Rightarrow> bool "  where 
     " abiFeatureTagEq0 (GOT0(_)) (GOT0(_)) = ( True )"
|" abiFeatureTagEq0 PLT0 PLT0 = ( True )"
|" abiFeatureTagEq0 _ _ = ( False )" 
declare abiFeatureTagEq0.simps [simp del]


definition instance_Abi_classes_AbiFeatureTagEquiv_Abi_amd64_amd64_abi_feature_dict  :: "(amd64_abi_feature)AbiFeatureTagEquiv_class "  where 
     " instance_Abi_classes_AbiFeatureTagEquiv_Abi_amd64_amd64_abi_feature_dict = ((|

  abiFeatureTagEquiv_method = abiFeatureTagEq0 |) )"


definition instance_Basic_classes_Ord_Abi_amd64_amd64_abi_feature_dict  :: "(amd64_abi_feature)Ord_class "  where 
     " instance_Basic_classes_Ord_Abi_amd64_amd64_abi_feature_dict = ((|

  compare_method = abiFeatureCompare0,

  isLess_method = (\<lambda> f1 .  (\<lambda> f2 .  (abiFeatureCompare0 f1 f2 = LT))),

  isLessEqual_method = (\<lambda> f1 .  (\<lambda> f2 .  (op \<in>) (abiFeatureCompare0 f1 f2) ({LT, EQ}))),

  isGreater_method = (\<lambda> f1 .  (\<lambda> f2 .  (abiFeatureCompare0 f1 f2 = GT))),

  isGreaterEqual_method = (\<lambda> f1 .  (\<lambda> f2 .  (op \<in>) (abiFeatureCompare0 f1 f2) ({GT, EQ})))|) )"


(*val section_is_special : forall 'abifeature. elf64_interpreted_section -> annotated_memory_image 'abifeature -> bool*)
definition section_is_special1  :: " elf64_interpreted_section \<Rightarrow> 'abifeature annotated_memory_image \<Rightarrow> bool "  where 
     " section_is_special1 s img3 = ( 
    elf_section_is_special s img3 \<or>  
  ( (* HACK needed because SHT_X86_64_UNWIND is often not used *)
    if((elf64_section_name_as_string   s) = (''.eh_frame'')) then True else
      False) )"

end
