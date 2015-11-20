chapter {* Generated by Lem from abis/amd64/abi_amd64_serialisation.lem. *}

theory "Abi_amd64_serialisation" 

imports 
 	 Main
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 

(** [abi_amd64_serialisation] contains code for producing an AMD64 conformant
  * ELF file from executable (machine) code.
  * Used in ongoing experiments with CakeML.
  *
  * XXX: experimental, and outdated.  Commented out for now until attention turns
  * to CakeML again.
  *)

(*open import Basic_classes*)
(*open import List*)
(*open import Maybe*)
(*open import Num*)

(*open import Byte_sequence*)
(*open import Missing_pervasives*)

(*open import Memory_image*)
(*open import Elf_file*)
(*open import Elf_header*)
(*open import Elf_interpreted_segment*)
(*open import Elf_program_header_table*)
(*open import Elf_section_header_table*)
(*open import Elf_types_native_uint*)

(*open import Abi_amd64_elf_header*)

(*
(** [abi_amd64_elf_ident abi_version] produces the ELF identification field for
  * the ELF header based on ABI-specific information and the [abi_version]
  * argument passed in.
  *)
val abi_amd64_elf_ident : natural -> list unsigned_char
let abi_amd64_elf_ident abi_version =
  List.map unsigned_char_of_natural 
    [127; 69; 76; 70; (* 127 E L F *)
     abi_amd64_file_class; abi_amd64_data_encoding; abi_amd64_file_version;
     elf_osabi_none; abi_version; 0;
     0; 0; 0;
     0; 0; 0]

(** [abi_amd64_generate_elf_header entry phoff phnum] produces an ELF header for
  * 64-bit PPC ELF files.  The function expects the [entry] address to start
  * execution from, the offset of the program header table in [phoff] and the
  * number of entries in the program header table in [phnum].
  *)
val abi_amd64_generate_elf_header : elf64_addr -> elf64_off -> elf64_half -> elf64_header
let abi_amd64_generate_elf_header entry phoff phnum =
  <| elf64_ident     = abi_amd64_elf_ident 0;
     elf64_type      = elf64_half_of_natural elf_ft_exec;
     elf64_machine   = elf64_half_of_natural elf_ma_x86_64;
     elf64_version   = elf64_word_of_natural elf_ev_current;
     elf64_entry     = entry;
     elf64_phoff     = phoff;
     elf64_shoff     = elf64_off_of_natural  0;
     elf64_flags     = elf64_word_of_natural 0;
     elf64_ehsize    = elf64_half_of_natural 64;
     elf64_phentsize = elf64_half_of_natural 56;
     elf64_phnum     = phnum;
     elf64_shentsize = elf64_half_of_natural 0;
     elf64_shnum     = elf64_half_of_natural 0;
     elf64_shstrndx  = elf64_half_of_natural shn_undef
  |>

val elf64_pack_segment_flags : (bool * bool * bool) -> elf64_word
let elf64_pack_segment_flags (r, w, x) =
  let xflag = 1 * natural_of_bool x in
  let wflag = 2 * natural_of_bool w in
  let rflag = 4 * natural_of_bool r in
    elf64_word_of_natural (xflag + wflag + rflag)

val elf64_header_size : natural
let elf64_header_size = 64

val elf64_program_header_table_entry_size : natural
let elf64_program_header_table_entry_size = 56

val exec_entry_offset : natural
let exec_entry_offset =
  elf64_header_size + (elf64_program_header_table_entry_size * 3)

val code_heap_entry_offset : natural -> natural
let code_heap_entry_offset exec_size =
  elf64_header_size + (elf64_program_header_table_entry_size * 3) + exec_size

val data_heap_entry_offset : natural -> natural -> natural
let data_heap_entry_offset exec_size code_heap_size =
  elf64_header_size + (elf64_program_header_table_entry_size * 3) + exec_size + code_heap_size

val abi_amd64_generate_program_header_table : elf64_interpreted_segment -> elf64_interpreted_segment -> elf64_interpreted_segment -> elf64_program_header_table
let abi_amd64_generate_program_header_table exec code_heap data_heap =
  (* exec segment and then base *)
  let exec_header =
    <| elf64_p_type   = elf64_word_of_natural exec.elf64_segment_type;
       elf64_p_flags  = elf64_pack_segment_flags exec.elf64_segment_flags;
       elf64_p_offset = elf64_off_of_natural exec.elf64_segment_offset;
       elf64_p_vaddr  = elf64_addr_of_natural exec.elf64_segment_base;
       elf64_p_paddr  = elf64_addr_of_natural exec.elf64_segment_paddr;
       elf64_p_filesz = elf64_xword_of_natural exec.elf64_segment_size;
       elf64_p_memsz  = elf64_xword_of_natural exec.elf64_segment_memsz;
       elf64_p_align  = elf64_xword_of_natural exec.elf64_segment_align |>
  in
  let code_heap_header =
    <| elf64_p_type   = elf64_word_of_natural code_heap.elf64_segment_type;
       elf64_p_flags  = elf64_pack_segment_flags code_heap.elf64_segment_flags;
       elf64_p_offset = elf64_off_of_natural code_heap.elf64_segment_offset;
       elf64_p_vaddr  = elf64_addr_of_natural code_heap.elf64_segment_base;
       elf64_p_paddr  = elf64_addr_of_natural code_heap.elf64_segment_paddr;
       elf64_p_filesz = elf64_xword_of_natural code_heap.elf64_segment_size;
       elf64_p_memsz  = elf64_xword_of_natural code_heap.elf64_segment_memsz;
       elf64_p_align  = elf64_xword_of_natural code_heap.elf64_segment_align |>
  in
  let data_heap_header =
    <| elf64_p_type   = elf64_word_of_natural data_heap.elf64_segment_type;
       elf64_p_flags  = elf64_pack_segment_flags data_heap.elf64_segment_flags;
       elf64_p_offset = elf64_off_of_natural data_heap.elf64_segment_offset;
       elf64_p_vaddr  = elf64_addr_of_natural data_heap.elf64_segment_base;
       elf64_p_paddr  = elf64_addr_of_natural data_heap.elf64_segment_paddr;
       elf64_p_filesz = elf64_xword_of_natural data_heap.elf64_segment_size;
       elf64_p_memsz  = elf64_xword_of_natural data_heap.elf64_segment_memsz;
       elf64_p_align  = elf64_xword_of_natural data_heap.elf64_segment_align |>
  in
    [exec_header; code_heap_header; data_heap_header]

val abi_amd64_generate_exec_interpreted_segment : natural -> natural -> byte_sequence -> elf64_interpreted_segment
let abi_amd64_generate_exec_interpreted_segment vma offset exec_code =
  let segment_size = Byte_sequence.length exec_code in
    <| elf64_segment_body = exec_code;
        elf64_segment_size = segment_size;
        elf64_segment_memsz = segment_size;
        elf64_segment_base = vma;
        elf64_segment_paddr = 0;
        elf64_segment_align = abi_amd64_page_size_max;
        elf64_segment_flags = (true, false, true);
        elf64_segment_type = elf_pt_load;
        elf64_segment_offset = offset
    |>

val abi_amd64_generate_code_heap_interpreted_segment : natural -> natural -> natural -> elf64_interpreted_segment
let abi_amd64_generate_code_heap_interpreted_segment vma offset segment_size =
  let seg = Byte_sequence.create segment_size Missing_pervasives.null_byte in
    <| elf64_segment_body = seg;
        elf64_segment_size = segment_size;
        elf64_segment_memsz = segment_size;
        elf64_segment_base = vma;
        elf64_segment_paddr = 0;
        elf64_segment_align = abi_amd64_page_size_max;
        elf64_segment_flags = (true, true, true);
        elf64_segment_type = elf_pt_load;
        elf64_segment_offset = offset
    |>

val abi_amd64_entry_point_addr : natural
let abi_amd64_entry_point_addr = 4194304 (* 0x400000 *)

val abi_amd64_code_heap_addr : natural
let abi_amd64_code_heap_addr = 67108864 (* 16 * 4194304 *)

val abi_amd64_data_heap_addr : natural
let abi_amd64_data_heap_addr = 67108864 * 16

val quad_le_bytes_of_natural : natural -> byte * byte * byte * byte
let quad_le_bytes_of_natural m =
  let conv = elf64_addr_of_natural m in
  let b0   = byte_of_natural (natural_of_elf64_addr (elf64_addr_land conv (elf64_addr_of_natural 255))) in
  let b1   = byte_of_natural (natural_of_elf64_addr (elf64_addr_land (elf64_addr_rshift conv 8) (elf64_addr_of_natural 255))) in
  let b2   = byte_of_natural (natural_of_elf64_addr (elf64_addr_land (elf64_addr_rshift conv 16) (elf64_addr_of_natural 255))) in
  let b3   = byte_of_natural (natural_of_elf64_addr (elf64_addr_land (elf64_addr_rshift conv 24) (elf64_addr_of_natural 255))) in
    (b0, b1, b2, b3)

val abi_amd64_generate_data_heap_interpreted_segment : natural -> natural -> natural -> natural -> elf64_interpreted_segment
let abi_amd64_generate_data_heap_interpreted_segment vma off segment_size code_heap_size =
  let (d0, d1, d2, d3) = quad_le_bytes_of_natural segment_size in
  let (c0, c1, c2, c3) = quad_le_bytes_of_natural abi_amd64_code_heap_addr in
  let (sz0, sz1, sz2, sz3) = quad_le_bytes_of_natural code_heap_size in
  let (pc0, pc1, pc2, pc3) = quad_le_bytes_of_natural 0 in
  let (gc0, gc1, gc2, gc3) = quad_le_bytes_of_natural 0 in
  let preamble       = Byte_sequence.from_byte_lists [[
                          d0; d1; d2; d3; null_byte; null_byte; null_byte; null_byte;
                          c0; c1; c2; c3; null_byte; null_byte; null_byte; null_byte;
                          sz0; sz1; sz2; sz3; null_byte; null_byte; null_byte; null_byte;
                          pc0; pc1; pc2; pc3; null_byte; null_byte; null_byte; null_byte;
                          gc0; gc1; gc2; gc3; null_byte; null_byte; null_byte; null_byte
                       ]] in
    <| elf64_segment_body = preamble;
        elf64_segment_size  = Byte_sequence.length preamble;
        elf64_segment_memsz = max segment_size (Byte_sequence.length preamble);
        elf64_segment_base = vma;
        elf64_segment_paddr = 0;
        elf64_segment_align = abi_amd64_page_size_max;
        elf64_segment_flags = (true, true, false);
        elf64_segment_type = elf_pt_load;
        elf64_segment_offset = off
    |>

val init_data_heap_instrs : byte_sequence
let init_data_heap_instrs =
  let (b0, b1, b2, b3) = quad_le_bytes_of_natural abi_amd64_data_heap_addr in
    Byte_sequence.from_byte_lists
      [[ byte_of_natural 72
      ; byte_of_natural 199
      ; byte_of_natural 68
      ; byte_of_natural 36
      ; byte_of_natural 248
      ; b0
      ; b1
      ; b2
      ; b3
      ; byte_of_natural 72
      ; byte_of_natural 139
      ; byte_of_natural 68
      ; byte_of_natural 36
      ; byte_of_natural 248
      ]]

val exit_syscall_instrs : byte_sequence
let exit_syscall_instrs =
  Byte_sequence.from_byte_lists
    [[
      byte_of_natural 72;
      byte_of_natural 199;
      byte_of_natural 192;
      byte_of_natural 60;
      byte_of_natural 0;
      byte_of_natural 0;
      byte_of_natural 0;
      byte_of_natural 15;
      byte_of_natural 5
    ]]

val push_instr : natural -> byte_sequence
let push_instr addr =
  let (b0, b1, b2, b3) = quad_le_bytes_of_natural addr in
    Byte_sequence.from_byte_lists [[
      byte_of_natural 104;
      b0; b1; b2; b3
    ]]

val setup_return_code_instr : byte_sequence
let setup_return_code_instr =
  Byte_sequence.from_byte_lists [[
    byte_of_natural 191;
    byte_of_natural 0;
    byte_of_natural 0;
    byte_of_natural 0;
    byte_of_natural 0
  ]]

val abi_amd64_generate_executable_file : byte_sequence -> natural -> natural -> elf64_file
let abi_amd64_generate_executable_file exec_code code_heap_size data_heap_size  =
  let exec_code'   = Byte_sequence.concat [
                       init_data_heap_instrs;
                       exec_code
                     ] in
  let pre_entry    = 5 + abi_amd64_entry_point_addr + Byte_sequence.length exec_code' in
  let exec_code    = Byte_sequence.concat [push_instr pre_entry; exec_code'; setup_return_code_instr; exit_syscall_instrs] in
  let hdr          = abi_amd64_generate_elf_header
                       (elf64_addr_of_natural abi_amd64_entry_point_addr)
                         (elf64_off_of_natural 64) (elf64_half_of_natural 3) in
  let exec_off_i   = 64 + 3 * 56 in
  let exec_off_adj = compute_virtual_address_adjustment abi_amd64_page_size_max exec_off_i abi_amd64_entry_point_addr in
  let exec_off     = exec_off_i + exec_off_adj in
  let exec         = abi_amd64_generate_exec_interpreted_segment
                       abi_amd64_entry_point_addr exec_off exec_code in
  let code_off_i   = exec_off + exec.elf64_segment_size in
  let code_off_adj = compute_virtual_address_adjustment abi_amd64_page_size_max code_off_i abi_amd64_code_heap_addr in
  let code_off     = code_off_i + code_off_adj in
  let code_heap    = abi_amd64_generate_code_heap_interpreted_segment
                       abi_amd64_code_heap_addr code_off code_heap_size in
  let data_off_i   = code_off + code_heap.elf64_segment_size in
  let data_off_adj = compute_virtual_address_adjustment abi_amd64_page_size_max data_off_i abi_amd64_data_heap_addr in
  let data_off     = data_off_i + data_off_adj in
  let data_heap    = abi_amd64_generate_data_heap_interpreted_segment
                       abi_amd64_data_heap_addr data_off data_heap_size code_heap_size in
  let pht          = abi_amd64_generate_program_header_table
                       exec code_heap data_heap in
    <| elf64_file_header = hdr; elf64_file_program_header_table = pht;
          elf64_file_interpreted_segments = [exec; code_heap; data_heap];
          elf64_file_interpreted_sections = [];
          elf64_file_section_header_table = [];
          elf64_file_bits_and_bobs = [] |>
*)
end
