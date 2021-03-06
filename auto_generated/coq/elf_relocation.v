(* Generated by Lem from elf_relocation.lem. *)

Require Import Arith.
Require Import Bool.
Require Import List.
Require Import String.
Require Import Program.Wf.

Require Import coqharness.

Open Scope nat_scope.
Open Scope string_scope.

(** [elf_relocation] formalises types, functions and other definitions for working
  * with ELF relocation and relocation with addend entries.
  *)

Require Import lem_basic_classes.
Require Export lem_basic_classes.

Require Import lem_num.
Require Export lem_num.

Require Import lem_list.
Require Export lem_list.

Require Import lem_set.
Require Export lem_set.


Require Import endianness.
Require Export endianness.

Require Import byte_sequence.
Require Export byte_sequence.

Require Import error.
Require Export error.


Require Import lem_string.
Require Export lem_string.

Require Import show.
Require Export show.

Require Import missing_pervasives.
Require Export missing_pervasives.


Require Import elf_types_native_uint.
Require Export elf_types_native_uint.


(** ELF relocation records *)

(** [elf32_relocation] is a simple relocation record (without addend).
  *)
Record elf32_relocation : Type :=
  { elf32_r_offset : elf32_addr  (** Address at which to relocate *)
   ; elf32_r_info   : elf32_word  (** Symbol table index/type of relocation to apply *)
   }.
Notation "{[ r 'with' 'elf32_r_offset' := e ]}" := ({| elf32_r_offset := e; elf32_r_info := elf32_r_info r |}).
Notation "{[ r 'with' 'elf32_r_info' := e ]}" := ({| elf32_r_info := e; elf32_r_offset := elf32_r_offset r |}).
Definition elf32_relocation_default: elf32_relocation  := {| elf32_r_offset := elf32_addr_default; elf32_r_info := elf32_word_default |}.

(** [elf32_relocation_a] is a relocation record with addend.
  *)
Record elf32_relocation_a : Type :=
  { elf32_ra_offset : elf32_addr   (** Address at which to relocate *)
   ; elf32_ra_info   : elf32_word   (** Symbol table index/type of relocation to apply *)
   ; elf32_ra_addend : elf32_sword  (** Addend used to compute value to be stored *)
   }.
Notation "{[ r 'with' 'elf32_ra_offset' := e ]}" := ({| elf32_ra_offset := e; elf32_ra_info := elf32_ra_info r; elf32_ra_addend := elf32_ra_addend r |}).
Notation "{[ r 'with' 'elf32_ra_info' := e ]}" := ({| elf32_ra_info := e; elf32_ra_offset := elf32_ra_offset r; elf32_ra_addend := elf32_ra_addend r |}).
Notation "{[ r 'with' 'elf32_ra_addend' := e ]}" := ({| elf32_ra_addend := e; elf32_ra_offset := elf32_ra_offset r; elf32_ra_info := elf32_ra_info r |}).
Definition elf32_relocation_a_default: elf32_relocation_a  := {| elf32_ra_offset := elf32_addr_default; elf32_ra_info := elf32_word_default; elf32_ra_addend := elf32_sword_default |}.

(** [elf64_relocation] is a simple relocation record (without addend).
  *)
Record elf64_relocation : Type :=
  { elf64_r_offset : elf64_addr   (** Address at which to relocate *)
   ; elf64_r_info   : elf64_xword  (** Symbol table index/type of relocation to apply *)
   }.
Notation "{[ r 'with' 'elf64_r_offset' := e ]}" := ({| elf64_r_offset := e; elf64_r_info := elf64_r_info r |}).
Notation "{[ r 'with' 'elf64_r_info' := e ]}" := ({| elf64_r_info := e; elf64_r_offset := elf64_r_offset r |}).
Definition elf64_relocation_default: elf64_relocation  := {| elf64_r_offset := elf64_addr_default; elf64_r_info := elf64_xword_default |}.

(** [elf64_relocation_a] is a relocation record with addend.
  *)
Record elf64_relocation_a : Type :=
  { elf64_ra_offset : elf64_addr    (** Address at which to relocate *)
   ; elf64_ra_info   : elf64_xword   (** Symbol table index/type of relocation to apply *)
   ; elf64_ra_addend : elf64_sxword  (** Addend used to compute value to be stored *)
   }.
