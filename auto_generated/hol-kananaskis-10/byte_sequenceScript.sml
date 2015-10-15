(*Generated by Lem from byte_sequence.lem.*)
open HolKernel Parse boolLib bossLib;
open lem_numTheory lem_listTheory lem_basic_classesTheory lem_boolTheory lem_stringTheory lem_assert_extraTheory showTheory missing_pervasivesTheory errorTheory;

val _ = numLib.prefer_num();



val _ = new_theory "byte_sequence"

(** [byte_sequence.lem], a list of bytes used for ELF I/O and other basic tasks
  * in the ELF model.
  *)

(*open import Basic_classes*)
(*open import Bool*)
(*open import List*)
(*open import Num*)
(*open import String*)
(*open import Assert_extra*)

(*open import Error*)
(*open import Missing_pervasives*)
(*open import Show*)

(** A [byte_sequence], [bs], denotes a consecutive list of bytes.  Can be read
  * from or written to a binary file.  Most basic type in the ELF formalisation.
  *)
val _ = Hol_datatype `
 byte_sequence =
  Sequence of (8 word) list`;


(** [byte_list_of_byte_sequence bs] obtains the underlying list of bytes of the
  * byte sequence [bs].
  *)
(*val byte_list_of_byte_sequence : byte_sequence -> list byte*)
val _ = Define `
 (byte_list_of_byte_sequence bs0 =  
((case bs0 of
      Sequence xs => xs
  )))`;


(** [compare_byte_sequence bs1 bs2] is an ordering comparison function for byte
  * sequences, suitable for constructing sets, maps and other ordered types
  * with.
  *)
(*val compare_byte_sequence : byte_sequence -> byte_sequence -> ordering*)
val _ = Define `
 (compare_byte_sequence s1 s2 =  
(lexicographic_compare compare_byte (byte_list_of_byte_sequence s1) (byte_list_of_byte_sequence s2)))`;


val _ = Define `
(instance_Basic_classes_Ord_Byte_sequence_byte_sequence_dict =(<|

  compare_method := compare_byte_sequence;

  isLess_method := (\ f1 .  (\ f2 .  (compare_byte_sequence f1 f2 = LT)));

  isLessEqual_method := (\ f1 .  (\ f2 .  let result = (compare_byte_sequence f1 f2) in (result = LT) \/ (result = EQ)));

  isGreater_method := (\ f1 .  (\ f2 .  (compare_byte_sequence f1 f2 = GT)));

  isGreaterEqual_method := (\ f1 .  (\ f2 .  let result = (compare_byte_sequence f1 f2) in (result = GT) \/ (result = EQ)))|>))`;


(** [acquire_byte_list fname] exhaustively reads in a list of bytes from a file
  * pointed to by filename [fname].  Fails if the file does not exist, or if the
  * transcription otherwise fails.  Implemented as a primitive in OCaml.
  *)
(*val acquire_byte_list : string -> error (list byte)*)

(** [acquire fname] exhaustively reads in a byte_sequence from a file pointed to
  * by filename [fname].  Fails if the file does not exist, or if the transcription
  * otherwise fails.
  *)
(*val acquire : string -> error byte_sequence*)

(** [serialise_byte_list fname bs] writes a list of bytes, [bs], to a binary file
  * pointed to by filename [fname].  Fails if the transcription fails.  Implemented
  * as a primitive in OCaml.
  *)
(*val serialise_byte_list : string -> list byte -> error unit*)

(** [serialise fname bs0] writes a byte sequence, [bs0], to a binary file pointed
  * to by filename [fname].  Fails if the transcription fails.
  *)
(*val serialise : string -> byte_sequence -> error unit*)

(** [empty], the empty byte sequence.
  *)
(*val empty : byte_sequence*)
val _ = Define `
 (empty = (Sequence []))`;


(** [read_char bs0] reads a single byte from byte sequence [bs0] and returns the
  * remainder of the byte sequence.  Fails if [bs0] is empty.
  * TODO: rename to read_byte, probably.
  *)
