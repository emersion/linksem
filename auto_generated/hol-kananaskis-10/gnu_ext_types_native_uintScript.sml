(*Generated by Lem from gnu_extensions/gnu_ext_types_native_uint.lem.*)
open HolKernel Parse boolLib bossLib;
open missing_pervasivesTheory elf_types_native_uintTheory;

val _ = numLib.prefer_num();



val _ = new_theory "gnu_ext_types_native_uint"

(** [gnu_ext_types_native_uint] provides extended types defined by the GNU
  * extensions over and above the based ELF types.
  *)

(*open import Missing_pervasives*)
(*open import Elf_types_native_uint*)

(** LSB section 9.2.1.1: in addition to SCO ELF spec types GNU defines an
  * additional 1-byte integral type.
  *)
val _ = type_abbrev( "gnu_ext_byte" , ``: word8``);
val _ = export_theory()

