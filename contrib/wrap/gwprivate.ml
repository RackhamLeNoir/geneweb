(* $Id: gwprivate.ml,v 1.00 2013-09-10 10:30:22 flh Exp $ *)
(* wrapper *)


value is_base_converted bname =
  let fname = Filename.concat bname "converted" in
  Sys.file_exists fname
(*
  let fname = "mon/nom/de/fichier" in
  match try Some (open_in fname) with [ Sys_error _ -> None ] with
  [ Some ic ->
      loop () where rec loop () =
        match try Some (input_line ic) with [ End_of_file -> None ] with
        [ Some line -> 
            if line = bname then do { close_in ic; True } else loop ()
        | None -> do { close_in ic; False } ]
  | None -> False ]
*)
;

value gwprivate_moins = Filename.concat (Filename.dirname Sys.argv.(0)) "../../gw_moins/gw/gwprivate";
value gwprivate_plus = Filename.concat (Filename.dirname Sys.argv.(0)) "../../gw_plus/gw/gwprivate";


(**/**) 


value list_ind = ref "";
value ind = ref "";
value bname = ref "";
value everybody = ref False;

value speclist =
  [("-everybody", Arg.Set everybody, "set flag private to everybody [option
  lente!]");
   ("-ind", Arg.String (fun x -> ind.val := x),
    "individual key");
   ("-list-ind", Arg.String (fun s -> list_ind.val := s), "<file> file to the list of persons")]
;
value anonfun i = bname.val := i;
value usage = "Usage: private [-everybody] [-ind key] base";

value main () = do {
  Arg.parse speclist anonfun usage;
  let bname = bname.val in
  let bname =
    if Filename.check_suffix bname ".gwb" then bname
    else bname ^ ".gwb"
  in
  if is_base_converted bname then 
    let () = Sys.argv.(0) := gwprivate_plus in 
    let pid = Unix.create_process Sys.argv.(0) Sys.argv Unix.stdin Unix.stdout Unix.stderr in
    let (_, _) = Unix.waitpid [] pid in
    ()
  else 
    let () = Sys.argv.(0) := gwprivate_moins in 
    let pid = Unix.create_process Sys.argv.(0) Sys.argv Unix.stdin Unix.stdout Unix.stderr in
    let (_, _) = Unix.waitpid [] pid in
    ()
};

main ();