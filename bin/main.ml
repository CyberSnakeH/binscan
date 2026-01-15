open Binscan
open Types

let () =
  let min_len = ref 6 in
  let top = ref 20 in
  let entropy = ref true in
  let window = ref 0 in
  let stride = ref 0 in
  let file = ref "" in
  let set_file s = file := s in
  let usage = "binscan [options] <file>" in
  let specs =
    [
      ("--min-len", Arg.Set_int min_len, "Minimum printable string length");
      ("--top", Arg.Set_int top, "Number of top strings to show");
      ("--entropy", Arg.Set entropy, "Enable entropy output (default)");
      ("--no-entropy", Arg.Clear entropy, "Disable entropy output");
      ("--window", Arg.Set_int window, "Sliding window size for entropy");
      ("--stride", Arg.Set_int stride, "Stride for sliding entropy window");
    ]
  in
  Arg.parse specs set_file usage;
  if !file = "" then (
    Arg.usage specs usage;
    exit 2
  );
  let cfg =
    {
      min_len = !min_len;
      top = !top;
      window = if !window > 0 then Some !window else None;
      stride = !stride;
      entropy = !entropy;
      file = !file;
    }
  in
  let data = Io.read_all cfg.file in
  let hits =
    Strings.extract ~min_len:cfg.min_len data |> Strings.top ~top:cfg.top
  in
  let entropy_stats =
    if cfg.entropy then
      let global = Entropy.global data in
      let windows =
        match cfg.window with
        | None -> []
        | Some w ->
            let stride = if cfg.stride > 0 then cfg.stride else w in
            let wins = Entropy.sliding ~window:w ~stride data in
            Entropy.top_windows ~k:5 wins
      in
      { global; windows }
    else { global = 0.0; windows = [] }
  in
  let results =
    { strings = hits; entropy = entropy_stats; size = Bytes.length data }
  in
  Report.pp_text cfg results
