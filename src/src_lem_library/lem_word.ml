(*Generated by Lem from word.lem.*)


open Lem_bool
open Lem_maybe
open Lem_num
open Lem_basic_classes
open Lem_list


(* ========================================================================== *)
(* Define general purpose word, i.e. sequences of bits of arbitrary length    *)
(* ========================================================================== *)

type bitSequence = BitSeq of 
    int option  * (* length of the sequence, Nothing means infinite length *)
   bool * bool       (* sign of the word, used to fill up after concrete value is exhausted *)
   list    (* the initial part of the sequence, least significant bit first *)

(*val bitSeqEq : bitSequence -> bitSequence -> bool*)
let instance_Basic_classes_Eq_Word_bitSequence_dict =({

  isEqual_method = (=);

  isInequal_method = (fun n1 n2->not (n1 = n2))})

(*val boolListFrombitSeq : nat -> bitSequence -> list bool*)

let rec boolListFrombitSeqAux n s bl =  
(if n = 0 then [] else
  (match bl with
    | []       -> replicate n s
    | b :: bl' -> b :: (boolListFrombitSeqAux (Nat_num.nat_monus n( 1)) s bl')
  ))

let boolListFrombitSeq n (BitSeq( _, s, bl)) = (boolListFrombitSeqAux n s bl)


(*val bitSeqFromBoolList : list bool -> maybe bitSequence*)
let bitSeqFromBoolList bl =  
((match dest_init bl with
    | None -> None
    | Some (bl', s) -> Some (BitSeq( (Some (List.length bl)), s, bl'))
  ))


(* cleans up the representation of a bitSequence without changing its semantics *)
(*val cleanBitSeq : bitSequence -> bitSequence*)
let cleanBitSeq (BitSeq( len, s, bl)) = ((match len with
  | None -> (BitSeq( len, s, (List.rev (dropWhile ((=) s) (List.rev bl)))))
  | Some n  -> (BitSeq( len, s, (List.rev (dropWhile ((=) s) (List.rev (Lem_list.take (Nat_num.nat_monus n( 1)) bl))))))
))


(*val bitSeqTestBit : bitSequence -> nat -> maybe bool*)
let bitSeqTestBit (BitSeq( len, s, bl)) pos =  
 ((match len with
    | None -> if pos < List.length bl then list_index bl pos else Some s
    | Some l -> if (pos >= l) then None else
                if ((pos = ( Nat_num.nat_monus l( 1))) || (pos >= List.length bl)) then Some s else
                list_index bl pos
  ))

