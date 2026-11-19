# Week 7: Bash Scripting I (Variables, Conditions, Loops)

## Goals
- Write, run and debug Bash scripts
- Use variables, quoting, command substitution, arithmetic
- Use `if`, `case`, `for`, `while`, and test expressions

---

## Day 1: Your first script

```bash
#!/usr/bin/env bash
# hello.sh: my first script
echo "Hello, $USER! Today is $(date +%A)."
```
```bash
chmod +x hello.sh
./hello.sh
bash -x hello.sh     # debug: print each command as it runs
```
The first line (**shebang**) tells the kernel which interpreter to use.

## Day 2: Variables and quoting
```bash
name="Linux"                 # NO spaces around =
echo "Hello $name"           # double quotes: variables expand
echo 'Hello $name'           # single quotes: literal
echo "Files: $(ls | wc -l)"  # command substitution
echo "${name}_rocks"         # braces to delimit names

readonly PI=3.14
unset name

# Defaults
echo "${1:-default}"         # use "default" if $1 is empty
echo "${#name}"              # string length
file="report.tar.gz"
echo "${file%.gz}"           # strip suffix → report.tar
echo "${file##*.}"           # extension → gz
echo "${file/report/data}"   # replace → data.tar.gz
```
> **Always quote your variables**: `"$file"`, not `$file`. Unquoted variables break on spaces and globs.

## Day 3: Input, arguments and arithmetic
```bash
read -p "Your name: " name
read -s -p "Password: " pw; echo

echo "Script: $0"
echo "First arg: $1, second: $2"
echo "All args: $@"     # use "$@" in loops
echo "Arg count: $#"

a=7; b=3
echo $(( a + b ))   $(( a * b ))   $(( a % b ))   $(( a ** 2 ))
(( a++ ))
echo "scale=2; 10/3" | bc    # floating point
```

## Day 4: Conditions
```bash
if [[ -f "$file" ]]; then
    echo "file exists"
elif [[ -d "$file" ]]; then
    echo "it's a directory"
else
    echo "not found"
fi
```

| Test | True when |
|---|---|
| `-f f` / `-d d` / `-e p` | is file / is dir / exists |
| `-r` `-w` `-x` | readable / writable / executable |
| `-s f` | file not empty |
| `-z "$s"` / `-n "$s"` | string empty / not empty |
| `"$a" == "$b"` / `!=` | string equal / not |
| `$a -eq $b`  `-ne -lt -le -gt -ge` | numeric compare |
| `"$s" =~ ^[0-9]+$` | regex match (`[[ ]]` only) |
| `&&` `\|\|` `!` | and / or / not |

Short-circuit style:
```bash
[[ -d logs ]] || mkdir logs
command -v git >/dev/null && echo "git installed"
```

`case` for multiple choices:
```bash
case "$1" in
    start)   echo "Starting..." ;;
    stop)    echo "Stopping..." ;;
    restart) echo "Restarting..." ;;
    *)       echo "Usage: $0 {start|stop|restart}"; exit 1 ;;
esac
```

## Day 5: Loops
```bash
for i in 1 2 3; do echo "$i"; done
for i in {1..10}; do echo "$i"; done
for (( i=0; i<5; i++ )); do echo "$i"; done
for f in *.txt; do echo "Processing $f"; done
for user in $(cut -d: -f1 /etc/passwd); do echo "$user"; done

count=0
while (( count < 5 )); do
    echo "$count"; (( count++ ))
done

# Read a file line by line (the correct way)
while IFS= read -r line; do
    echo "Line: $line"
done < input.txt

until ping -c1 -W1 8.8.8.8 &>/dev/null; do sleep 2; done; echo "online"

# break / continue work as usual
```

## Day 6: Arrays
```bash
fruits=("apple" "banana" "cherry")
echo "${fruits[0]}"
echo "${fruits[@]}"       # all
echo "${#fruits[@]}"      # length
fruits+=("date")
for f in "${fruits[@]}"; do echo "$f"; done

declare -A ages           # associative array (dictionary)
ages[alice]=30; ages[bob]=25
for k in "${!ages[@]}"; do echo "$k is ${ages[$k]}"; done
```

## Day 7: ShellCheck
Install `shellcheck` and run it on every script you write: `shellcheck myscript.sh`. It catches 90% of bash bugs.

---

## Exercises
1. `greet.sh NAME`: prints a greeting; prints usage and exits 1 if no name is given.
2. `evenodd.sh N`: prints whether N is even or odd; rejects non-numbers using a regex.
3. `countdown.sh N`: counts down from N to 0, one per second.
4. `filetype.sh PATH`: says whether PATH is a file, directory, symlink, or doesn't exist.
5. `sumargs.sh 1 2 3 ...`: prints the sum of all arguments.
6. `rename-ext.sh txt md`: renames every `*.txt` in the current dir to `*.md`.

## Mini-project: Downloads organizer (automated)
Write `organize.sh DIR` that moves files into subfolders by extension:
images (jpg, png, gif), docs (pdf, docx, txt, md), archives (zip, tar, gz), other.
It must handle filenames with spaces and print a summary of how many files moved where.
A reference solution is in [../Projects/organize.sh](../Projects/organize.sh). Try it yourself first!

## Checkpoint
- [ ] Why `"$var"` instead of `$var`?
- [ ] Difference between `$@` and `$*` (when quoted)
- [ ] `[ ]` vs `[[ ]]` vs `(( ))`
- [ ] Read a file line by line safely
- [ ] Your scripts pass `shellcheck` with no warnings
