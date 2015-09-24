chapter {* Generated by Lem from elf_interpreted_segment.lem. *}

theory "Elf_interpreted_segment" 

imports 
 	 Main
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_bool" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "Show" 
	 "Missing_pervasives" 
	 "Byte_sequence" 
	 "Elf_types_native_uint" 

begin 

(** [elf_interpreted_segment] defines interpreted segments, i.e. the contents of
  * a program header table entry converted to more amenable types, and operations
  * built on top of them.
  *)

(*open import Basic_classes*)
(*open import Bool*)
(*open import Num*)
(*open import String*)

(*open import Elf_types_native_uint*)

(*open import Byte_sequence*)
(*open import Missing_pervasives*)
(*open import Show*)

(** [elf32_interpreted_segment] represents an ELF32 interpreted segment, i.e. the
  * contents of an ELF program header table entry converted into more amenable
  * (infinite precision) types, for manipulation.
  * Invariant: the nth entry of the program header table corresponds to the nth
  * entry of the list of interpreted segments in an [elf32_file] record.  The
  * lengths of the two lists are exactly the same.
  *)
record elf32_interpreted_segment =
  
 elf32_segment_body  ::" byte_sequence "        (** Body of the segment *)
   
 elf32_segment_type  ::" nat "              (** Type of the segment *)
   
 elf32_segment_size  ::" nat "              (** Size of the segment in bytes *)
   
 elf32_segment_memsz ::" nat "              (** Size of the segment in memory in bytes *)
   
 elf32_segment_base  ::" nat "              (** Base address of the segment *)
   
 elf32_segment_paddr ::" nat "              (** Physical address of segment *)
   
 elf32_segment_align ::" nat "              (** Alignment of the segment *)
   
 elf32_segment_offset ::" nat "             (** Offset of the segment *)
   
 elf32_segment_flags ::" (bool * bool * bool)" (** READ, WRITE, EXECUTE flags. *)
   


(** [elf64_interpreted_segment] represents an ELF64 interpreted segment, i.e. the
  * contents of an ELF program header table entry converted into more amenable
  * (infinite precision) types, for manipulation.
  * Invariant: the nth entry of the program header table corresponds to the nth
  * entry of the list of interpreted segments in an [elf64_file] record.  The
  * lengths of the two lists are exactly the same.
  *)
record elf64_interpreted_segment =
  
 elf64_segment_body  ::" byte_sequence "        (** Body of the segment *)
   
 elf64_segment_type  ::" nat "              (** Type of the segment *)
   
 elf64_segment_size  ::" nat "              (** Size of the segment in bytes *)
   
 elf64_segment_memsz ::" nat "              (** Size of the segment in memory in bytes *)
   
 elf64_segment_base  ::" nat "              (** Base address of the segment *)
   
 elf64_segment_paddr ::" nat "              (** Physical address of segment *)
   
 elf64_segment_align ::" nat "              (** Alignment of the segment *)
   
 elf64_segment_offset ::" nat "             (** Offset of the segment *)
   
 elf64_segment_flags ::" (bool * bool * bool)" (** READ, WRITE, EXECUTE flags. *)
   

   
(** [compare_elf64_interpreted_segment seg1 seg2] is an ordering comparison function
  * on interpreted segments suitable for constructing sets, finite maps and other
  * ordered data types out of.
  *)
(*val compare_elf64_interpreted_segment : elf64_interpreted_segment ->
  elf64_interpreted_segment -> ordering*)
definition compare_elf64_interpreted_segment  :: " elf64_interpreted_segment \<Rightarrow> elf64_interpreted_segment \<Rightarrow> ordering "  where 
     " compare_elf64_interpreted_segment s1 s2 = (  
 (tripleCompare compare_byte_sequence (Lem_list.lexicographicCompareBy (genericCompare (op<) (op=))) (Lem_list.lexicographicCompareBy (genericCompare (op<) (op=))) 
    ((elf64_segment_body   s1),
    [(elf64_segment_type   s1)  ,(elf64_segment_size  
     s1)  ,(elf64_segment_memsz  
     s1) ,(elf64_segment_base  
     s1)  ,(elf64_segment_paddr  
     s1) ,(elf64_segment_align  
     s1) ,(elf64_segment_offset  
     s1)],     
 ((let (f1, f2, f3) = ((elf64_segment_flags   s1)) in
       List.map natural_of_bool [f1, f2, f3])))
    ((elf64_segment_body   s2),
    [(elf64_segment_type   s2)  ,(elf64_segment_size  
     s2)  ,(elf64_segment_memsz  
     s2) ,(elf64_segment_base  
     s2)  ,(elf64_segment_paddr  
     s2) ,(elf64_segment_align  
     s2) ,(elf64_segment_offset  
     s2)],     
((let (f1, f2, f3) = ((elf64_segment_flags   s2)) in
       List.map natural_of_bool [f1, f2, f3])))))"