(*val bitSeqSetBit : bitSequence -> nat -> bool -> bitSequence*)
let bitSeqSetBit (BitSeq( len, s, bl)) pos v =  
(let bl' = (if (pos < List.length bl) then bl else  List.append bl (replicate pos s)) in
  let bl'' = (Lem_list.list_update bl' pos v) in
  let bs' = (BitSeq( len, s, bl'')) in
  cleanBitSeq bs')


(*val resizeBitSeq : maybe nat -> bitSequence -> bitSequence*)
let resizeBitSeq new_len bs =  
(let (BitSeq( len, s, bl)) = (cleanBitSeq bs) in
  let shorten_opt = ((match (new_len, len) with
     | (None, _) -> None
     | (Some l1, None) -> Some l1
     | (Some l1, Some l2) -> if (l1 < l2) then Some l1 else None
  )) in
  (match shorten_opt with
    | None -> BitSeq( new_len, s, bl)
    | Some l1 -> (
        let bl' = (Lem_list.take l1 ( List.append bl [s])) in
        (match dest_init bl' with
          | None -> (BitSeq( len, s, bl)) (* do nothing if size 0 is requested *)
          | Some (bl'', s') -> cleanBitSeq (BitSeq( new_len, s', bl''))
	))
  )) 

(*val bitSeqNot : bitSequence -> bitSequence*)
let bitSeqNot (BitSeq( len, s, bl)) = (BitSeq( len, (not s), (List.map not bl)))

(*val bitSeqBinop : (bool -> bool -> bool) -> bitSequence -> bitSequence -> bitSequence*)

(*val bitSeqBinopAux : (bool -> bool -> bool) -> bool -> list bool -> bool -> list bool -> list bool*)
let rec bitSeqBinopAux binop s1 bl1 s2 bl2 =  
((match (bl1, bl2) with
    | ([], []) -> []
    | (b1 :: bl1', []) -> (binop b1 s2) :: bitSeqBinopAux binop s1 bl1' s2 []
    | ([], b2 :: bl2') -> (binop s1 b2) :: bitSeqBinopAux binop s1 []   s2 bl2'
    | (b1 :: bl1', b2 :: bl2') -> (binop b1 b2) :: bitSeqBinopAux binop s1 bl1' s2 bl2'
  ))

let bitSeqBinop binop bs1 bs2 = (
  let (BitSeq( len1, s1, bl1)) = (cleanBitSeq bs1) in
  let (BitSeq( len2, s2, bl2)) = (cleanBitSeq bs2) in

  let len = ((match (len1, len2) with
    | (Some l1, Some l2) -> Some (max l1 l2)
    | _ -> None
  )) in
  let s = (binop s1 s2) in
  let bl = (bitSeqBinopAux binop s1 bl1 s2 bl2) in
  cleanBitSeq (BitSeq( len, s, bl))
)

let bitSeqAnd = (bitSeqBinop (&&))
let bitSeqOr = (bitSeqBinop (||))
let bitSeqXor = (bitSeqBinop (fun b1 b2->not (b1 = b2)))

(*val bitSeqShiftLeft : bitSequence -> nat -> bitSequence*)
let bitSeqShiftLeft (BitSeq( len, s, bl)) n = (cleanBitSeq (BitSeq( len, s, ( List.append(replicate n false) bl))))

(*val bitSeqArithmeticShiftRight : bitSequence -> nat -> bitSequence*)
let bitSeqArithmeticShiftRight bs n =  
 (let (BitSeq( len, s, bl)) = (cleanBitSeq bs) in
  cleanBitSeq (BitSeq( len, s, (drop n bl))))

(*val bitSeqLogicalShiftRight : bitSequence -> nat -> bitSequence*)
let bitSeqLogicalShiftRight bs n =  
 (if (n = 0) then cleanBitSeq bs else
  let (BitSeq( len, s, bl)) = (cleanBitSeq bs) in
  (match len with
    | None -> cleanBitSeq (BitSeq( len, s, (drop n bl)))
    | Some l -> cleanBitSeq (BitSeq( len, false, ( List.append(drop n bl) (replicate l s))))
  ))


(* integerFromBoolList sign bl creates an integer from a list of bits
   (least significant bit first) and an explicitly given sign bit.
   It uses two's complement encoding. *)
(*val integerFromBoolList : (bool * list bool) -> integer*)

let rec integerFromBoolListAux (acc : Big_int.big_int) (bl : bool list) =  
 ((match bl with 
    | [] -> acc
    | (true :: bl') -> integerFromBoolListAux ( Big_int.add_big_int( Big_int.mult_big_int acc(Big_int.big_int_of_int 2))(Big_int.big_int_of_int 1)) bl'
    | (false :: bl') -> integerFromBoolListAux ( Big_int.mult_big_int acc(Big_int.big_int_of_int 2)) bl'
  ))

let integerFromBoolList (sign, bl) =   
 (if sign then 
     Big_int.minus_big_int( Big_int.add_big_int(integerFromBoolListAux(Big_int.big_int_of_int 0) (List.rev_map not bl))(Big_int.big_int_of_int 1))
   else integerFromBoolListAux(Big_int.big_int_of_int 0) (List.rev bl))

(* [boolListFromInteger i] creates a sign bit and a list of booleans from an integer. The len_opt tells it when to stop.*)
(*val boolListFromInteger :    integer -> bool * list bool*)

let rec boolListFromNatural acc (remainder : Big_int.big_int) = 
(if ( Big_int.gt_big_int remainder(Big_int.big_int_of_int 0)) then 
   (boolListFromNatural (( Big_int.eq_big_int( Big_int.mod_big_int remainder(Big_int.big_int_of_int 2))(Big_int.big_int_of_int 1)) :: acc) 
      ( Big_int.div_big_int remainder(Big_int.big_int_of_int 2)))
 else
   List.rev acc)

let boolListFromInteger (i : Big_int.big_int) =  
 (if ( Big_int.lt_big_int i(Big_int.big_int_of_int 0)) then
    (true, List.map not (boolListFromNatural [] (Big_int.abs_big_int (Big_int.minus_big_int( Big_int.add_big_int i(Big_int.big_int_of_int 1))))))
  else
    (false, boolListFromNatural [] (Big_int.abs_big_int i)))


(* [bitSeqFromInteger len_opt i] encodes [i] as a bitsequence with [len_opt] bits. If there are not enough
   bits, truncation happens *)
(*val bitSeqFromInteger : maybe nat -> integer -> bitSequence*)
let bitSeqFromInteger len_opt i =  
(let (s, bl) = (boolListFromInteger i) in
  resizeBitSeq len_opt (BitSeq( None, s, bl)))


(*val integerFromBitSeq : bitSequence -> integer*)
let integerFromBitSeq bs =  
(let (BitSeq( len, s, bl)) = (cleanBitSeq bs) in
  integerFromBoolList (s, bl))


(* Now we can via translation to integers map arithmetic operations to bitSequences *)

(*val bitSeqArithUnaryOp : (integer -> integer) -> bitSequence -> bitSequence*)
let bitSeqArithUnaryOp uop bs =  
(let (BitSeq( len, _, _)) = bs in
  bitSeqFromInteger len (uop (integerFromBitSeq bs)))

(*val bitSeqArithBinOp : (integer -> integer -> integer) -> bitSequence -> bitSequence -> bitSequence*)
let bitSeqArithBinOp binop bs1 bs2 =  
(let (BitSeq( len1, _, _)) = bs1 in
  let (BitSeq( len2, _, _)) = bs2 in
  let len = ((match (len1, len2) with 
    | (Some l1, Some l2) -> Some (max l1 l2)
    | _ -> None
  )) in
  bitSeqFromInteger len (binop (integerFromBitSeq bs1) (integerFromBitSeq bs2)))

(*val bitSeqArithBinTest : forall 'a. (integer -> integer -> 'a) -> bitSequence -> bitSequence -> 'a*)
let bitSeqArithBinTest binop bs1 bs2 = (binop (integerFromBitSeq bs1) (integerFromBitSeq bs2))


(* now instantiate the number interface for bit-sequences *)

(*val bitSeqFromNumeral : numeral -> bitSequence*)

(*val bitSeqLess : bitSequence -> bitSequence -> bool*)
let bitSeqLess bs1 bs2 = (bitSeqArithBinTest Big_int.lt_big_int bs1 bs2)

(*val bitSeqLessEqual : bitSequence -> bitSequence -> bool*)
let bitSeqLessEqual bs1 bs2 = (bitSeqArithBinTest Big_int.le_big_int bs1 bs2)

(*val bitSeqGreater : bitSequence -> bitSequence -> bool*)
let bitSeqGreater bs1 bs2 = (bitSeqArithBinTest Big_int.gt_big_int bs1 bs2)

(*val bitSeqGreaterEqual : bitSequence -> bitSequence -> bool*)
let bitSeqGreaterEqual bs1 bs2 = (bitSeqArithBinTest Big_int.ge_big_int bs1 bs2)

(*val bitSeqCompare : bitSequence -> bitSequence -> ordering*)
let bitSeqCompare bs1 bs2 = (bitSeqArithBinTest Big_int.compare_big_int bs1 bs2)

let instance_Basic_classes_Ord_Word_bitSequence_dict =({

  compare_method = bitSeqCompare;

  isLess_method = bitSeqLess;

  isLessEqual_method = bitSeqLessEqual;

  isGreater_method = bitSeqGreater;

  isGreaterEqual_method = bitSeqGreaterEqual})

let instance_Basic_classes_SetType_Word_bitSequence_dict =({

  setElemCompare_method = bitSeqCompare})

(* arithmetic negation, don't mix up with bitwise negation *)
(*val bitSeqNegate : bitSequence -> bitSequence*) 
let bitSeqNegate bs = (bitSeqArithUnaryOp Big_int.minus_big_int bs)

let instance_Num_NumNegate_Word_bitSequence_dict =({

  numNegate_method = bitSeqNegate})


(*val bitSeqAdd : bitSequence -> bitSequence -> bitSequence*)
let bitSeqAdd bs1 bs2 = (bitSeqArithBinOp Big_int.add_big_int bs1 bs2)

let instance_Num_NumAdd_Word_bitSequence_dict =({

  numAdd_method = bitSeqAdd})

(*val bitSeqMinus : bitSequence -> bitSequence -> bitSequence*)
let bitSeqMinus bs1 bs2 = (bitSeqArithBinOp Big_int.sub_big_int bs1 bs2)

let instance_Num_NumMinus_Word_bitSequence_dict =({

  numMinus_method = bitSeqMinus})

(*val bitSeqSucc : bitSequence -> bitSequence*)
let bitSeqSucc bs = (bitSeqArithUnaryOp Big_int.succ_big_int bs)

let instance_Num_NumSucc_Word_bitSequence_dict =({

  succ_method = bitSeqSucc})

(*val bitSeqPred : bitSequence -> bitSequence*)
let bitSeqPred bs = (bitSeqArithUnaryOp Big_int.pred_big_int bs)

let instance_Num_NumPred_Word_bitSequence_dict =({

  pred_method = bitSeqPred})

(*val bitSeqMult : bitSequence -> bitSequence -> bitSequence*)
let bitSeqMult bs1 bs2 = (bitSeqArithBinOp Big_int.mult_big_int bs1 bs2)

let instance_Num_NumMult_Word_bitSequence_dict =({

  numMult_method = bitSeqMult})


(*val bitSeqPow : bitSequence -> nat -> bitSequence*)
let bitSeqPow bs n = (bitSeqArithUnaryOp (fun i -> Big_int.power_big_int_positive_int i n) bs)

let instance_Num_NumPow_Word_bitSequence_dict =({

  numPow_method = bitSeqPow})

(*val bitSeqDiv : bitSequence -> bitSequence -> bitSequence*)
let bitSeqDiv bs1 bs2 = (bitSeqArithBinOp Big_int.div_big_int bs1 bs2)

let instance_Num_NumIntegerDivision_Word_bitSequence_dict =({

  div_method = bitSeqDiv})

let instance_Num_NumDivision_Word_bitSequence_dict =({

  numDivision_method = bitSeqDiv})

(*val bitSeqMod : bitSequence -> bitSequence -> bitSequence*)
let bitSeqMod bs1 bs2 = (bitSeqArithBinOp Big_int.mod_big_int bs1 bs2)

let instance_Num_NumRemainder_Word_bitSequence_dict =({

  mod_method = bitSeqMod})

(*val bitSeqMin : bitSequence -> bitSequence -> bitSequence*)
let bitSeqMin bs1 bs2 = (bitSeqArithBinOp Big_int.min_big_int bs1 bs2)

(*val bitSeqMax : bitSequence -> bitSequence -> bitSequence*)
let bitSeqMax bs1 bs2 = (bitSeqArithBinOp Big_int.max_big_int bs1 bs2)

let instance_Basic_classes_OrdMaxMin_Word_bitSequence_dict =({

  max_method = bitSeqMax;

  min_method = bitSeqMin})




(* ========================================================================== *)
(* Interface for bitoperations                                                *)
(* ========================================================================== *)

type 'a wordNot_class= {
  lnot_method : 'a -> 'a
}

type 'a wordAnd_class= {
  land_method  : 'a -> 'a -> 'a
}

type 'a wordOr_class= {
  lor_method : 'a -> 'a -> 'a
}


type 'a wordXor_class= {
  lxor_method : 'a -> 'a -> 'a
}

type 'a wordLsl_class= {
  lsl_method : 'a -> int -> 'a
}

type 'a wordLsr_class= {
  lsr_method : 'a -> int -> 'a
}

type 'a wordAsr_class= {
  asr_method : 'a -> int -> 'a
}

