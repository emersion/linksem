(*Generated by Lem from main.lem.*)
open Lem_function
open Lem_string
open Lem_tuple

open Bitstring_local
open Error
open Missing_pervasives
open Show

open Elf_header
open Elf_file1
open Elf_executable_file2
open Elf_executable_file3
open Elf_executable_file4
open Elf_executable_file5

open Sail_interface

let default_os _ =
  "*Default OS specific print*"

let default_proc _ =
  "*Default processor specific print*"

let default_user _ =
  "*Default user specific print*"

let default_hdr_bdl =
  (default_os, default_proc)

let default_pht_bdl =
  (default_os, default_proc)

let default_sht_bdl =
  (default_os, default_proc, default_user)

let _ =  
(let (chunks_addr, entry) = (Sail_interface.populate "test/power64-executable-1") in
  let _ = (print_endline ("Entry point: " ^ string_of_int entry)) in
  let _ = (print_endline ("#Chunks: " ^ string_of_int (List.length chunks_addr))) in
    ())