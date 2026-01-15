open Types

let pp_text cfg results =
  Printf.printf "file: %s (%d bytes)\n" cfg.file results.size;
  Printf.printf "strings (top %d, min_len %d):\n" cfg.top cfg.min_len;
  if results.strings = [] then
    Printf.printf "  (none)\n"
  else
    List.iter
      (fun h -> Printf.printf "  0x%08x %s\n" h.off h.s)
      results.strings;
  if cfg.entropy then (
    Printf.printf "entropy:\n";
    Printf.printf "  global: %.4f\n" results.entropy.global;
    match results.entropy.windows with
    | [] -> ()
    | wins ->
        Printf.printf "  high-entropy windows:\n";
        List.iter
          (fun (off, e) -> Printf.printf "    0x%08x %.4f\n" off e)
          wins
  )
