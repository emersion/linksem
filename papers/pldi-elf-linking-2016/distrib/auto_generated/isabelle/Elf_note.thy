chapter {* Generated by Lem from elf_note.lem. *}

theory "Elf_note" 

imports 
 	 Main
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 

(** [elf_note] contains data types and functions for interpreting the .note
  * section/segment of an ELF file, and extracting information from that
  * section/segment.
  *)

(*open import Basic_classes*)
(*open import List*)
(*open import Num*)
(*open import String*)

(*open import Byte_sequence*)
(*open import Endianness*)
(*open import Error*)
(*open import Missing_pervasives*)
(*open import Show*)

(*open import Elf_program_header_table*)
(*open import Elf_section_header_table*)
(*open import Elf_types_native_uint*)

(** [elf32_note] represents the contents of a .note section or segment.
  *)
record elf32_note =
  
 elf32_note_namesz ::" uint32 " (** The size of the name field. *)
   
 elf32_note_descsz ::" uint32 " (** The size of the description field. *)
   
 elf32_note_type   ::" uint32 " (** The type of the note. *)
   
 elf32_note_name   ::" Elf_Types_Local.byte list "  (** The list of bytes (of length indicated above) corresponding to the name string. *)
   
 elf32_note_desc   ::" Elf_Types_Local.byte list "  (** The list of bytes (of length indicated above) corresponding to the desc string. *)
   

   
(** [elf64_note] represents the contents of a .note section or segment.
  *)
record elf64_note =
  
 elf64_note_namesz ::" uint64 " (** The size of the name field. *)
   
 elf64_note_descsz ::" uint64 " (** The size of the description field. *)
   
 elf64_note_type   ::" uint64 " (** The type of the note. *)
   
 elf64_note_name   ::" Elf_Types_Local.byte list "   (** The list of bytes (of length indicated above) corresponding to the name string. *)
   
 elf64_note_desc   ::" Elf_Types_Local.byte list "   (** The list of bytes (of length indicated above) corresponding to the desc string. *)
   

   
(** [read_elf32_note endian bs0] transcribes an ELF note section from byte
  * sequence [bs0] assuming endianness [endian].  May fail if transcription fails
  * (i.e. if the byte sequence is not sufficiently long).
  *)
(*val read_elf32_note : endianness -> byte_sequence -> error (elf32_note * byte_sequence)*)
definition read_elf32_note  :: " endianness \<Rightarrow> byte_sequence \<Rightarrow>(elf32_note*byte_sequence)error "  where 
     " read_elf32_note endian bs0 = (
  read_elf32_word endian bs0 >>= (\<lambda> (namesz, bs0) . 
  read_elf32_word endian bs0 >>= (\<lambda> (descsz, bs0) . 
  read_elf32_word endian bs0 >>= (\<lambda> (typ1, bs0) . 
  repeatM' (unat namesz) bs0 read_char >>= (\<lambda> (name1, bs0) . 
  repeatM' (unat descsz) bs0 read_char >>= (\<lambda> (desc, bs0) . 
  error_return ((| elf32_note_namesz = namesz, elf32_note_descsz = descsz,
    elf32_note_type = typ1, elf32_note_name = name1, elf32_note_desc = desc |),
      bs0)))))))"

      
(** [read_elf64_note endian bs0] transcribes an ELF note section from byte
  * sequence [bs0] assuming endianness [endian].  May fail if transcription fails
  * (i.e. if the byte sequence is not sufficiently long).
  *)
(*val read_elf64_note : endianness -> byte_sequence -> error (elf64_note * byte_sequence)*)
definition read_elf64_note  :: " endianness \<Rightarrow> byte_sequence \<Rightarrow>(elf64_note*byte_sequence)error "  where 
     " read_elf64_note endian bs0 = (
  read_elf64_xword endian bs0 >>= (\<lambda> (namesz, bs0) . 
  read_elf64_xword endian bs0 >>= (\<lambda> (descsz, bs0) . 
  read_elf64_xword endian bs0 >>= (\<lambda> (typ1, bs0) . 
  repeatM' (unat namesz) bs0 read_char >>= (\<lambda> (name1, bs0) . 
  repeatM' (unat descsz) bs0 read_char >>= (\<lambda> (desc, bs0) . 
  error_return ((| elf64_note_namesz = namesz, elf64_note_descsz = descsz,
    elf64_note_type = typ1, elf64_note_name = name1, elf64_note_desc = desc |),
      bs0)))))))"

      
(** [obtain_elf32_note_sections endian sht bs0] returns all note sections present
  * in an ELF file, as indicated by the file's section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf32_note_sections : endianness -> elf32_section_header_table ->
  byte_sequence -> error (list elf32_note)*)
definition obtain_elf32_note_sections  :: " endianness \<Rightarrow>(elf32_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf32_note)list)error "  where 
     " obtain_elf32_note_sections endian sht bs0 = (
  (let note_sects =    
(List.filter (\<lambda> x . (elf32_sh_type  
      x) = Elf_Types_Local.uint32_of_nat sht_note
    ) sht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf32_sh_offset   x)) in
      (let size3   = (unat(elf32_sh_size   x)) in
      Byte_sequence.offset_and_cut offset size3 bs0 >>= (\<lambda> rel . 
      read_elf32_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_sects))"

    
(** [obtain_elf64_note_sections endian sht bs0] returns all note sections present
  * in an ELF file, as indicated by the file's section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf64_note_sections : endianness -> elf64_section_header_table ->
  byte_sequence -> error (list elf64_note)*)
