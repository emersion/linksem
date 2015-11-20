chapter {* Generated by Lem from test_image.lem. *}

theory "Test_image" 

imports 
 	 Main
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 

(*open import List*)
(*open import Map*)
(*open import Maybe*)
(*open import Set*)
(*open import Missing_pervasives*)

(*open import Elf_relocation*)
(*open import Elf_header*)
(*open import Elf_symbol_table*)
(*open import Elf_types_native_uint*)

(*open import Abi_amd64_relocation*)

(*open import Elf_memory_image*)
(*open import Memory_image*)

(*open import Command_line*)
(*open import Input_list*)
(*open import Linkable_list*)
(*open import Byte_sequence*)
(*open import Link*)

definition ref_rec0  :: " symbol_reference "  where 
     " ref_rec0 = ( (| ref_symname = (''test'')                  (* symbol name *)
               , ref_syment =
                  (| elf64_st_name  = (Elf_Types_Local.uint32_of_nat(( 0 :: nat)))
                   , elf64_st_info  = (Elf_Types_Local.unsigned_char_of_nat(( 0 :: nat)))
                   , elf64_st_other = (Elf_Types_Local.unsigned_char_of_nat(( 0 :: nat)))
                   , elf64_st_shndx = (Elf_Types_Local.uint16_of_nat shn_undef)
                   , elf64_st_value = (Elf_Types_Local.uint64_of_nat(( 0 :: nat)))
                   , elf64_st_size  = (of_int (int (( 0 :: nat))))
                   |)
               , ref_sym_scn =(( 0 :: nat))
               , ref_sym_idx =(( 0 :: nat))
               |) )"


(* the record representing the symbol reference and relocation site *)
definition ref_and_reloc_rec0  :: " symbol_reference_and_reloc_site "  where 
     " ref_and_reloc_rec0 = (
 (|
    ref = ref_rec0
    , maybe_reloc = (Some(
      (|
            ref_relent  = 
                (| elf64_ra_offset = (Elf_Types_Local.uint64_of_nat(( 0 :: nat)))
                 , elf64_ra_info   = (of_int (int r_x86_64_pc32))
                 , elf64_ra_addend = (of_int(( 0 :: int)))
                 |)
          , ref_rel_scn =(( 0 :: nat))
          , ref_rel_idx =(( 0 :: nat))
          , ref_src_scn =(( 0 :: nat))
       |)
    )), maybe_def_bound_to = None
     
  |) )"


definition def_rec0  :: " symbol_definition "  where 
     " def_rec0 = ( 
   (| def_symname = (''test'')
    , def_syment =    (| elf64_st_name  = (Elf_Types_Local.uint32_of_nat(( 0 :: nat)))
                       , elf64_st_info  = (Elf_Types_Local.unsigned_char_of_nat(( 0 :: nat)))
                       , elf64_st_other = (Elf_Types_Local.unsigned_char_of_nat(( 0 :: nat)))
                       , elf64_st_shndx = (Elf_Types_Local.uint16_of_nat shn_undef)
                       , elf64_st_value = (Elf_Types_Local.uint64_of_nat(( 0 :: nat)))
                       , elf64_st_size  = (of_int (int (( 0 :: nat))))
                       |)
    , def_sym_scn =(( 0 :: nat))
    , def_sym_idx =(( 1 :: nat))
    , def_linkable_idx =(( 0 :: nat))
    |) )"


(*val meta : list ((maybe element_range) * elf_range_tag)*)
definition meta0  :: "((string*(nat*nat))option*(Abis.any_abi_feature)range_tag)list "  where 
     " meta0 = ( [
        (Some ((''.text''), (( 1 :: nat),( 4 :: nat))), SymbolRef(ref_and_reloc_rec0))
    ,   (Some ((''.data''), (( 0 :: nat),( 8 :: nat))), SymbolDef(def_rec0))
])"



definition img1  :: "(Elf_Types_Local.byte)list \<Rightarrow>(Abis.any_abi_feature)annotated_memory_image "  where 
     " img1 instr_bytes = ( 
    (let initial_img =     
 ((|
        elements = (Map.map_of (List.rev [((''.text''), (|
             startpos = (Some(( 4194304 :: nat)))
           , length1 = (Some(( 16 :: nat)))
           , contents = (List.map (\<lambda> x .  Some x) instr_bytes)
          |)),
          ((''.data''), (|
             startpos = (Some(( 4194320 :: nat)))
           , length1 = (Some(( 8 :: nat)))
           , contents = (List.map (\<lambda> x .  Some x) (List.replicate(( 8 :: nat)) ((of_nat (( 42 :: nat)) :: byte))))
          |))
          ]))
        , by_range = (List.set meta0)
        , by_tag = (by_tag_from_by_range (List.set meta0))
     |)) 
    in 
    (let ref_input_item
     = ((''test.o''), Reloc(Sequence([])), ((File(Filename((''blah'')), Command_line.null_input_file_options)), [InCommandLine(( 0 :: nat))]))
    in 
    (let ref_linkable_item = (RelocELF(initial_img), ref_input_item, Input_list.null_input_options)
    in
    (let bindings_by_name = (Map.map_of (List.rev [
        ((''test''), [(( 0 :: nat), ((( 0 :: nat), ref_rec0, ref_linkable_item), Some(( 0 :: nat), def_rec0, ref_linkable_item)))])
    ]))
    in
    relocate_output_image Abis.sysv_amd64_std_abi bindings_by_name initial_img)))))"

end