Notation "{[ r 'with' 'elf64_ra_offset' := e ]}" := ({| elf64_ra_offset := e; elf64_ra_info := elf64_ra_info r; elf64_ra_addend := elf64_ra_addend r |}).
Notation "{[ r 'with' 'elf64_ra_info' := e ]}" := ({| elf64_ra_info := e; elf64_ra_offset := elf64_ra_offset r; elf64_ra_addend := elf64_ra_addend r |}).
Notation "{[ r 'with' 'elf64_ra_addend' := e ]}" := ({| elf64_ra_addend := e; elf64_ra_offset := elf64_ra_offset r; elf64_ra_info := elf64_ra_info r |}).
Definition elf64_relocation_a_default: elf64_relocation_a  := {| elf64_ra_offset := elf64_addr_default; elf64_ra_info := elf64_xword_default; elf64_ra_addend := elf64_sxword_default |}.
(* [?]: removed value specification. *)

Definition elf64_relocation_a_compare  (ent1 : elf64_relocation_a ) (ent2 : elf64_relocation_a )  : ordering :=     
 (tripleCompare (genericCompare nat_ltb beq_nat) (genericCompare nat_ltb beq_nat) (genericCompare int_ltb Z.eqb) (nat_of_elf64_addr(elf64_ra_offset ent1), nat_of_elf64_xword(elf64_ra_info ent1),
        int_of_elf64_sxword(elf64_ra_addend ent1)) 
        (nat_of_elf64_addr(elf64_ra_offset ent2), nat_of_elf64_xword(elf64_ra_info ent2),
        int_of_elf64_sxword(elf64_ra_addend ent2))).

Instance x69_Ord : Ord elf64_relocation_a := {
     compare  :=  elf64_relocation_a_compare;
     isLess  :=  fun  f1 => (fun  f2 => ( (ordering_equal (elf64_relocation_a_compare f1 f2) LT)));
     isLessEqual  :=  fun  f1 => (fun  f2 => (set_member_by (fun  x  y=>EQ) (elf64_relocation_a_compare f1 f2) [LT;  EQ]));
     isGreater  :=  fun  f1 => (fun  f2 => ( (ordering_equal (elf64_relocation_a_compare f1 f2) GT)));
     isGreaterEqual  :=  fun  f1 => (fun  f2 => (set_member_by (fun  x  y=>EQ) (elf64_relocation_a_compare f1 f2) [GT;  EQ]))
}.

(* [?]: removed value specification. *)

Definition extract_elf32_relocation_r_sym  (w : elf32_word )  : nat := 
  nat_of_elf32_word (elf32_word_rshift w( 8)).
(* [?]: removed value specification. *)

Definition extract_elf64_relocation_r_sym  (w : elf64_xword )  : nat := 
  nat_of_elf64_xword (elf64_xword_rshift w( 32)).
(* [?]: removed value specification. *)

Definition extract_elf32_relocation_r_type  (w : elf32_word )  : nat :=  Coq.Numbers.Natural.Peano.NPeano.modulo
  (nat_of_elf32_word w)( 256).
(* [?]: removed value specification. *)

Definition extract_elf64_relocation_r_type  (w : elf64_xword )  : nat := 
  let magic := Coq.Init.Peano.minus ( Coq.Init.Peano.mult( 65536)( 65536))( 1) in (* 0xffffffffL *)
    nat_of_elf64_xword (elf64_xword_land w (elf64_xword_of_nat magic)).
(* [?]: removed value specification. *)

Definition get_elf32_relocation_r_sym  (r : elf32_relocation )  : nat := 
  extract_elf32_relocation_r_sym(elf32_r_info r).
(* [?]: removed value specification. *)

Definition get_elf32_relocation_a_sym  (r : elf32_relocation_a )   : nat := 
  extract_elf32_relocation_r_sym(elf32_ra_info r).
(* [?]: removed value specification. *)

Definition get_elf64_relocation_sym  (r : elf64_relocation )  : nat := 
  extract_elf64_relocation_r_sym(elf64_r_info r).
(* [?]: removed value specification. *)

Definition get_elf64_relocation_a_sym  (r : elf64_relocation_a )   : nat := 
  extract_elf64_relocation_r_sym(elf64_ra_info r).
(* [?]: removed value specification. *)

