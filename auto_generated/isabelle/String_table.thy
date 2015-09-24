chapter {* Generated by Lem from string_table.lem. *}

theory "String_table" 

imports 
 	 Main
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_num" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_list" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_basic_classes" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_maybe" 
	 "/auto/homes/dpm36/Work/Cambridge/bitbucket/lem/isabelle-lib/Lem_string" 
	 "Show" 
	 "Missing_pervasives" 
	 "Error" 
	 "Byte_sequence" 

begin 

(** The [string_table] module implements string tables.  An ELF file may have
  * multiple different string tables used for different purposes.  A string
  * table is a string coupled with a delimiting character.  Strings may be indexed
  * at any position, not necessarily on a delimiter boundary.
  *)

(*open import Basic_classes*)
(*open import List*)
(*open import Maybe*)
(*open import Num*)
(*open import String*)
(*open import Byte_sequence*)

(*open import Error*)
(*open import Missing_pervasives*)
(*open import Show*)

(** [string_table] type, represents a string table with a fixed delimiting
  * character and underlying string.
  *)
datatype string_table
  = Strings " (char * string)"

(** [mk_string_table base sep] constructs a string table using [base] as the
  * base string and [sep] as the delimiting character to use to split [base]
  * when trying to access the string stored in the table using the functions below.
  *)
(*val mk_string_table : string -> char -> string_table*)
definition mk_string_table  :: " string \<Rightarrow> char \<Rightarrow> string_table "  where 
     " mk_string_table base sep = (
  Strings (sep, base))"


(** [string_table_of_byte_sequence seq] constructs a string table, using the NUL
  * character as terminator, from a byte sequence. *)
(*val string_table_of_byte_sequence : byte_sequence -> string_table*)
definition string_table_of_byte_sequence  :: " byte_sequence \<Rightarrow> string_table "  where 
     " string_table_of_byte_sequence seq = ( mk_string_table (string_of_byte_sequence seq) (String.char_of_nat 0))"


(** [empty] is the empty string table with an arbitrary choice of delimiter.
  *)
(*val empty : string_table*)
definition empty0  :: " string_table "  where 
     " empty0 = ( Strings ((String.char_of_nat 0), ('''')))"


(** [get_delimiating_character tbl] returns the delimiting character associated
  * with the string table [tbl], used to split the strings.
  *)
(*val get_delimiting_character : string_table -> char*)
fun get_delimiting_character  :: " string_table \<Rightarrow> char "  where 
     " get_delimiting_character (Strings (sep, base)) = ( sep )" 
declare get_delimiting_character.simps [simp del]


(** [get_base_string tbl] returns the base string of the string table [tbl].
  *)
(*val get_base_string : string_table -> string*)
fun get_base_string  :: " string_table \<Rightarrow> string "  where 
     " get_base_string (Strings (sep, base)) = ( base )" 
declare get_base_string.simps [simp del]


(** [concat xs] concatenates several string tables into one providing they all
  * have the same delimiting character.
  *)
(*val concat : list string_table -> error string_table*)
fun concat_string_table  :: "(string_table)list \<Rightarrow>(string_table)error "  where 
     " concat_string_table ([]) = ( error_return empty0 )"
|" concat_string_table (x # xs) = (
      (let delim = (get_delimiting_character x) in
        if (((\<forall> x0 \<in> (set (x # xs)).  (\<lambda> x .  get_delimiting_character x = delim) x0))) then
          (let base = (List.foldr (op@) (List.map get_base_string (x # xs)) ('''')) in
            error_return (mk_string_table base delim))
        else
          error_fail (''concat: string tables must have same delimiting characters'')))" 
declare concat_string_table.simps [simp del]


(** [get_string_at index tbl] returns the string starting at character [index]
  * from the start of the base string until the first occurrence of the delimiting
  * character.
  *)
(*val get_string_at : natural -> string_table -> error string*)
definition get_string_at  :: " nat \<Rightarrow> string_table \<Rightarrow>(string)error "  where 
     " get_string_at index1 tbl = (
  (case  Elf_Types_Local.string_suffix index1 (get_base_string tbl) of
      None     => Fail (''get_string_at: index out of range'')
    | Some suffix =>
      (let delim = (get_delimiting_character tbl) in
      (case  string_index_of delim suffix of
          Some idx =>
          (case  string_prefix idx suffix of
              Some s  => Success s
            | None => Fail (''get_string_at: index out of range'')
          )
        | None => Success suffix
      ))
  ))"

end
