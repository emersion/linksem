(*Generated by Lem from adaptors/harness_interface.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_functionTheory lem_basic_classesTheory lem_boolTheory lem_maybeTheory lem_stringTheory showTheory missing_pervasivesTheory errorTheory byte_sequenceTheory endiannessTheory elf_types_native_uintTheory default_printingTheory elf_headerTheory string_tableTheory elf_program_header_tableTheory hex_printingTheory elf_section_header_tableTheory elf_symbol_tableTheory elf_fileTheory elf_relocationTheory elf_dynamicTheory gnu_ext_dynamicTheory gnu_ext_section_header_tableTheory gnu_ext_section_to_segment_mappingTheory gnu_ext_symbol_versioningTheory harness_interfaceTheory;

val _ = numLib.prefer_num();



open lemLib;
(* val _ = lemLib.run_interactive := true; *)
val _ = new_theory "harness_interfaceAuxiliary"


(****************************************************)
(*                                                  *)
(* Termination Proofs                               *)
(*                                                  *)
(****************************************************)

(* val gst = Defn.tgoal_no_defn (concatS'_def, concatS'_ind) *)
val (concatS'_rw, concatS'_ind_rw) =
  Defn.tprove_no_defn ((concatS'_def, concatS'_ind),
    cheat
  )
val concatS'_rw = save_thm ("concatS'_rw", concatS'_rw);
val concatS'_ind_rw = save_thm ("concatS'_ind_rw", concatS'_ind_rw);




val _ = export_theory()

