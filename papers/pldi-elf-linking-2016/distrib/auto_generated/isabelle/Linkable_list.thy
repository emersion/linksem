chapter {* Generated by Lem from linkable_list.lem. *}

theory "Linkable_list" 

imports 
 	 Main
	 (* IMPORTS MASKED FOR ANONYMOUS REVIEW *)

begin 

(*open import Basic_classes*)
(*open import Function*)
(*open import String*)
(*open import String_extra*)
(*open import Tuple*)
(*open import Bool*)
(*open import List*)
(*open import List_extra*)
(*open import Set*)
(*open import Set_extra*)
(*import Map*)
(*open import Sorting*)
(*open import Num*)
(*open import Maybe*)
(*open import Assert_extra*)

(*open import Byte_sequence*)
(*open import Default_printing*)
(*open import Error*)
(*open import Missing_pervasives*)
(*open import Show*)

(*open import Elf_types_native_uint*)
(*open import Elf_memory_image*)
(*open import Elf_header*)
(*open import Elf_file*)
(*open import Memory_image*)
(*open import Elf_memory_image*)
(*open import Elf_section_header_table*)
(*open import Elf_symbol_table*)
(*open import String_table*)
(*open import Input_list*)

(*open import Elf_memory_image*)
(*open import Elf_memory_image_of_elf64_file*)

type_synonym script =" byte_sequence " (* FIXME *)

datatype linkable_object = RelocELF " elf_memory_image "    (* memory image without address assignments *)
                     | SharedELF " elf_memory_image "   (* memory image with address assignments *)
                     | ScriptAST " script "       (* FIXME: should be elaborated away *)
                     | ControlScriptDefs

(*val string_of_linkable_object : linkable_object -> string*)
fun string_of_linkable_object  :: " linkable_object \<Rightarrow> string "  where 
     " string_of_linkable_object (RelocELF(_)) = ( (''a relocatable file (...)''))"
|" string_of_linkable_object (SharedELF(_)) = ( (''a shared library (...)''))"
|" string_of_linkable_object (ScriptAST(_)) = ( (''a linker script (...)''))"
|" string_of_linkable_object ControlScriptDefs = ( (''the control script''))" 
declare string_of_linkable_object.simps [simp del]


(* We keep the original input item around, hence the filename and byte sequence
 * and options. *)
type_synonym linkable_item =" linkable_object * input_item * input_options "

(*val short_string_of_linkable_item : linkable_item -> string*)
definition short_string_of_linkable_item  :: " linkable_object*(string*input_blob*input_origin)*input_options \<Rightarrow> string "  where 
     " short_string_of_linkable_item item = ( 
    (let (obj, inp, opts) = item
    in
    short_string_of_input_item inp))"


type_synonym linkable_list =" linkable_item list "

type_synonym symbol_resolution_oracle =" linkable_list \<Rightarrow> nat \<Rightarrow> string \<Rightarrow> nat list "
type_synonym binding      =" (nat * symbol_reference * linkable_item) *  (nat * symbol_definition * linkable_item)option "
type_synonym binding_list =" binding list "
type_synonym binding_map  =" (string, ( (nat * binding)list)) Map.map "


fun image_of_linkable_item  :: " linkable_object*'b*'a \<Rightarrow>(Abis.any_abi_feature)annotated_memory_image "  where 
     " image_of_linkable_item (RelocELF(image1), _, _) = ( image1 )"
|" image_of_linkable_item (SharedELF(image1), _, _) = ( image1 )"
|" image_of_linkable_item _ = ( failwith (''no image''))" 
declare image_of_linkable_item.simps [simp del]