definition instance_Basic_classes_Ord_Elf_interpreted_segment_elf64_interpreted_segment_dict  :: "(elf64_interpreted_segment)Ord_class "  where 
     " instance_Basic_classes_Ord_Elf_interpreted_segment_elf64_interpreted_segment_dict = ((|

  compare_method = compare_elf64_interpreted_segment,

  isLess_method = (\<lambda> f1 .  (\<lambda> f2 .  (compare_elf64_interpreted_segment f1 f2 = LT))),

  isLessEqual_method = (\<lambda> f1 .  (\<lambda> f2 .  (let result = (compare_elf64_interpreted_segment f1 f2) in (result = LT) \<or> (result = EQ)))),

  isGreater_method = (\<lambda> f1 .  (\<lambda> f2 .  (compare_elf64_interpreted_segment f1 f2 = GT))),

  isGreaterEqual_method = (\<lambda> f1 .  (\<lambda> f2 .  (let result = (compare_elf64_interpreted_segment f1 f2) in (result = GT) \<or> (result = EQ))))|) )"


type_synonym elf32_interpreted_segments =" elf32_interpreted_segment list "
type_synonym elf64_interpreted_segments =" elf64_interpreted_segment list "

(** [elf32_interpreted_program_header_flags w] extracts a boolean triple of flags
  * from the flags field of an interpreted segment.
  *)
(*val elf32_interpret_program_header_flags : elf32_word -> (bool * bool * bool)*)
definition elf32_interpret_program_header_flags  :: " uint32 \<Rightarrow> bool*bool*bool "  where 
     " elf32_interpret_program_header_flags flags = (
  (let zero = (Elf_Types_Local.uint32_of_nat(( 0 :: nat))) in
  (let one  = (Elf_Types_Local.uint32_of_nat(( 1 :: nat))) in
  (let two  = (Elf_Types_Local.uint32_of_nat(( 2 :: nat))) in
  (let four = (Elf_Types_Local.uint32_of_nat(( 4 :: nat))) in
    (\<not> (Elf_Types_Local.uint32_land flags one = zero),
      \<not> (Elf_Types_Local.uint32_land flags two = zero),
      \<not> (Elf_Types_Local.uint32_land flags four = zero)))))))"


(** [elf64_interpreted_program_header_flags w] extracts a boolean triple of flags
  * from the flags field of an interpreted segment.
  *)
(*val elf64_interpret_program_header_flags : elf64_word -> (bool * bool * bool)*)
definition elf64_interpret_program_header_flags  :: " uint32 \<Rightarrow> bool*bool*bool "  where 
     " elf64_interpret_program_header_flags flags = (
  (let zero = (Elf_Types_Local.uint32_of_nat(( 0 :: nat))) in
  (let one  = (Elf_Types_Local.uint32_of_nat(( 1 :: nat))) in
  (let two  = (Elf_Types_Local.uint32_of_nat(( 2 :: nat))) in
  (let four = (Elf_Types_Local.uint32_of_nat(( 4 :: nat))) in
    (\<not> (Elf_Types_Local.uint32_land flags one = zero),
      \<not> (Elf_Types_Local.uint32_land flags two = zero),
      \<not> (Elf_Types_Local.uint32_land flags four = zero)))))))"


(** [string_of_flags bs] produces a string-based representation of an interpreted
  * segments flags (represented as a boolean triple).
  *)
(*val string_of_flags : (bool * bool * bool) -> string*)

(** [string_of_elf32_interpreted_segment seg] produces a string-based representation
  * of interpreted segment [seg].
  *)
(*val string_of_elf32_interpreted_segment : elf32_interpreted_segment -> string*)

(** [string_of_elf64_interpreted_segment seg] produces a string-based representation
  * of interpreted segment [seg].
  *)
(*val string_of_elf64_interpreted_segment : elf64_interpreted_segment -> string*)
end
