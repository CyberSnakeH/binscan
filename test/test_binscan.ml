open Binscan
open Types

let assert_true msg cond = if not cond then failwith msg

let test_strings () =
  let data = Bytes.of_string "AAAA\x00http://example.com\x00/var/log\x00" in
  let hits = Strings.extract ~min_len:4 data in
  assert_true "expected URL string" (List.exists (fun h -> h.s = "http://example.com") hits);
  assert_true "expected path string" (List.exists (fun h -> h.s = "/var/log") hits);
  let top1 = Strings.top ~top:1 hits in
  match top1 with
  | [h] ->
      assert_true "top should be URL" (h.s = "http://example.com")
  | _ -> failwith "expected exactly one top hit"

let test_entropy () =
  let zeros = Bytes.make 128 '\x00' in
  let e0 = Entropy.global zeros in
  assert_true "entropy for zeros should be ~0" (Float.abs (e0 -. 0.0) < 1e-6);
  let uniform = Bytes.init 256 (fun i -> Char.chr i) in
  let e1 = Entropy.global uniform in
  assert_true "entropy for uniform bytes should be ~8" (e1 > 7.9 && e1 < 8.1);
  let wins = Entropy.sliding ~window:16 ~stride:16 uniform in
  assert_true "expected 16 windows" (List.length wins = 16)

let () =
  test_strings ();
  test_entropy ();
  print_endline "tests ok"