Definition get_elf32_relocation_type  (r : elf32_relocation )  : nat := 
  extract_elf32_relocation_r_type(elf32_r_info r).
(* [?]: removed value specification. *)

Definition get_elf32_relocation_a_type  (r : elf32_relocation_a )  : nat := 
  extract_elf32_relocation_r_type(elf32_ra_info r).
(* [?]: removed value specification. *)

Definition get_elf64_relocation_type  (r : elf64_relocation )  : nat := 
  extract_elf64_relocation_r_type(elf64_r_info r).
(* [?]: removed value specification. *)

Definition get_elf64_relocation_a_type  (r : elf64_relocation_a )  : nat := 
  extract_elf64_relocation_r_type(elf64_ra_info r).
(* [?]: removed value specification. *)

Definition read_elf32_relocation  (endian : endianness ) (bs : byte_sequence )  : error ((elf32_relocation *byte_sequence ) % type):= 
  read_elf32_addr endian bs >>= 
  (fun (p : (elf32_addr *byte_sequence ) % type) =>
     match ( (p) ) with ( (r_offset,  bs)) =>
       read_elf32_word endian bs >>=
       (fun (p : (elf32_word *byte_sequence ) % type) =>
          match ( (p) ) with ( (r_info,  bs)) =>
            return0
              ({|elf32_r_offset := r_offset;elf32_r_info := r_info |}, bs)
          end) end).
(* [?]: removed value specification. *)

Definition read_elf64_relocation  (endian : endianness ) (bs : byte_sequence )  : error ((elf64_relocation *byte_sequence ) % type):= 
  read_elf64_addr endian bs  >>= 
  (fun (p : (elf64_addr *byte_sequence ) % type) =>
     match ( (p) ) with ( (r_offset,  bs)) =>
       read_elf64_xword endian bs >>=
       (fun (p : (elf64_xword *byte_sequence ) % type) =>
          match ( (p) ) with ( (r_info,  bs)) =>
            return0
              ({|elf64_r_offset := r_offset;elf64_r_info := r_info |}, bs)
          end) end).
(* [?]: removed value specification. *)

Definition read_elf32_relocation_a  (endian : endianness ) (bs : byte_sequence )  : error ((elf32_relocation_a *byte_sequence ) % type):= 
  read_elf32_addr endian bs  >>= 
  (fun (p : (elf32_addr *byte_sequence ) % type) =>
     match ( (p) ) with ( (r_offset,  bs)) =>
       read_elf32_word endian bs >>=
       (fun (p : (elf32_word *byte_sequence ) % type) =>
          match ( (p) ) with ( (r_info,  bs)) =>
            read_elf32_sword endian bs >>=
            (fun (p : (elf32_sword *byte_sequence ) % type) =>
               match ( (p) ) with ( (r_addend,  bs)) =>
                 return0
                   ({|elf32_ra_offset := r_offset;elf32_ra_info := r_info;elf32_ra_addend := r_addend |}, bs)
               end) end) end).
(* [?]: removed value specification. *)

Definition read_elf64_relocation_a  (endian : endianness ) (bs : byte_sequence )  : error ((elf64_relocation_a *byte_sequence ) % type):= 
  read_elf64_addr endian bs   >>= 
  (fun (p : (elf64_addr *byte_sequence ) % type) =>
     match ( (p) ) with ( (r_offset,  bs)) =>
       read_elf64_xword endian bs >>=
       (fun (p : (elf64_xword *byte_sequence ) % type) =>
          match ( (p) ) with ( (r_info,  bs)) =>
            read_elf64_sxword endian bs >>=
            (fun (p : (elf64_sxword *byte_sequence ) % type) =>
               match ( (p) ) with ( (r_addend,  bs)) =>
                 return0
                   ({|elf64_ra_offset := r_offset;elf64_ra_info := r_info;elf64_ra_addend := r_addend |}, bs)
               end) end) end).
(* [?]: removed value specification. *)

Program Fixpoint read_elf32_relocation_section'  (endian : endianness ) (bs0 : byte_sequence )  : error (list (elf32_relocation )):= 
  if beq_nat (byte_sequence.length0 bs0)( 0) then
    return0 []
  else
    read_elf32_relocation endian bs0 >>= 
  (fun (p : (elf32_relocation *byte_sequence ) % type) =>
     match ( (p) ) with ( (entry,  bs1)) =>
       read_elf32_relocation_section' endian bs1 >>=
       (fun (tail1 : list (elf32_relocation )) => return0 (entry :: tail1))
     end).
