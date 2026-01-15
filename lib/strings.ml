open Types

let is_printable_ascii c =
  let code = Char.code c in
  code >= 0x20 && code <= 0x7e

let starts_with s prefix =
  let len_s = String.length s in
  let len_p = String.length prefix in
  len_s >= len_p && String.sub s 0 len_p = prefix

let contains_sub s sub =
  let len_s = String.length s in
  let len_sub = String.length sub in
  if len_sub = 0 then true
  else
    let rec loop i =
      if i + len_sub > len_s then false
      else if String.sub s i len_sub = sub then true
      else loop (i + 1)
    in
    loop 0

let score s =
  let lower = String.lowercase_ascii s in
  let score = ref 0 in
  let add cond pts = if cond then score := !score + pts in
  add (starts_with lower "http://") 100;
  add (starts_with lower "https://") 100;
  add (starts_with s "/") 60;
  add (contains_sub lower "/etc/") 40;
  add (contains_sub lower "/proc/") 40;
  add (contains_sub lower "/usr/") 40;
  add (contains_sub lower "glibc_") 35;
  add (contains_sub lower ".so") 25;
  add (contains_sub lower "error") 20;
  add (contains_sub lower "usage") 15;
  add (contains_sub s "%s") 10;
  add (contains_sub s "%d") 10;
  add (contains_sub lower "user-agent") 25;
  add (contains_sub lower "token") 20;
  add (contains_sub lower "http") 15;
  !score

let extract ~min_len data =
  let n = Bytes.length data in
  let push acc start stop =
    let len = stop - start in
    if len >= min_len then
      let s = Bytes.sub_string data start len in
      let sc = score s in
      { s; off = start; len; score = sc } :: acc
    else acc
  in
  let rec loop i start acc =
    if i >= n then
      let acc = if start >= 0 then push acc start n else acc in
      List.rev acc
    else
      let c = Bytes.get data i in
      if is_printable_ascii c then
        let start = if start < 0 then i else start in
        loop (i + 1) start acc
      else
        let acc = if start >= 0 then push acc start i else acc in
        loop (i + 1) (-1) acc
  in
  loop 0 (-1) []

let compare_hits a b =
  let c = Int.compare b.score a.score in
  if c <> 0 then c else Int.compare b.len a.len

let rec take n xs =
  if n <= 0 then []
  else
    match xs with
    | [] -> []
    | x :: xs' -> x :: take (n - 1) xs'

let top ~top hits =
  if top <= 0 then []
  else hits |> List.sort compare_hits |> take top