(*val linkable_item_of_input_item_and_options : forall 'abifeature. abi 'abifeature -> input_item -> input_options -> linkable_item*)
definition linkable_item_of_input_item_and_options  :: " 'abifeature abi \<Rightarrow> string*input_blob*(Command_line.input_unit*(origin_coord)list)\<Rightarrow> input_options \<Rightarrow> linkable_object*(string*input_blob*(Command_line.input_unit*(origin_coord)list))*input_options "  where 
     " linkable_item_of_input_item_and_options a it opts = ( 
    (case  ((case  it of
        (fname1, Reloc(seq), origin) => 
            (*let _ = Missing_pervasives.errln (Considering relocatable file  ^ fname) in*)
            Elf_file.read_elf64_file seq >>= (\<lambda> e . 
            error_return (RelocELF(elf_memory_image_of_elf64_file a fname1 e), it, opts))
        | (fname1, Shared(seq), origin) => 
            (*let _ = Missing_pervasives.errln (Skipping shared object  ^ fname) in *)
            error_fail (''unsupported input item'')
        | (fname1, Script(seq), origin) => 
            (*let _ = Missing_pervasives.errln (Skipping linker script  ^ fname) in*)
            error_fail (''unsupported input item'')
        ))
    of
        Success(item) => item
        | Fail(str) => failwith (str @ ('': non-ELF or non-relocatable input file''))
    ))"


(*val string_of_linkable : linkable_item -> string*)

(* How do we signal multiple definitions? 
 * This is part of the policy baked into the particular oracle:
 * are multiple definitions okay, or do we fail?
 * 
 * NOTE that multiple definitions *globally* is not the same as 
 * multiple definitions as candidates for a given binding. We
 * can get the former even if we don't have the latter, in some
 * weird group/archive arrangements. The right place to detect
 * this condition is probably when generating the output symtab.
 *)

(*val add_definition_to_map : (natural * symbol_definition * linkable_item) -> Map.map string (list (natural * symbol_definition * linkable_item))
                    -> Map.map string (list (natural * symbol_definition * linkable_item))*)
definition add_definition_to_map  :: " nat*symbol_definition*(linkable_object*input_item*input_options)\<Rightarrow>((string),((nat*symbol_definition*(linkable_object*input_item*input_options))list))Map.map \<Rightarrow>((string),((nat*symbol_definition*(linkable_object*input_item*input_options))list))Map.map "  where 
     " add_definition_to_map def_idx_and_def_and_linkable m = ( 
    (let (def_idx, def1, def_linkable) = def_idx_and_def_and_linkable
    in
    (case   m(def_symname   def1) of
        Some curlist => map_update(def_symname   def1) ((def_idx, def1, def_linkable) # curlist) m
        | None => map_update(def_symname   def1) [(def_idx, def1, def_linkable)] m
    )))"


