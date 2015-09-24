chapter {* Generated by Lem from abis/amd64/abi_amd64.lem. *}

theory "Abi_amd64" 

imports 
 	 Main
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_list" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_bool" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_maybe" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_assert_extra" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Missing_pervasives" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Error" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Endianness" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_types_native_uint" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_header" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_map" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_interpreted_section" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_interpreted_segment" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Elf_file" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/linksem/auto_generated/isabelle/Memory_image" 
	 "Abi_amd64_elf_header" 
	 "Abi_amd64_relocation" 

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
    GOT0 
    | PLT0 (* placeholder / FIXME *)
    
(*val amd64AbiFeatureConstructorToNaturalList : amd64_abi_feature -> list natural*)
fun amd64AbiFeatureConstructorToNaturalList  :: " amd64_abi_feature \<Rightarrow>(nat)list "  where 
     " amd64AbiFeatureConstructorToNaturalList GOT0 = ( [( 0 :: nat)])"
|" amd64AbiFeatureConstructorToNaturalList PLT0 = ( [( 1 :: nat)])" 
declare amd64AbiFeatureConstructorToNaturalList.simps [simp del]


(*val abiFeatureCompare : amd64_abi_feature -> amd64_abi_feature -> Basic_classes.ordering*)
definition abiFeatureCompare0  :: " amd64_abi_feature \<Rightarrow> amd64_abi_feature \<Rightarrow> ordering "  where 
     " abiFeatureCompare0 f1 f2 = ( 
    (case  (amd64AbiFeatureConstructorToNaturalList f1, amd64AbiFeatureConstructorToNaturalList f2) of
        ([], []) => failwith (''impossible: ABI feature has empty natural list (case 0)'')
    |   (_, [])  => failwith (''impossible: ABI feature has empty natural list (case 1)'')
    |   ([], _)  => failwith (''impossible: ABI feature has empty natural list (case 2)'')
    |   ((hd1 # tl1), (hd2 # tl2)) => 
            if hd1 < hd2 then LT else if hd1 > hd2 then GT else
                (case  (f1, f2) of
                    (GOT0, GOT0) => EQ
                    | (PLT0, PLT0) => EQ
                    | _ => failwith (''impossible: tag constructors not equal but natural list heads were equal'')
                )
    ))"


definition instance_Basic_classes_Ord_Abi_amd64_amd64_abi_feature_dict  :: "(amd64_abi_feature)Ord_class "  where 
     " instance_Basic_classes_Ord_Abi_amd64_amd64_abi_feature_dict = ((|

  compare_method = abiFeatureCompare0,

  isLess_method = (\<lambda> f1 .  (\<lambda> f2 .  (abiFeatureCompare0 f1 f2 = LT))),

  isLessEqual_method = (\<lambda> f1 .  (\<lambda> f2 .  (op \<in>) (abiFeatureCompare0 f1 f2) ({LT, EQ}))),

  isGreater_method = (\<lambda> f1 .  (\<lambda> f2 .  (abiFeatureCompare0 f1 f2 = GT))),

  isGreaterEqual_method = (\<lambda> f1 .  (\<lambda> f2 .  (op \<in>) (abiFeatureCompare0 f1 f2) ({GT, EQ})))|) )"


definition instance_Memory_image_ToNaturalList_Abi_amd64_amd64_abi_feature_dict  :: "(amd64_abi_feature)ToNaturalList_class "  where 
     " instance_Memory_image_ToNaturalList_Abi_amd64_amd64_abi_feature_dict = ((|

  toNaturalList_method = amd64AbiFeatureConstructorToNaturalList |) )"


(*val section_is_special : forall 'abifeature. elf64_interpreted_section -> annotated_memory_image 'abifeature -> bool*)
definition section_is_special1  :: " elf64_interpreted_section \<Rightarrow> 'abifeature annotated_memory_image \<Rightarrow> bool "  where 
     " section_is_special1 s img = ( 
    elf_section_is_special s img \<or>  
  ( (* HACK needed because SHT_X86_64_UNWIND is often not used *)
    if((elf64_section_name_as_string   s) = (''.eh_frame'')) then True else
      False) )"

end
