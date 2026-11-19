# Bash Scripting Cheatsheet

```bash
#!/usr/bin/env bash
set -euo pipefail
```

## Variables
```bash
name="x"            # no spaces around =
"$name" "${name}"   # always quote
$(cmd)              # command substitution
$((a + b))          # arithmetic
${var:-default}     # default if unset/empty
${var:=default}     # assign default
${var:?error msg}   # fail if unset
${#var}             # length
${var#prefix} ${var##*/}   # strip shortest/longest prefix (basename)
${var%suffix} ${var%/*}    # strip shortest/longest suffix (dirname)
${var/old/new} ${var//old/new}   # replace first / all
${var^^} ${var,,}   # upper / lower case
```

## Special variables
| Var | Meaning |
|---|---|
| `$0` | script name |
| `$1..$9`, `${10}` | positional args |
| `$#` | number of args |
| `"$@"` | all args, each quoted separately (use this) |
| `$?` | last exit code |
| `$$` | current PID |
| `$!` | last background PID |
| `$EUID` | effective user id (0 = root) |
| `$LINENO` | current line |

## Tests
```bash
[[ -f f ]] [[ -d d ]] [[ -e p ]] [[ -x f ]] [[ -s f ]]
[[ -z $s ]] [[ -n $s ]] [[ $a == "$b" ]] [[ $s =~ ^[0-9]+$ ]]
(( a > b )) (( a == b ))
[[ cond1 && cond2 ]] [[ cond1 || cond2 ]] [[ ! cond ]]
```

## Control flow
```bash
if [[ ... ]]; then ...; elif [[ ... ]]; then ...; else ...; fi
case "$x" in a|b) ... ;; c*) ... ;; *) ... ;; esac
for i in {1..5}; do ...; done
for (( i=0; i<n; i++ )); do ...; done
for f in *.txt; do ...; done
while IFS= read -r line; do ...; done < file
until cond; do ...; done
```

## Functions
```bash
fn() { local x="$1"; echo "$x"; return 0; }
out=$(fn arg)
```

## Arrays
```bash
a=(one two three); a+=(four)
"${a[0]}" "${a[@]}" "${#a[@]}" "${!a[@]}"
declare -A m=([k1]=v1 [k2]=v2); "${m[k1]}" "${!m[@]}"
```

## I/O
```bash
cmd > f    cmd >> f    cmd 2> f    cmd &> f    cmd 2>&1 | tee f
cmd < f    cmd <<< "string"
cat <<'EOF'      # quoted EOF = no variable expansion
literal $text
EOF
echo "msg" >&2   # print to stderr
read -rp "Prompt: " var
printf "%-10s|%5.2f\n" "$name" "$num"
```

## Robustness
```bash
trap 'rm -rf "$tmp"' EXIT
tmp=$(mktemp -d)
command -v jq >/dev/null || { echo "need jq" >&2; exit 1; }
cmd || true             # allow failure under set -e
getopts ":ab:c" opt     # see Week 8
shellcheck script.sh    # lint every script
bash -x script.sh       # trace execution
```