definition obtain_elf64_note_sections  :: " endianness \<Rightarrow>(elf64_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf64_note)list)error "  where 
     " obtain_elf64_note_sections endian sht bs0 = (
  (let note_sects =    
(List.filter (\<lambda> x . (elf64_sh_type  
      x) = Elf_Types_Local.uint32_of_nat sht_note
    ) sht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf64_sh_offset   x)) in
      (let size3   = (unat(elf64_sh_size   x)) in
      Byte_sequence.offset_and_cut offset size3 bs0 >>= (\<lambda> rel . 
      read_elf64_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_sects))"

    
(** [obtain_elf32_note_segments endian pht bs0] returns all note segments present
  * in an ELF file, as indicated by the file's program header table [pht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf32_note_segments : endianness -> elf32_program_header_table ->
  byte_sequence -> error (list elf32_note)*)
definition obtain_elf32_note_segments  :: " endianness \<Rightarrow>(elf32_program_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf32_note)list)error "  where 
     " obtain_elf32_note_segments endian pht bs0 = (
  (let note_segs =    
(List.filter (\<lambda> x . (elf32_p_type  
      x) = Elf_Types_Local.uint32_of_nat elf_pt_note
    ) pht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf32_p_offset   x)) in
      (let size3   = (unat(elf32_p_filesz   x)) in
      Byte_sequence.offset_and_cut offset size3 bs0 >>= (\<lambda> rel . 
      read_elf32_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_segs))"

    
(** [obtain_elf64_note_segments endian pht bs0] returns all note segments present
  * in an ELF file, as indicated by the file's program header table [pht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section fails.
  *)
(*val obtain_elf64_note_segments : endianness -> elf64_program_header_table ->
  byte_sequence -> error (list elf64_note)*)
definition obtain_elf64_note_segments  :: " endianness \<Rightarrow>(elf64_program_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf64_note)list)error "  where 
     " obtain_elf64_note_segments endian pht bs0 = (
  (let note_segs =    
(List.filter (\<lambda> x . (elf64_p_type  
      x) = Elf_Types_Local.uint32_of_nat elf_pt_note
    ) pht)
  in
    mapM (\<lambda> x . 
      (let offset = (unat(elf64_p_offset   x)) in
      (let size3   = (unat(elf64_p_filesz   x)) in
      Byte_sequence.offset_and_cut offset size3 bs0 >>= (\<lambda> rel . 
      read_elf64_note endian rel >>= (\<lambda> (note1, _) . 
      error_return note1))))
    ) note_segs))"

    
(** [obtain_elf32_note_section_and_segments endian pht sht bs0] returns all note
  * sections and segments present in an ELF file, as indicated by the file's
  * program header table [pht] and section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section or segment fails.
  *)
(*val obtain_elf32_note_section_and_segments : endianness -> elf32_program_header_table ->
  elf32_section_header_table -> byte_sequence -> error (list elf32_note)*)
definition obtain_elf32_note_section_and_segments  :: " endianness \<Rightarrow>(elf32_program_header_table_entry)list \<Rightarrow>(elf32_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf32_note)list)error "  where 
     " obtain_elf32_note_section_and_segments endian pht sht bs0 = (
  obtain_elf32_note_segments endian pht bs0 >>= (\<lambda> pht_notes . 
  obtain_elf32_note_sections endian sht bs0 >>= (\<lambda> sht_notes . 
  error_return (pht_notes @ sht_notes))))"

  
(** [obtain_elf64_note_section_and_segments endian pht sht bs0] returns all note
  * sections and segments present in an ELF file, as indicated by the file's
  * program header table [pht] and section header table [sht], reading
  * them from byte sequence [bs0] assuming endianness [endian].  May fail if
  * transcription of a note section or segment fails.
  *)
(*val obtain_elf64_note_section_and_segments : endianness -> elf64_program_header_table ->
  elf64_section_header_table -> byte_sequence -> error (list elf64_note)*)
definition obtain_elf64_note_section_and_segments  :: " endianness \<Rightarrow>(elf64_program_header_table_entry)list \<Rightarrow>(elf64_section_header_table_entry)list \<Rightarrow> byte_sequence \<Rightarrow>((elf64_note)list)error "  where 
     " obtain_elf64_note_section_and_segments endian pht sht bs0 = (
  obtain_elf64_note_segments endian pht bs0 >>= (\<lambda> pht_notes . 
  obtain_elf64_note_sections endian sht bs0 >>= (\<lambda> sht_notes . 
  error_return (pht_notes @ sht_notes))))"

    
(** [name_string_of_elf32_note note] extracts the name string of an ELF note
  * section, interpreting the section's uninterpreted name field as a string.
  *)
(*val name_string_of_elf32_note : elf32_note -> string*)
definition name_string_of_elf32_note  :: " elf32_note \<Rightarrow> string "  where 
     " name_string_of_elf32_note note1 = (
  (let bs0   = (Byte_sequence.from_byte_lists [(elf32_note_name   note1)]) in
    Byte_sequence.string_of_byte_sequence bs0))"

  
(** [name_string_of_elf64_note note] extracts the name string of an ELF note
  * section, interpreting the section's uninterpreted name field as a string.
  *)  
(*val name_string_of_elf64_note : elf64_note -> string*)
definition name_string_of_elf64_note  :: " elf64_note \<Rightarrow> string "  where 
     " name_string_of_elf64_note note1 = (
  (let bs0   = (Byte_sequence.from_byte_lists [(elf64_note_name   note1)]) in
    Byte_sequence.string_of_byte_sequence bs0))"
 
end
