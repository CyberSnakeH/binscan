type string_hit = {
  s : string;
  off : int;
  len : int;
  score : int;
}

type entropy_stats = {
  global : float;
  windows : (int * float) list;
}

type config = {
  min_len : int;
  top : int;
  window : int option;
  stride : int;
  entropy : bool;
  file : string;
}

type results = {
  strings : string_hit list;
  entropy : entropy_stats;
  size : int;
}