(*val read_char : byte_sequence -> error (byte * byte_sequence)*)
val _ = Define `
 (read_char (Sequence ts) =  
((case ts of
      []    => fail0 "read_char: sequence is empty"
    | x::xs => return (x, Sequence xs)
  )))`;


(** [repeat cnt b] creates a list of length [cnt] containing only [b].
  * TODO: move into missing_pervasives.lem.
  *)
(*val repeat : natural -> byte -> list byte*)
 val repeat_defn = Hol_defn "repeat" `
 (repeat count1 c =  
((case count1 of
      0 => []
    | m => c::repeat (count1 -  1) c
  )))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn repeat_defn;

(** [create cnt b] creates a byte sequence of length [cnt] containing only [b].
  *)
(*val create : natural -> byte -> byte_sequence*)
val _ = Define `
 (create count1 c =  
(Sequence (repeat count1 c)))`;


(** [zeros cnt] creates a byte sequence of length [cnt] containing only 0, the
  * null byte.
  *)
(*val zeros : natural -> byte_sequence*)
val _ = Define `
 (zeros m =  
(create m (0w : 8 word)))`;


(** [length bs0] returns the length of [bs0].
  *)
(*val length : byte_sequence -> natural*)
val _ = Define `
 (length0 (Sequence ts) =  
( (LENGTH ts)))`;



(** [concat bs] concatenates a list of byte sequences, [bs], into a single byte
  * sequence, maintaining byte order across the sequences.
  *)
(*val concat : list byte_sequence -> byte_sequence*)
 val concat0_defn = Hol_defn "concat0" `
 (concat0 ts =  
((case ts of
      []                 => Sequence []
    | ((Sequence x)::xs) =>
      (case concat0 xs of
          Sequence tail => Sequence (x ++ tail)
      )
  )))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn concat0_defn;

(** [zero_pad_to_length len bs0] pads (on the right) consecutive zeros until the
  * resulting byte sequence is [len] long.  Returns [bs0] if [bs0] is already of
  * greater length than [len].
  *)
(*val zero_pad_to_length : natural -> byte_sequence -> byte_sequence*)
val _ = Define `
 (zero_pad_to_length len bs =  
 (let curlen = (length0 bs) in 
    if curlen >= len then
      bs
    else
      concat0 [bs ; (zeros (len - curlen))]))`;


(** [from_byte_lists bs] concatenates a list of bytes [bs] and creates a byte
  * sequence from their contents.  Maintains byte order in [bs].
  *)
(*val from_byte_lists : list (list byte) -> byte_sequence*)
val _ = Define `
 (from_byte_lists ts =  
(Sequence (FLAT ts)))`;


(** [string_of_char_list cs] converts a list of characters into a string.
  * Implemented as a primitive in OCaml.
  *)
(*val string_of_char_list : list char -> string*)

(** [char_list_of_byte_list bs] converts byte list [bs] into a list of characters.
  * Implemented as a primitive in OCaml and Isabelle.
  * TODO: is this actually being used in the Isabelle backend?  All string functions
  * should be factored out by target-specific definitions.
  *)
(*val char_list_of_byte_list : list byte -> list char*)

(** [string_of_byte_sequence bs0] converts byte sequence [bs0] into a string
  * representation.
  *)
(*val string_of_byte_sequence : byte_sequence -> string*)
val _ = Define `
 (string_of_byte_sequence (Sequence ts) =  
(let cs = ((MAP (CHR o w2n) ts)) in
    IMPLODE cs))`;


(** [equal bs0 bs1] checks whether two byte sequences, [bs0] and [bs1], are equal.
  *)