(* ----------------------- *)
(* bitSequence             *)
(* ----------------------- *)

let instance_Word_WordNot_Word_bitSequence_dict =({

  lnot_method = bitSeqNot})

let instance_Word_WordAnd_Word_bitSequence_dict =({

  land_method = bitSeqAnd})

let instance_Word_WordOr_Word_bitSequence_dict =({

  lor_method = bitSeqOr})

let instance_Word_WordXor_Word_bitSequence_dict =({

  lxor_method = bitSeqXor})

let instance_Word_WordLsl_Word_bitSequence_dict =({

  lsl_method = bitSeqShiftLeft})

let instance_Word_WordLsr_Word_bitSequence_dict =({

  lsr_method = bitSeqLogicalShiftRight})

let instance_Word_WordAsr_Word_bitSequence_dict =({

  asr_method = bitSeqArithmeticShiftRight})


(* ----------------------- *)
(* int32                   *)
(* ----------------------- *)

(*val int32Lnot : int32 -> int32*) (* XXX: fix *)

let instance_Word_WordNot_Num_int32_dict =({

  lnot_method = Int32.lognot})


(*val int32Lor  : int32 -> int32 -> int32*) (* XXX: fix *)

let instance_Word_WordOr_Num_int32_dict =({

  lor_method = Int32.logor})

