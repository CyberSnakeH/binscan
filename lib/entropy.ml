let global bytes =
  let n = Bytes.length bytes in
  if n = 0 then 0.0
  else
    let freq = Array.make 256 0 in
    for i = 0 to n - 1 do
      let v = Char.code (Bytes.get bytes i) in
      freq.(v) <- freq.(v) + 1
    done;
    let n_f = float_of_int n in
    let log2 = log 2.0 in
    let entropy = ref 0.0 in
    for i = 0 to 255 do
      let c = freq.(i) in
      if c <> 0 then (
        let p = float_of_int c /. n_f in
        entropy := !entropy -. (p *. (log p /. log2))
      )
    done;
    !entropy

let sliding ~window ~stride bytes =
  let n = Bytes.length bytes in
  if window <= 0 || stride <= 0 || n < window then []
  else
    let rec loop off acc =
      if off + window > n then List.rev acc
      else
        let chunk = Bytes.sub bytes off window in
        let e = global chunk in
        loop (off + stride) ((off, e) :: acc)
    in
    loop 0 []

let compare_windows (_, ea) (_, eb) = compare eb ea

let rec take n xs =
  if n <= 0 then []
  else
    match xs with
    | [] -> []
    | x :: xs' -> x :: take (n - 1) xs'

let top_windows ~k windows =
  if k <= 0 then []
  else windows |> List.sort compare_windows |> take k
