val global : bytes -> float
val sliding : window:int -> stride:int -> bytes -> (int * float) list
val top_windows : k:int -> (int * float) list -> (int * float) list