(*val int32Lxor : int32 -> int32 -> int32*) (* XXX: fix *)

let instance_Word_WordXor_Num_int32_dict =({

  lxor_method = Int32.logxor})

(*val int32Land : int32 -> int32 -> int32*) (* XXX: fix *)

let instance_Word_WordAnd_Num_int32_dict =({

  land_method = Int32.logand})

(*val int32Lsl  : int32 -> nat -> int32*) (* XXX: fix *)

let instance_Word_WordLsl_Num_int32_dict =({

  lsl_method = Int32.shift_left})

(*val int32Lsr  : int32 -> nat -> int32*) (* XXX: fix *)

let instance_Word_WordLsr_Num_int32_dict =({

  lsr_method = Int32.shift_right_logical})


(*val int32Asr  : int32 -> nat -> int32*) (* XXX: fix *)

let instance_Word_WordAsr_Num_int32_dict =({

  asr_method = Int32.shift_right})


(* ----------------------- *)
(* int64                   *)
(* ----------------------- *)

(*val int64Lnot : int64 -> int64*) (* XXX: fix *)

let instance_Word_WordNot_Num_int64_dict =({

  lnot_method = Int64.lognot})

(*val int64Lor  : int64 -> int64 -> int64*) (* XXX: fix *)

let instance_Word_WordOr_Num_int64_dict =({

  lor_method = Int64.logor})

