let read_all path =
  let ic = open_in_bin path in
  Fun.protect
    ~finally:(fun () -> close_in_noerr ic)
    (fun () ->
      let len = in_channel_length ic in
      let buf = Bytes.create len in
      really_input ic buf 0 len;
      buf)
