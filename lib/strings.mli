val extract : min_len:int -> bytes -> Types.string_hit list
val score : string -> int
val top : top:int -> Types.string_hit list -> Types.string_hit list
