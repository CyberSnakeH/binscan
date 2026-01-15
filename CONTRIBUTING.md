# Contributing

Thanks for considering a contribution to binscan.

## Development setup

```sh
opam switch create . ocaml-system

eval $(opam env)
dune build
dune runtest
```

## Coding guidelines

- Keep changes focused and small.
- Prefer readable, testable functions.
- Add tests for new behavior.

## Submitting changes

1. Fork the repository.
2. Create a feature branch.
3. Run `dune build` and `dune runtest`.
4. Open a pull request with a clear description.