(* [?]: removed value specification. *)

Program Fixpoint read_elf64_relocation_section'  (endian : endianness ) (bs0 : byte_sequence )  : error (list (elf64_relocation )):= 
  if beq_nat (byte_sequence.length0 bs0)( 0) then
    return0 []
  else
    read_elf64_relocation endian bs0 >>= 
  (fun (p : (elf64_relocation *byte_sequence ) % type) =>
     match ( (p) ) with ( (entry,  bs1)) =>
       read_elf64_relocation_section' endian bs1 >>=
       (fun (tail1 : list (elf64_relocation )) => return0 (entry :: tail1))
     end).
(* [?]: removed value specification. *)

Program Fixpoint read_elf32_relocation_a_section'  (endian : endianness ) (bs0 : byte_sequence )  : error (list (elf32_relocation_a )):= 
  if beq_nat (byte_sequence.length0 bs0)( 0) then
    return0 []
  else
    read_elf32_relocation_a endian bs0 >>= 
  (fun (p : (elf32_relocation_a *byte_sequence ) % type) =>
     match ( (p) ) with ( (entry,  bs1)) =>
       read_elf32_relocation_a_section' endian bs1 >>=
       (fun (tail1 : list (elf32_relocation_a )) => return0 (entry :: tail1))
     end).
(* [?]: removed value specification. *)

Program Fixpoint read_elf64_relocation_a_section'  (endian : endianness ) (bs0 : byte_sequence )  : error (list (elf64_relocation_a )):= 
  if beq_nat (byte_sequence.length0 bs0)( 0) then
    return0 []
  else
    read_elf64_relocation_a endian bs0 >>= 
  (fun (p : (elf64_relocation_a *byte_sequence ) % type) =>
     match ( (p) ) with ( (entry,  bs1)) =>
       read_elf64_relocation_a_section' endian bs1 >>=
       (fun (tail1 : list (elf64_relocation_a )) => return0 (entry :: tail1))
     end).
(* [?]: removed value specification. *)

Definition read_elf32_relocation_section  (table_size : nat ) (endian : endianness ) (bs0 : byte_sequence )  : error ((list (elf32_relocation )*byte_sequence ) % type):= 
  partition1 table_size bs0 >>= 
  (fun (p : (byte_sequence *byte_sequence ) % type) =>
     match ( (p) ) with ( (eat,  rest)) =>
       read_elf32_relocation_section' endian eat >>=
       (fun (entries : list (elf32_relocation )) => return0 (entries, rest))
     end).
(* [?]: removed value specification. *)

Definition read_elf64_relocation_section  (table_size : nat ) (endian : endianness ) (bs0 : byte_sequence )  : error ((list (elf64_relocation )*byte_sequence ) % type):= 
  partition1 table_size bs0 >>= 
  (fun (p : (byte_sequence *byte_sequence ) % type) =>
     match ( (p) ) with ( (eat,  rest)) =>
       read_elf64_relocation_section' endian eat >>=
       (fun (entries : list (elf64_relocation )) => return0 (entries, rest))
     end).
(* [?]: removed value specification. *)

Definition read_elf32_relocation_a_section  (table_size : nat ) (endian : endianness ) (bs0 : byte_sequence )  : error ((list (elf32_relocation_a )*byte_sequence ) % type):= 
  partition1 table_size bs0 >>= 
  (fun (p : (byte_sequence *byte_sequence ) % type) =>
     match ( (p) ) with ( (eat,  rest)) =>
       read_elf32_relocation_a_section' endian eat >>=
       (fun (entries : list (elf32_relocation_a )) => return0 (entries, rest))
     end).
(* [?]: removed value specification. *)

Definition read_elf64_relocation_a_section  (table_size : nat ) (endian : endianness ) (bs0 : byte_sequence )  : error ((list (elf64_relocation_a )*byte_sequence ) % type):= 
  partition1 table_size bs0 >>= 
  (fun (p : (byte_sequence *byte_sequence ) % type) =>
     match ( (p) ) with ( (eat,  rest)) =>
       read_elf64_relocation_a_section' endian eat >>=
       (fun (entries : list (elf64_relocation_a )) => return0 (entries, rest))
     end).
