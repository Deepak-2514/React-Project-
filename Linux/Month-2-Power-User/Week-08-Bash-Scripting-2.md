# Week 8: Bash Scripting II (Functions, Arguments, Robust Scripts)

## Goals
- Write reusable functions with return values
- Parse flags with `getopts`
- Write *safe* scripts: strict mode, error handling, traps, logging, temp files

---

## Day 1: Functions
```bash
greet() {
    local name="$1"          # local = don't leak into global scope
    echo "Hello, $name"
}
greet "World"

# "Return" data by echoing; return codes are for success/failure (0–255)
is_root() { [[ $EUID -eq 0 ]]; }
if is_root; then echo "root"; fi

add() { echo $(( $1 + $2 )); }
result=$(add 2 3)
```

## Day 2: Exit codes and strict mode
```bash
#!/usr/bin/env bash
set -euo pipefail
# -e          exit on any error
# -u          error on unset variables
# -o pipefail a pipeline fails if ANY command in it fails
IFS=$'\n\t'   # safer word splitting

exit 0        # success
exit 1        # general error
```
Handle expected failures explicitly:
```bash
if ! grep -q "pattern" file; then echo "not found"; fi
value=$(some_cmd) || { echo "some_cmd failed" >&2; exit 1; }
```

## Day 3: Traps and cleanup
```bash
tmpdir=$(mktemp -d)
cleanup() { rm -rf "$tmpdir"; echo "cleaned up"; }
trap cleanup EXIT              # runs on any exit
trap 'echo "Interrupted"; exit 130' INT
trap 'echo "Error on line $LINENO" >&2' ERR
```

## Day 4: Parsing options with getopts
```bash
usage() { echo "Usage: $0 [-v] [-o output] -n name" >&2; exit 1; }

verbose=false; output="out.txt"; name=""
while getopts ":vo:n:h" opt; do
    case "$opt" in
        v) verbose=true ;;
        o) output="$OPTARG" ;;
        n) name="$OPTARG" ;;
        h) usage ;;
        :) echo "Option -$OPTARG needs a value" >&2; usage ;;
        \?) echo "Unknown option -$OPTARG" >&2; usage ;;
    esac
done
shift $((OPTIND - 1))           # remaining positional args in "$@"
[[ -z "$name" ]] && usage
```

## Day 5: Logging, colors and output
```bash
RED='\e[31m'; GREEN='\e[32m'; YELLOW='\e[33m'; NC='\e[0m'
log()  { echo -e "$(date '+%F %T') [INFO]  $*"; }
warn() { echo -e "${YELLOW}$(date '+%F %T') [WARN]  $*${NC}" >&2; }
die()  { echo -e "${RED}$(date '+%F %T') [ERROR] $*${NC}" >&2; exit 1; }

printf "%-10s %5d\n" "files" 42   # formatted output
```
Log to a file and the screen at once: `exec > >(tee -a script.log) 2>&1`

## Day 6: Useful patterns
```bash
# Require a command
require() { command -v "$1" >/dev/null || die "$1 is required"; }
require curl; require jq

# Require root
[[ $EUID -eq 0 ]] || die "Run as root"

# Confirm
read -rp "Continue? [y/N] " ans
[[ "$ans" =~ ^[Yy]$ ]] || exit 0

# Script's own directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source a library of functions
source "$SCRIPT_DIR/lib.sh"

# Process files safely (handles spaces, newlines)
find . -name "*.log" -print0 | while IFS= read -r -d '' f; do echo "$f"; done

# Parallel jobs
for host in web1 web2 web3; do ping -c1 "$host" & done; wait
```

## Day 7: Template
Copy [../Practice/script-template.sh](../Practice/script-template.sh) as the starting point for every new script.

---

## Exercises
1. Write `lib.sh` with `log`, `warn`, `die`, `require`; source it from another script.
2. `backup.sh -s SRC -d DEST [-k N]`: tar+gzip SRC into DEST with a timestamped name, and keep only the newest N backups.
3. `sysinfo.sh`: prints hostname, OS, kernel, uptime, CPU count, memory used/total, disk usage of `/`, and top 3 processes, nicely formatted.
4. Make a script that creates a temp dir, does work in it, and **always** deletes it, even on Ctrl+C.
5. `checkurls.sh urls.txt`: checks each URL with `curl -s -o /dev/null -w "%{http_code}"` in parallel and prints a table.

## Mini-project: `backup.sh`
A production-quality backup script with: strict mode, getopts flags, logging to file, rotation, a dry-run flag (`-n`),
error handling, and a `--help`. Reference: [../Projects/backup.sh](../Projects/backup.sh).

## Month 2 checkpoint
- [ ] Write a function that returns a value and one that returns a status
- [ ] Explain each part of `set -euo pipefail`
- [ ] Use `trap` to clean up temp files
- [ ] Parse `-v -o file` style flags with `getopts`
- [ ] Bandit up to level 20
