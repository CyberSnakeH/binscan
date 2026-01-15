# binscan

[![ci](https://github.com/CyberSnakeH/binscan/actions/workflows/ci.yml/badge.svg)](https://github.com/CyberSnakeH/binscan/actions/workflows/ci.yml)

Small OCaml utility to scan binary files and produce a reverse-ready report.

Features:
- Extracts readable ASCII strings (scored and ranked).
- Computes global Shannon entropy.
- Optional sliding-window entropy scan.

## Build

```sh
opam switch create . ocaml-system
# or: opam switch create . 5.4.0

eval $(opam env)
dune build
```

## Usage

```sh
dune exec binscan -- [options] <file>
```

Examples:

```sh
dune exec binscan -- ./sample --min-len 8 --top 30
```

```sh
dune exec binscan -- ./sample --entropy --window 4096 --stride 1024
```

Options:
- `--min-len`  Minimum printable string length (default: 6)
- `--top`      Number of top strings to show (default: 20)
- `--entropy`  Enable entropy output (default)
- `--no-entropy` Disable entropy output
- `--window`   Sliding window size for entropy (bytes)
- `--stride`   Stride for sliding entropy window (bytes)

## Output (example)

```
file: ./sample (2.3 MB)
strings (top 15, min_len 8):
  0x0001a000 https://api.example.com/v1/login
  0x0001a120 /etc/ssl/certs/ca-certificates.crt
  0x0001a1f0 user-agent: sample/1.2.0
entropy:
  global: 6.45
  high-entropy windows:
    0x00190000 7.92
    0x00194000 7.88
```

## License

MIT