(*val equal : byte_sequence -> byte_sequence -> bool*)
 val equal_defn = Hol_defn "equal" `
 (equal left right =  
((case (left, right) of
      (Sequence [], Sequence []) => T
    | (Sequence (x::xs), Sequence (y::ys)) =>        
(x = y) /\ equal (Sequence xs) (Sequence ys)
    | (_, _) => F
  )))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn equal_defn;

(** [dropbytes cnt bs0] drops [cnt] bytes from byte sequence [bs0].  Fails if
  * [cnt] is greater than the length of [bs0].
  *)
(*val dropbytes : natural -> byte_sequence -> error byte_sequence*)
 val dropbytes_defn = Hol_defn "dropbytes" `
 (dropbytes count1 (Sequence ts) =  
(if count1 = missing_pervasives$naturalZero then
    return (Sequence ts)
  else
    (case ts of
        []    => fail0 "dropbytes: cannot drop more bytes than are contained in sequence"
      | x::xs => dropbytes (count1 -  1) (Sequence xs)
    )))`;

val _ = Lib.with_flag (computeLib.auto_import_definitions, false) Defn.save_defn dropbytes_defn;

(*val takebytes_r_with_length: nat -> natural -> byte_sequence -> error byte_sequence*)
 val _ = Define `
 (takebytes_r_with_length count1 ts_length (Sequence ts) =  
 (if ts_length >= ( count1) then 
    return (Sequence (list_take_with_accum count1 [] ts))
  else
    fail0 "takebytes: cannot take more bytes than are contained in sequence"))`;


(*val takebytes : natural -> byte_sequence -> error byte_sequence*)
val _ = Define `
 (takebytes count1 (Sequence ts) =  
(let result = (takebytes_r_with_length (id count1) (missing_pervasives$length ts) (Sequence ts)) in 
    result))`;


(*val takebytes_with_length : natural -> natural -> byte_sequence -> error byte_sequence*)
val _ = Define `
 (takebytes_with_length count1 ts_length (Sequence ts) =  
(
  (* let _ = Missing_pervasives.errs ("Trying to take " ^ (show count) ^ " bytes from sequence of " ^ (show (List.length ts)) ^ "\n") in *)let result = (takebytes_r_with_length (id count1) ts_length (Sequence ts)) in 
  (*let _ = Missing_pervasives.errs ("Succeeded\n") in *)
    result))`;


(** [read_2_bytes_le bs0] reads two bytes from [bs0], returning them in
  * little-endian order, and returns the remainder of [bs0].  Fails if [bs0] has
  * length less than 2.
  *)
(*val read_2_bytes_le : byte_sequence -> error ((byte * byte) * byte_sequence)*)
val _ = Define `
 (read_2_bytes_le bs0 =  
(read_char bs0 >>= (\ (b0, bs1) . 
  read_char bs1 >>= (\ (b1, bs2) . 
  return ((b1, b0), bs2)))))`;


(** [read_2_bytes_be bs0] reads two bytes from [bs0], returning them in
  * big-endian order, and returns the remainder of [bs0].  Fails if [bs0] has
  * length less than 2.
  *)
(*val read_2_bytes_be : byte_sequence -> error ((byte * byte) * byte_sequence)*)
val _ = Define `
 (read_2_bytes_be bs0 =  
(read_char bs0 >>= (\ (b0, bs1) . 
  read_char bs1 >>= (\ (b1, bs2) . 
  return ((b0, b1), bs2)))))`;


(** [read_4_bytes_le bs0] reads four bytes from [bs0], returning them in
  * little-endian order, and returns the remainder of [bs0].  Fails if [bs0] has
  * length less than 4.
  *)
(*val read_4_bytes_le : byte_sequence -> error ((byte * byte * byte * byte) * byte_sequence)*)
val _ = Define `
 (read_4_bytes_le bs0 =  
(read_char bs0 >>= (\ (b0, bs1) . 
  read_char bs1 >>= (\ (b1, bs2) . 
  read_char bs2 >>= (\ (b2, bs3) . 
  read_char bs3 >>= (\ (b3, bs4) . 
  return ((b3, b2, b1, b0), bs4)))))))`;


(** [read_4_bytes_be bs0] reads four bytes from [bs0], returning them in
  * big-endian order, and returns the remainder of [bs0].  Fails if [bs0] has
  * length less than 4.
  *)
(*val read_4_bytes_be : byte_sequence -> error ((byte * byte * byte * byte) * byte_sequence)*)
val _ = Define `
 (read_4_bytes_be bs0 =  
(read_char bs0 >>= (\ (b0, bs1) . 
  read_char bs1 >>= (\ (b1, bs2) . 
  read_char bs2 >>= (\ (b2, bs3) . 
  read_char bs3 >>= (\ (b3, bs4) . 
  return ((b0, b1, b2, b3), bs4)))))))`;


(** [read_8_bytes_le bs0] reads eight bytes from [bs0], returning them in
  * little-endian order, and returns the remainder of [bs0].  Fails if [bs0] has
  * length less than 8.
  *)
(*val read_8_bytes_le : byte_sequence -> error ((byte * byte * byte * byte * byte * byte * byte * byte) * byte_sequence)*)
val _ = Define `
 (read_8_bytes_le bs0 =  
(read_char bs0 >>= (\ (b0, bs1) . 
  read_char bs1 >>= (\ (b1, bs2) . 
  read_char bs2 >>= (\ (b2, bs3) . 
  read_char bs3 >>= (\ (b3, bs4) . 
  read_char bs4 >>= (\ (b4, bs5) . 
  read_char bs5 >>= (\ (b5, bs6) . 
  read_char bs6 >>= (\ (b6, bs7) . 
  read_char bs7 >>= (\ (b7, bs8) . 
  return ((b7, b6, b5, b4, b3, b2, b1, b0), bs8)))))))))))`;


(** [read_8_bytes_be bs0] reads eight bytes from [bs0], returning them in
  * big-endian order, and returns the remainder of [bs0].  Fails if [bs0] has
  * length less than 8.
  *)
(*val read_8_bytes_be : byte_sequence -> error ((byte * byte * byte * byte * byte * byte * byte * byte) * byte_sequence)*)
val _ = Define `
 (read_8_bytes_be bs0 =  
(read_char bs0 >>= (\ (b0, bs1) . 
  read_char bs1 >>= (\ (b1, bs2) . 
  read_char bs2 >>= (\ (b2, bs3) . 
  read_char bs3 >>= (\ (b3, bs4) . 
  read_char bs4 >>= (\ (b4, bs5) . 
  read_char bs5 >>= (\ (b5, bs6) . 
  read_char bs6 >>= (\ (b6, bs7) . 
  read_char bs7 >>= (\ (b7, bs8) . 
  return ((b0, b1, b2, b3, b4, b5, b6, b7), bs8)))))))))))`;


(** [partition pnt bs0] splits [bs0] into two parts at index [pnt].  Fails if
  * [pnt] is greater than the length of [bs0].
  *)
(*val partition : natural -> byte_sequence -> error (byte_sequence * byte_sequence)*)
val _ = Define `
 (partition0 idx bs0 =  
(takebytes idx bs0 >>= (\ l . 
  dropbytes idx bs0 >>= (\ r . 
  return (l, r)))))`;


(*val partition_with_length : natural -> natural -> byte_sequence -> error (byte_sequence * byte_sequence)*)
val _ = Define `
 (partition_with_length idx bs0_length bs0 =  
(takebytes_with_length idx bs0_length bs0 >>= (\ l . 
  dropbytes idx bs0 >>= (\ r . 
  return (l, r)))))`;


(** [offset_and_cut off cut bs0] first cuts [off] bytes off [bs0], then cuts
  * the resulting byte sequence to length [cut].  Fails if [off] is greater than
  * the length of [bs0] and if [cut] is greater than the length of the intermediate
  * byte sequence.
  *)
(*val offset_and_cut : natural -> natural -> byte_sequence -> error byte_sequence*)
val _ = Define `
 (offset_and_cut off cut bs0 =  
(dropbytes off bs0 >>= (\ bs1 . 
  takebytes cut bs1 >>= (\ res . 
  return res))))`;

val _ = export_theory()

