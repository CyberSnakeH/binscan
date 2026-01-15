(lang dune 3.20)

(name binscan)

(generate_opam_files true)

(source
 (github CyberSnakeH/binscan))

(authors "CyberSnake")

(maintainers "CyberSnake")

(license "MIT")

(homepage "https://github.com/CyberSnakeH/binscan")

(documentation "https://github.com/CyberSnakeH/binscan#readme")

(bug_reports "https://github.com/CyberSnakeH/binscan/issues")

(package
 (name binscan)
 (synopsis "Fast binary scanner")
 (description "Extracts readable strings and entropy from binary files.")
 (depends ocaml)
 (tags ("reverse-engineering" "security" "forensics")))
