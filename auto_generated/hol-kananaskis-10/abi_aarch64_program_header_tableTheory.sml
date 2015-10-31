structure abi_aarch64_program_header_tableTheory :> abi_aarch64_program_header_tableTheory =
struct
  val _ = if !Globals.print_thy_loads then print "Loading abi_aarch64_program_header_tableTheory ... " else ()
  open Type Term Thm
  infixr -->

  fun C s t ty = mk_thy_const{Name=s,Thy=t,Ty=ty}
  fun T s t A = mk_thy_type{Tyop=s, Thy=t,Args=A}
  fun V s q = mk_var(s,q)
  val U     = mk_vartype
  (*  Parents *)
  local open lem_numTheory
  in end;
  val _ = Theory.link_parents
          ("abi_aarch64_program_header_table",
          Arbnum.fromString "1445346454",
          Arbnum.fromString "177335")
          [("lem_num",
           Arbnum.fromString "1444993253",
           Arbnum.fromString "763379")];
  val _ = Theory.incorporate_types "abi_aarch64_program_header_table" [];

  val idvector = 
    let fun ID(thy,oth) = {Thy = thy, Other = oth}
    in Vector.fromList
  [ID("num", "num"), ID("arithmetic", "*"), ID("min", "fun"),
   ID("arithmetic", "+"), ID("min", "="), ID("min", "bool"),
   ID("arithmetic", "BIT1"), ID("arithmetic", "BIT2"),
   ID("arithmetic", "NUMERAL"), ID("arithmetic", "ZERO"),
   ID("abi_aarch64_program_header_table", "abi_aarch64_pt_archext"),
   ID("abi_aarch64_program_header_table", "abi_aarch64_pt_unwind")]
  end;
  local open SharingTables
  in
  val tyvector = build_type_vector idvector
  [TYOP [0], TYOP [2, 0, 0], TYOP [2, 0, 1], TYOP [5], TYOP [2, 0, 3],
   TYOP [2, 0, 4]]
  end
  val _ = Theory.incorporate_consts "abi_aarch64_program_header_table" tyvector
     [("abi_aarch64_pt_unwind", 0), ("abi_aarch64_pt_archext", 0)];

  local open SharingTables
  in
  val tmvector = build_term_vector idvector tyvector
  [TMC(1, 2), TMC(3, 2), TMC(4, 5), TMC(6, 1), TMC(7, 1), TMC(8, 1),
   TMC(9, 0), TMC(10, 0), TMC(11, 0)]
  end
  local
  val DT = Thm.disk_thm val read = Term.read_raw tmvector
  in
  fun op abi_aarch64_pt_archext_def x = x
    val op abi_aarch64_pt_archext_def =
    DT(((("abi_aarch64_program_header_table",0),[]),[]),
       [read"%2%7@%0%5%4%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%4%4%6@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%5%4%6@@@@"])
  fun op abi_aarch64_pt_unwind_def x = x
    val op abi_aarch64_pt_unwind_def =
    DT(((("abi_aarch64_program_header_table",1),[]),[]),
       [read"%2%8@%1%0%5%4%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%3%4%4%6@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%5%4%6@@@@%5%3%6@@@@"])
  end
  val _ = DB.bindl "abi_aarch64_program_header_table"
  [("abi_aarch64_pt_archext_def",abi_aarch64_pt_archext_def,DB.Def),
   ("abi_aarch64_pt_unwind_def",abi_aarch64_pt_unwind_def,DB.Def)]

  local open Portable GrammarSpecials Parse
    fun UTOFF f = Feedback.trace("Parse.unicode_trace_off_complaints",0)f
  in
  val _ = mk_local_grms [("lem_numTheory.lem_num_grammars",
                          lem_numTheory.lem_num_grammars)]
  val _ = List.app (update_grms reveal) []
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("abi_aarch64_pt_archext", (Term.prim_mk_const { Name = "abi_aarch64_pt_archext", Thy = "abi_aarch64_program_header_table"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("abi_aarch64_pt_archext", (Term.prim_mk_const { Name = "abi_aarch64_pt_archext", Thy = "abi_aarch64_program_header_table"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("abi_aarch64_pt_unwind", (Term.prim_mk_const { Name = "abi_aarch64_pt_unwind", Thy = "abi_aarch64_program_header_table"}))
  val _ = update_grms
       (UTOFF temp_overload_on)
       ("abi_aarch64_pt_unwind", (Term.prim_mk_const { Name = "abi_aarch64_pt_unwind", Thy = "abi_aarch64_program_header_table"}))
  val abi_aarch64_program_header_table_grammars = Parse.current_lgrms()
  end
  val _ = Theory.LoadableThyData.temp_encoded_update {
    thy = "abi_aarch64_program_header_table",
    thydataty = "compute",
    data =
        "abi_aarch64_program_header_table.abi_aarch64_pt_archext_def abi_aarch64_program_header_table.abi_aarch64_pt_unwind_def"
  }

val _ = if !Globals.print_thy_loads then print "done\n" else ()
val _ = Theory.load_complete "abi_aarch64_program_header_table"
end