(*val all_definitions_by_name : linkable_list -> Map.map string (list (natural * symbol_definition * linkable_item))*)
definition all_definitions_by_name  :: "(linkable_object*input_item*input_options)list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map "  where 
     " all_definitions_by_name linkables = ( 
    (* Now that linkables are ELF memory images, we can make the 
     * list of definitions much more easily. *)
    (let list_of_deflists = (Lem_list.mapi (\<lambda> (idx1 :: nat) .  (\<lambda> (item :: linkable_item) . 
        (let img3 = (image_of_linkable_item item)
        in 
        (let (all_def_tags, all_def_ranges)
         = (list_unzip (Multimap.lookupBy0 
  (Memory_image_orderings.instance_Basic_classes_Ord_Memory_image_range_tag_dict
     Abis.instance_Basic_classes_Ord_Abis_any_abi_feature_dict) (instance_Basic_classes_Ord_Maybe_maybe_dict
   (instance_Basic_classes_Ord_tup2_dict
      instance_Basic_classes_Ord_string_dict
      (instance_Basic_classes_Ord_tup2_dict
         instance_Basic_classes_Ord_Num_natural_dict
         instance_Basic_classes_Ord_Num_natural_dict)))  (Memory_image_orderings.tagEquiv
    Abis.instance_Abi_classes_AbiFeatureTagEquiv_Abis_any_abi_feature_dict) (SymbolDef(null_symbol_definition))(by_tag   img3)))
        in
        (let all_defs = (List.map (\<lambda> tag .  (case  tag of
            SymbolDef(def1) => (def1, item)
            | _ => failwith (''matched tag not a symbol definition'')
        )) all_def_tags)
        in
        (let x2 = ([]) in  List.foldr
   (\<lambda>(def1, def_linkable) x2 . 
    if True then ( idx1, def1, def_linkable) # x2 else x2) all_defs x2))))
    )) linkables)
    in
    List.foldl (\<lambda> accum .  (\<lambda> deflist .  
        List.foldl (\<lambda> m .  (\<lambda> (def_idx, def1, def_linkable) .  add_definition_to_map (def_idx, def1, def_linkable) m)) accum deflist
    )) Map.empty list_of_deflists))"

 
type_synonym binding_oracle =" 
    linkable_list 
    \<Rightarrow> (string, ( (nat * symbol_definition * linkable_item)list)) Map.map
    \<Rightarrow> (nat * symbol_reference * linkable_item)
    \<Rightarrow>  (nat * symbol_definition * linkable_item)option "

(*val resolve_one_reference_default : forall 'abifeature. abi 'abifeature -> binding_oracle*)
definition resolve_one_reference_default  :: " 'abifeature abi \<Rightarrow>(linkable_item)list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map \<Rightarrow> nat*symbol_reference*(linkable_object*(string*input_blob*(Command_line.input_unit*(origin_coord)list))*input_options)\<Rightarrow>(nat*symbol_definition*(linkable_object*(string*input_blob*(Command_line.input_unit*(origin_coord)list))*input_options))option "  where 
     " resolve_one_reference_default a linkables defmap ref_idx_and_ref_and_linkable = (
    (let (ref_idx, ref1, ref_linkable) = ref_idx_and_ref_and_linkable
    in
    (* Get the list of all definitions whose name matches. 
     * Don't match empty names. 
     * How should we handle common symbols here?
     * A common symbol is a potential definition, so it goes in the def list.
     *)
    (let (defs_and_linkables_with_matching_name :: (nat * symbol_definition * linkable_item) list)
     = ((case   defmap(ref_symname   ref1) of
        Some (l :: ( (nat * symbol_definition * linkable_item)list)) => l
        | None => []
    ))
    in
    (* Filter the list by eligibility rules. 
     * Normally, 
     * 
     * - any .o file can supply any other .o file on the command line
     * - any .a file supplies only files appearing to its left
     *      i.e. it is searched once for definitions
     * - does a .o file supply a .a file? to both its right and left? Experimentally, YES.
     *
     * So the restrictions are
     * - archives may not supply weak references
     * - archives may only supply to the left, or to themselves, or to objects in the same group
     *)
    (let (ref_obj, (ref_fname, ref_blob, (ref_u, ref_coords)), ref_options) = ref_linkable
    in
    (let ref_is_weak = ((get_elf64_symbol_binding(ref_syment   ref1)) = stb_weak)
    in
    (let def_is_eligible = (\<lambda> (def_idx, def1, def_linkable) .  
        (let ref_is_unnamed = ((ref_symname   ref1) = (''''))
        in
        (let ref_is_to_defined_or_common_symbol = ( \<not> ((unat(elf64_st_shndx  (ref_syment   ref1))) = stn_undef))
        in
        (let def_sym_is_ref_sym = ((ref_idx = def_idx) \<and> (((ref_sym_scn   ref1) =(def_sym_scn   def1))
            \<and> ((ref_sym_idx   ref1) =(def_sym_idx   def1))))
        in
        (let (def_obj, (def_fname, def_blob, def_origin), def_options) = def_linkable
        in
        (let (def_u, def_coords) = def_origin
        in
        (let (def_in_group, def_in_archive) = ((case  def_coords of
              InArchive(aid, aidx, _, _) # InGroup(gid1, gidx) # [_] => (Some gid1, Some aid)
            | InArchive(aid, aidx, _, _) # [_]                       => (None, Some aid)
            | InGroup(gid1, gidx) # [_]                              => (Some gid1, None)
            | [_]                                                    => (None, None)
            | _ => failwith ([(CHR ''i''), (CHR ''n''), (CHR ''t''), (CHR ''e''), (CHR ''r''), (CHR ''n''), (CHR ''a''), (CHR ''l''), (CHR '' ''), (CHR ''e''), (CHR ''r''), (CHR ''r''), (CHR ''o''), (CHR ''r''), (CHR '':''), (CHR '' ''), (CHR ''d''), (CHR ''i''), (CHR ''d''), (CHR ''n''), (Char Nibble2 Nibble7), (CHR ''t''), (CHR '' ''), (CHR ''u''), (CHR ''n''), (CHR ''d''), (CHR ''e''), (CHR ''r''), (CHR ''s''), (CHR ''t''), (CHR ''a''), (CHR ''n''), (CHR ''d''), (CHR '' ''), (CHR ''o''), (CHR ''r''), (CHR ''i''), (CHR ''g''), (CHR ''i''), (CHR ''n''), (CHR '' ''), (CHR ''c''), (CHR ''o''), (CHR ''o''), (CHR ''r''), (CHR ''d''), (CHR ''i''), (CHR ''n''), (CHR ''a''), (CHR ''t''), (CHR ''e''), (CHR ''s''), (CHR '' ''), (CHR ''o''), (CHR ''f''), (CHR '' ''), (CHR ''d''), (CHR ''e''), (CHR ''f''), (CHR ''i''), (CHR ''n''), (CHR ''i''), (CHR ''t''), (CHR ''i''), (CHR ''o''), (CHR ''n'')])
        ))
        in
        (let ref_is_leftmore = (ref_idx \<le> def_idx)
        in
        (* For simplicity we include the case of same archive in in group with. *)
        (let ref_is_in_group_with_def = ((case  def_in_group of 
              None => False
            | Some def_gid => 
                (case  ref_coords of
                  InArchive(_, _, _, _) # InGroup(gid1, _) # [_] => gid1 = def_gid
                | InGroup(gid1, _) # [_]                       => gid1 = def_gid
                | _ => False
                )
            ))
        in
        (* but maybe same archive? *)
        (* DEBUGGING: print some stuff out if we care about this symbol. *)(let _ =            
 (if (ref_fname = (''backtrace.o'')) \<and> ((def_symname   def1) = (''_Unwind_GetCFA'')) then 
                (*Missing_pervasives.errln (saw backtrace.o referencing _Unwind_GetCFA; coords are 
                    ^ def:  ^ (show def_coords) ^ , ref:  ^ (show ref_coords) ^ ; ref_is_in_group_with_def:  
                    ^ (show ref_is_in_group_with_def) ^ ; def_in_group:  ^ (show def_in_group))*)
              () 
            else () )
        in
        (let ref_and_def_are_in_same_archive = ((case  (def_coords, ref_coords) of
            (InArchive(x1, _, _, _) # _, InArchive(x2, _, _, _) # _) => x1 = x2
            | _ => False
        ))
        in
        (let def_is_in_archive = ((case  def_in_archive of
            Some _ => True
            | None => False
        ))
        in
        if ref_is_to_defined_or_common_symbol then def_sym_is_ref_sym
        else 
            if ref_is_unnamed then False
            else
                if def_is_in_archive
                then
                    (\<not> ref_is_weak) 
                    \<and> (
                           ref_is_leftmore
                        \<or> (ref_and_def_are_in_same_archive
                        \<or> ref_is_in_group_with_def)
                    )
                else 
                    True)))))))))))
    )
    in
    (let eligible_defs = (List.filter def_is_eligible defs_and_linkables_with_matching_name)
    in
    (let (maybe_target_def_idx, maybe_target_def, maybe_target_def_linkable) = ((case  eligible_defs of 
        [] => (None, None, None)
        | [(def_idx, def1, def_linkable)] => (Some def_idx, Some def1, Some def_linkable)
        | (d_idx, d, d_l) # more_pairs => 
            (* Break ties by which definition appeared first in the left-to-right order. *)
            (let sorted = (sort_by (\<lambda> (d_idx1, d1, d_l1) .  (\<lambda> (d_idx2, d2, d_l2) .  d_idx1 < d_idx2)) eligible_defs)
            in
            (case  sorted of 
                (first_d_idx, first_d, first_d_l) # _ => (Some first_d_idx, Some first_d, Some first_d_l)
                | _ => failwith (''impossible: sorted list is shorter than original'')
            ))
    ))
    in 
    (*let refstr = ` 
                ^ ref.ref_symname ^ ' ( ^ 
                (if (natural_of_elf64_half ref.ref_syment.elf64_st_shndx) = shn_undef then UND else defined) ^ 
                 symbol at index  ^ (show ref.ref_sym_idx) ^  in symtab 
                ^ (show ref.ref_sym_scn) ^  in  ^ ref_fname
                ^ )
    in
    let _ = Missing_pervasives.errs (Bound a reference from  ^ refstr ^  to )
    in*)
    (case  (maybe_target_def_idx, maybe_target_def, maybe_target_def_linkable) of
        (Some target_def_idx, Some target_def, Some target_def_linkable) =>
            (*let _ = Missing_pervasives.errln ( a definition in ^ (show (target_def_linkable)))
            in*)
            Some(target_def_idx, target_def, target_def_linkable)
    |  (None, None, None) => 
            (*let _ = Missing_pervasives.errln  no definition
            in*)
            if ref_is_weak (* || a.symbol_is_generated_by_linker ref.ref_symname *) then None 
            else (* failwith (undefined symbol:  ^ refstr) *) None
            (* FIXME: do a check, *after* the linker script has been interpreted, 
             * that all remaining undefined symbols are permitted by the ABI/policy. *)
    | _ => failwith (''impossible: non-matching maybes for target_def_idx and target_def'')
    )))))))))"


(*val resolve_all :
    linkable_list
    -> Map.map string (list (natural * symbol_definition * linkable_item))                (* all definitions *)
    -> binding_oracle
    -> list (natural * symbol_reference * linkable_item)
    -> list ((natural * symbol_reference * linkable_item) * maybe (natural * symbol_definition * linkable_item))*)
definition resolve_all  :: "(linkable_item)list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map \<Rightarrow>((linkable_item)list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map \<Rightarrow> nat*symbol_reference*(linkable_object*input_item*input_options) \<Rightarrow>(nat*symbol_definition*linkable_item)option)\<Rightarrow>(nat*symbol_reference*(linkable_object*input_item*input_options))list \<Rightarrow>((nat*symbol_reference*(linkable_object*input_item*input_options))*(nat*symbol_definition*linkable_item)option)list "  where 
     " resolve_all linkables all_defs oracle1 refs = ( 
    List.map (\<lambda> (ref_idx, ref1, ref_linkable) .  ((ref_idx, ref1, ref_linkable), (oracle1 linkables all_defs (ref_idx, ref1, ref_linkable)))) refs )"


(* To accumulate which inputs are needed, we work with a list of undefineds, starting with those
 * in the  forced-output objects. We then iteratively build a list of all needed symbol definitions,
 * pulling in the objects that contain them, until we reach a fixed point. *)
(*val resolve_undefs_in_one_object : 
    linkable_list
    -> Map.map string (list (natural * symbol_definition * linkable_item))                (* all definitions *)
    -> binding_oracle
    -> natural
    -> list ((natural * symbol_reference * linkable_item) * maybe (natural * symbol_definition * linkable_item))*)
definition resolve_undefs_in_one_object  :: "(linkable_object*(string*input_blob*input_origin)*input_options)list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map \<Rightarrow>(linkable_list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map \<Rightarrow> nat*symbol_reference*linkable_item \<Rightarrow>(nat*symbol_definition*linkable_item)option)\<Rightarrow> nat \<Rightarrow>((nat*symbol_reference*linkable_item)*(nat*symbol_definition*linkable_item)option)list "  where 
     " resolve_undefs_in_one_object linkables all_defs oracle1 idx1 = (
    (* Get this object's list of references *)
    (let item = ((case  index linkables ( idx1) of
        Some it => it
        | None => failwith (''impossible: linkable not in list of linkables'')
    ))
    in
    (let img3 = (image_of_linkable_item item)
    in 
    (let (all_ref_tags, all_ref_ranges)
     = (list_unzip (Multimap.lookupBy0 
  (Memory_image_orderings.instance_Basic_classes_Ord_Memory_image_range_tag_dict
     Abis.instance_Basic_classes_Ord_Abis_any_abi_feature_dict) (instance_Basic_classes_Ord_Maybe_maybe_dict
   (instance_Basic_classes_Ord_tup2_dict
      instance_Basic_classes_Ord_string_dict
      (instance_Basic_classes_Ord_tup2_dict
         instance_Basic_classes_Ord_Num_natural_dict
         instance_Basic_classes_Ord_Num_natural_dict)))  (Memory_image_orderings.tagEquiv
    Abis.instance_Abi_classes_AbiFeatureTagEquiv_Abis_any_abi_feature_dict) (SymbolRef(null_symbol_reference_and_reloc_site))(by_tag   img3)))
    in
    (* By using SymbolRef, we are extracting and binding each relocation site individually. 
     * since there might be more than one relocation site referencing the same symbol name, 
     * in a given object.
     * 
     * We are also binding SymbolRefs that have no relocation, which occur when there's
     * an UND symbol which is not actually used by a relocation site, but is nevertheless 
     * in need of being resolved.
     * 
     * We don't (for the moment) want to make different decisions for different reloc sites
     * in the same object referencing the same symbol. So we dedup from a list to a set.
     *)
    (let all_refs = (List.set (List.map (\<lambda> tag .  (case  tag of
        SymbolRef(r) =>(ref   r)
        | _ => failwith (''matched tag not a relocation site'')
    )) all_ref_tags))
    in
    (let ref_triples =
  (Set.image (\<lambda> ref1 .  (idx1, ref1, item))
     (set_filter (\<lambda> ref1 .  True) all_refs))
    in
    (*let _ = Missing_pervasives.errln (object  ^ (show item) ^  has  ^ 
        (show (Set.size ref_triples)) ^  reloc references (symname, sym_scn, sym_idx, st_shndx) ( ^ 
        (show (List.map (fun x -> ( ^ x.ref_symname ^ , x.ref_sym_scn, x.ref_sym_idx, natural_of_elf64_half x.ref_syment.elf64_st_shndx)) (Set_extra.toList all_refs))) ^ ))
    in*)
    (let und_ref_triples =
  (set_filter
     (\<lambda> (idx1, ref1, ref_item) .  (unat
                                             (elf64_st_shndx  (ref_syment   ref1))
                                             = shn_undef)) ref_triples)
    in
    (*let _ = Missing_pervasives.errln (... of which  ^
        (show (Set.size und_ref_triples)) ^  are to undefined symbols: (symname, sym_scn, sym_idx, st_shndx) ( ^ 
        (show (List.map (fun (idx, x, _) -> ( ^ x.ref_symname ^ , x.ref_sym_scn, x.ref_sym_idx, natural_of_elf64_half x.ref_syment.elf64_st_shndx)) (Set_extra.toList und_ref_triples))) ^ ))
    in*)
    resolve_all linkables all_defs oracle1 (list_of_set ref_triples))))))))"


(*val accumulate_bindings_bf : forall 'abifeature.
    abi 'abifeature
    -> linkable_list
    -> Map.map string (list (natural * symbol_definition * linkable_item))                (* all definitions *)
    -> set natural                                        (* inputs fully-bound so far *)
    -> list natural                                       (* ordered list of inputs to bind next *)
    -> list ((natural * symbol_reference * linkable_item) * maybe (natural * symbol_definition * linkable_item))  (* bindings made so far *)
    -> list ((natural * symbol_reference * linkable_item) * maybe (natural * symbol_definition * linkable_item))*)  (* all accumulated bindings bindings *)
function (sequential,domintros)  accumulate_bindings_bf  :: " 'abifeature abi \<Rightarrow>(linkable_item)list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map \<Rightarrow>(nat)set \<Rightarrow>(nat)list \<Rightarrow>((nat*symbol_reference*linkable_item)*(nat*symbol_definition*linkable_item)option)list \<Rightarrow>((nat*symbol_reference*linkable_item)*(nat*symbol_definition*linkable_item)option)list "  where 
     " accumulate_bindings_bf a linkables all_defs fully_bound to_bind bindings_accum = (
    (* This is like foldl, except that each stage
     * can add stuff to the work list *)
    (case  to_bind of 
        [] => bindings_accum (* termination *)
        | l_idx # more_idx =>
            (* Get the new bindings for this object *)
            (let new_bindings = (resolve_undefs_in_one_object
                linkables
                all_defs
                (resolve_one_reference_default a)
                l_idx)
            in
            (let new_fully_bound = (Set.insert l_idx fully_bound)
            in
            (* Which of the new bindings are to objects 
             * not yet fully bound or not yet in the to-bind list? *)
            (let new_bindings_def_idx = (list_concat_map (\<lambda> (ref1, maybe_def_and_idx_and_linkable) .  
                (case  maybe_def_and_idx_and_linkable of 
                    Some (def_idx, def1, def_linkable) => [def_idx]
                    | None => []
                )
            ) new_bindings) 
            in
            (let new_bindings_def_idx_set = (List.set new_bindings_def_idx)
            in
            (let included_linkables_idx = (fully_bound \<union> (List.set to_bind))
            in
            (let new_l_idx = (new_bindings_def_idx_set - included_linkables_idx)
            in
            (let new_l_idx_list = (list_of_set new_l_idx)
            in
            (*let _ = Missing_pervasives.errln (
                if List.null new_l_idx_list 
                then
                    Fully bound references in   ^ (show (List.index linkables (natFromNatural l_idx)))
                        ^  using only already-included linkables ( 
                        ^ (show (List.map (fun i -> List.index linkables (natFromNatural i)) (Set_extra.toList included_linkables_idx)))
                else
                    Including additional linkables 
                    ^ (show (List.mapMaybe (fun i -> List.index linkables (natFromNatural i)) new_l_idx_list))
                    )
            in*)
            accumulate_bindings_bf
                a
                linkables
                all_defs
                new_fully_bound
                (more_idx @ new_l_idx_list)
                (bindings_accum @ new_bindings))))))))
    ))" 
by pat_completeness auto


(* We need a generalised kind of depth-first search in which there are multiple start points. 
 * Also, we always work one object at a time, not one edge at a time; when we pull in an object,
 * we resolve *all* the references therein.
 *)
(*val accumulate_bindings_objectwise_df : forall 'abifeature.
    abi 'abifeature
    -> linkable_list
    -> Map.map string (list (natural * symbol_definition * linkable_item))                (* all definitions *)

    -> list ((natural * symbol_reference * linkable_item) * maybe (natural * symbol_definition * linkable_item))  (* bindings made so far *)
    -> set natural                                        (* inputs fully-bound so far -- these are black *)
    -> list natural                                       (* inputs scheduled for binding -- these include 
                                                             any grey (in-progress) nodes *and*
                                                             any nodes that we have committed to exploring 
                                                             (the start nodes).
                                                             Because we're depth-first, we prepend our adjacent
                                                             nodes to this list, making them grey, then we 
                                                             recurse by taking from the head. We must always
                                                             filter out the prepended nodes from the existing list, 
                                                             to ensure we don't reeurse infinitely. *)
    -> list ((natural * symbol_reference * linkable_item) * maybe (natural * symbol_definition * linkable_item))*)  (* all accumulated bindings bindings *)
function (sequential,domintros)  accumulate_bindings_objectwise_df  :: " 'abifeature abi \<Rightarrow>(linkable_item)list \<Rightarrow>((string),((nat*symbol_definition*linkable_item)list))Map.map \<Rightarrow>((nat*symbol_reference*linkable_item)*(nat*symbol_definition*linkable_item)option)list \<Rightarrow>(nat)set \<Rightarrow>(nat)list \<Rightarrow>((nat*symbol_reference*linkable_item)*(nat*symbol_definition*linkable_item)option)list "  where 
     " accumulate_bindings_objectwise_df a linkables all_defs bindings_accum blacks greys = (
    (case  greys of 
        [] => bindings_accum (* termination *)
        | l_idx # more_idx =>
            (* Get the new bindings for this object *)
            (let new_bindings = (resolve_undefs_in_one_object
                linkables
                all_defs
                (resolve_one_reference_default a)
                l_idx)
            in 
            (* We pull in the whole object at a time (objectwise), so by definition,
             * we have created bindings for everything in this object; it's now black. *)
            (let new_fully_bound = (Set.insert l_idx blacks)
            in
            (* Which of the new bindings are to objects 
             * not yet fully bound or not yet in the to-bind list? *)
            (let new_bindings_def_idx = (list_concat_map (\<lambda> (ref1, maybe_def_and_idx_and_linkable) .  
                (case  maybe_def_and_idx_and_linkable of 
                    Some (def_idx, def1, def_linkable) => [def_idx]
                    | None => []
                )
            ) new_bindings) 
            in
            (let new_bindings_def_idx_set = (List.set new_bindings_def_idx)
            in
            (* this is the black or grey set. *)
            (let included_linkables_idx = (blacks \<union> (List.set greys))
            in
            (* these are the white ones that we're adjacent to *)
            (let new_l_idx = (new_bindings_def_idx_set - included_linkables_idx)
            in
            (let new_l_idx_list = (list_of_set new_l_idx)
            in
            (* What is the new grey-alike list? (This is the list we tail-recurse down.)
             * It's
             * - the existing grey-alike list
             * - with any new (were-white) objects prepended
             * - ... and filtered to *remove* these from the existing list (avoid duplication).
             *)
            (let new_grey_list = (new_l_idx_list @ (List.filter (\<lambda> x .  \<not> (x \<in> new_l_idx)) more_idx))
            in
            (* whether or not we've not uncovered any new white nodes, we tail-recurse  *)
            (*let _ = (if List.null new_l_idx_list then
                Missing_pervasives.errln (Fully bound references in   ^ (show (List.index linkables (natFromNatural l_idx)))
                    ^  using only already-included linkables ( 
                    ^ (show (List.map (fun i -> List.index linkables (natFromNatural i)) (Set_extra.toList included_linkables_idx)))
                ) else Missing_pervasives.errln (Including additional linkables 
            ^ (show (List.mapMaybe (fun i -> List.index linkables (natFromNatural i)) new_l_idx_list))))
            in*)
            accumulate_bindings_objectwise_df
                a
                linkables
                all_defs
                (bindings_accum @ new_bindings)
                (new_fully_bound :: nat set)
                (new_grey_list :: nat list)))))))))
   ))" 
by pat_completeness auto


(* Rather than recursively expanding the link by searching for definitions of undefs, 
 * the GNU linker works by recursing/looping along the list of *linkables*, testing whether
 * any of the defs satisfies a currently-undef'd thing. On adding a new undef'd thing, 
 * we re-search only from the current archive, not from the beginning (i.e. the 
 * def_is_leftmore or def_in_same_archive logic).
 *
 * Why is this not the same as depth-first? One example is if we pull in a new object
 * which happens to have two undefs: one satisfied by the *first* element in the current archive,
 * and one satisfied by the last. 
 * 
 * In the GNU algorithm, we'll pull in the first archive element immediately afterwards, because
 * we'll re-traverse the archive and find it's needed.
 * 
 * In the depth-first algorithm, it depends entirely on the ordering of the new bindings, i.e.
 * the symtab ordering of the two undefs. If the later-in-archive def was bound *first*, we'll
 * recurse down *that* object's dependencies first.
 * 
 * So if we sort the new grey list
 * so that bindings formed in order of *current archive def pos*,
 * will we get the same behaviour?
 * We can't really do this, because we have no current archive.
 * 
 * Need to rewrite the algorithm to fold along the list of linkables.
 *)
end