(*val int64Lxor : int64 -> int64 -> int64*) (* XXX: fix *)

let instance_Word_WordXor_Num_int64_dict =({

  lxor_method = Int64.logxor})

(*val int64Land : int64 -> int64 -> int64*) (* XXX: fix *)

let instance_Word_WordAnd_Num_int64_dict =({

  land_method = Int64.logand})

(*val int64Lsl  : int64 -> nat -> int64*) (* XXX: fix *)

let instance_Word_WordLsl_Num_int64_dict =({

  lsl_method = Int64.shift_left})

(*val int64Lsr  : int64 -> nat -> int64*) (* XXX: fix *)

let instance_Word_WordLsr_Num_int64_dict =({

  lsr_method = Int64.shift_right_logical})

(*val int64Asr  : int64 -> nat -> int64*) (* XXX: fix *)

let instance_Word_WordAsr_Num_int64_dict =({

  asr_method = Int64.shift_right})


(* ----------------------- *)
(* Words via bit sequences *)
(* ----------------------- *)

(*val defaultLnot : forall 'a. (bitSequence -> 'a) -> ('a -> bitSequence) -> 'a -> 'a*) 
let defaultLnot fromBitSeq toBitSeq x = (fromBitSeq (bitSeqNegate (toBitSeq x)))

(*val defaultLand : forall 'a. (bitSequence -> 'a) -> ('a -> bitSequence) -> 'a -> 'a -> 'a*)
let defaultLand fromBitSeq toBitSeq x1 x2 = (fromBitSeq (bitSeqAnd (toBitSeq x1) (toBitSeq x2)))

(*val defaultLor : forall 'a. (bitSequence -> 'a) -> ('a -> bitSequence) -> 'a -> 'a -> 'a*)
let defaultLor fromBitSeq toBitSeq x1 x2 = (fromBitSeq (bitSeqOr (toBitSeq x1) (toBitSeq x2)))

(*val defaultLxor : forall 'a. (bitSequence -> 'a) -> ('a -> bitSequence) -> 'a -> 'a -> 'a*)
let defaultLxor fromBitSeq toBitSeq x1 x2 = (fromBitSeq (bitSeqXor (toBitSeq x1) (toBitSeq x2)))

(*val defaultLsl : forall 'a. (bitSequence -> 'a) -> ('a -> bitSequence) -> 'a -> nat -> 'a*)
let defaultLsl fromBitSeq toBitSeq x n = (fromBitSeq (bitSeqShiftLeft (toBitSeq x) n))

(*val defaultLsr : forall 'a. (bitSequence -> 'a) -> ('a -> bitSequence) -> 'a -> nat -> 'a*)
let defaultLsr fromBitSeq toBitSeq x n = (fromBitSeq (bitSeqLogicalShiftRight (toBitSeq x) n))

(*val defaultAsr : forall 'a. (bitSequence -> 'a) -> ('a -> bitSequence) -> 'a -> nat -> 'a*)
let defaultAsr fromBitSeq toBitSeq x n = (fromBitSeq (bitSeqArithmeticShiftRight (toBitSeq x) n))

(* ----------------------- *)
(* integer                 *)
(* ----------------------- *)

(*val integerLnot : integer -> integer*)
let integerLnot i = (Big_int.minus_big_int( Big_int.add_big_int i(Big_int.big_int_of_int 1)))

let instance_Word_WordNot_Num_integer_dict =({

  lnot_method = integerLnot})


(*val integerLor  : integer -> integer -> integer*)
(*let integerLor i1 i2 = defaultLor integerFromBitSeq (bitSeqFromInteger Nothing) i1 i2*)

let instance_Word_WordOr_Num_integer_dict =({

  lor_method = Big_int.or_big_int})

(*val integerLxor : integer -> integer -> integer*)
(*let integerLxor i1 i2 = defaultLxor integerFromBitSeq (bitSeqFromInteger Nothing) i1 i2*)

let instance_Word_WordXor_Num_integer_dict =({

  lxor_method = Big_int.xor_big_int})

(*val integerLand : integer -> integer -> integer*)
(*let integerLand i1 i2 = defaultLand integerFromBitSeq (bitSeqFromInteger Nothing) i1 i2*)

let instance_Word_WordAnd_Num_integer_dict =({

  land_method = Big_int.and_big_int})

(*val integerLsl  : integer -> nat -> integer*)
(*let integerLsl i n = defaultLsl integerFromBitSeq (bitSeqFromInteger Nothing) i n*)

let instance_Word_WordLsl_Num_integer_dict =({

  lsl_method = Big_int.shift_left_big_int})

(*val integerAsr  : integer -> nat -> integer*)
(*let integerAsr i n = defaultAsr integerFromBitSeq (bitSeqFromInteger Nothing) i n*)

let instance_Word_WordLsr_Num_integer_dict =({

  lsr_method = Big_int.shift_right_big_int})

let instance_Word_WordAsr_Num_integer_dict =({

  asr_method = Big_int.shift_right_big_int})


(* ----------------------- *)
(* int                     *)
(* ----------------------- *)

(* sometimes it is convenient to be able to perform bit-operations on ints.
   However, since int is not well-defined (it has different size on different systems),
   it should be used very carefully and only for operations that don't depend on the
   bitwidth of int *)

(*val intFromBitSeq : bitSequence -> int*)
let intFromBitSeq bs = (Big_int.int_of_big_int (integerFromBitSeq (resizeBitSeq (Some( 31)) bs)))


(*val bitSeqFromInt : int -> bitSequence*) 
let bitSeqFromInt i = (bitSeqFromInteger (Some( 31)) (Big_int.big_int_of_int i))


(*val intLnot : int -> int*)
(*let intLnot i = Instance_Num_NumNegate_Num_int.~((Instance_Num_NumAdd_Num_int.+) i 1)*)

let instance_Word_WordNot_Num_int_dict =({

  lnot_method = lnot})

(*val intLor  : int -> int -> int*)
(*let intLor i1 i2 = defaultLor intFromBitSeq bitSeqFromInt i1 i2*)

let instance_Word_WordOr_Num_int_dict =({

  lor_method = (lor)})

(*val intLxor : int -> int -> int*)
(*let intLxor i1 i2 = defaultLxor intFromBitSeq bitSeqFromInt i1 i2*)

let instance_Word_WordXor_Num_int_dict =({

  lxor_method = (lxor)})

(*val intLand : int -> int -> int*)
(*let intLand i1 i2 = defaultLand intFromBitSeq bitSeqFromInt i1 i2*)

let instance_Word_WordAnd_Num_int_dict =({

  land_method = (land)})

(*val intLsl  : int -> nat -> int*)
(*let intLsl i n = defaultLsl intFromBitSeq bitSeqFromInt i n*)

let instance_Word_WordLsl_Num_int_dict =({

  lsl_method = (lsl)})

(*val intAsr  : int -> nat -> int*)
(*let intAsr i n = defaultAsr intFromBitSeq bitSeqFromInt i n*)

let instance_Word_WordAsr_Num_int_dict =({

  asr_method = (asr)})



(* ----------------------- *)
(* natural                 *)
(* ----------------------- *)

(* some operations work also on positive numbers *)

(*val naturalFromBitSeq : bitSequence -> natural*)
let naturalFromBitSeq bs = (Big_int.abs_big_int (integerFromBitSeq bs))

(*val bitSeqFromNatural : maybe nat -> natural -> bitSequence*)
let bitSeqFromNatural len n = (bitSeqFromInteger len ( n))

(*val naturalLor  : natural -> natural -> natural*)
(*let naturalLor i1 i2 = defaultLor naturalFromBitSeq (bitSeqFromNatural Nothing) i1 i2*)

let instance_Word_WordOr_Num_natural_dict =({

  lor_method = Big_int.or_big_int})

(*val naturalLxor : natural -> natural -> natural*)
(*let naturalLxor i1 i2 = defaultLxor naturalFromBitSeq (bitSeqFromNatural Nothing) i1 i2*)

let instance_Word_WordXor_Num_natural_dict =({

  lxor_method = Big_int.xor_big_int})

(*val naturalLand : natural -> natural -> natural*)
(*let naturalLand i1 i2 = defaultLand naturalFromBitSeq (bitSeqFromNatural Nothing) i1 i2*)

let instance_Word_WordAnd_Num_natural_dict =({

  land_method = Big_int.and_big_int})

(*val naturalLsl  : natural -> nat -> natural*)
(*let naturalLsl i n = defaultLsl naturalFromBitSeq (bitSeqFromNatural Nothing) i n*)

let instance_Word_WordLsl_Num_natural_dict =({

  lsl_method = Big_int.shift_left_big_int})

(*val naturalAsr  : natural -> nat -> natural*)
(*let naturalAsr i n = defaultAsr naturalFromBitSeq (bitSeqFromNatural Nothing) i n*)

let instance_Word_WordLsr_Num_natural_dict =({

  lsr_method = Big_int.shift_right_big_int})

let instance_Word_WordAsr_Num_natural_dict =({

  asr_method = Big_int.shift_right_big_int})


(* ----------------------- *)
(* nat                     *)
(* ----------------------- *)

(* sometimes it is convenient to be able to perform bit-operations on nats.
   However, since nat is not well-defined (it has different size on different systems),
   it should be used very carefully and only for operations that don't depend on the
   bitwidth of nat *)

(*val natFromBitSeq : bitSequence -> nat*)
let natFromBitSeq bs = (Big_int.int_of_big_int (naturalFromBitSeq (resizeBitSeq (Some( 31)) bs)))


(*val bitSeqFromNat : nat -> bitSequence*) 
let bitSeqFromNat i = (bitSeqFromNatural (Some( 31)) (Big_int.big_int_of_int i))


(*val natLor  : nat -> nat -> nat*)
(*let natLor i1 i2 = defaultLor natFromBitSeq bitSeqFromNat i1 i2*)

let instance_Word_WordOr_nat_dict =({

  lor_method = (lor)})

(*val natLxor : nat -> nat -> nat*)
(*let natLxor i1 i2 = defaultLxor natFromBitSeq bitSeqFromNat i1 i2*)

let instance_Word_WordXor_nat_dict =({

  lxor_method = (lxor)})

(*val natLand : nat -> nat -> nat*)
(*let natLand i1 i2 = defaultLand natFromBitSeq bitSeqFromNat i1 i2*)

let instance_Word_WordAnd_nat_dict =({

  land_method = (land)})

(*val natLsl  : nat -> nat -> nat*)
(*let natLsl i n = defaultLsl natFromBitSeq bitSeqFromNat i n*)

let instance_Word_WordLsl_nat_dict =({

  lsl_method = (lsl)})

(*val natAsr  : nat -> nat -> nat*)
(*let natAsr i n = defaultAsr natFromBitSeq bitSeqFromNat i n*)

let instance_Word_WordAsr_nat_dict =({

  asr_method = (asr)})

