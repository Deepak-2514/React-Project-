# grep Deep Dive

`grep` = **g**lobal **r**egular **e**xpression **p**rint. It searches text for patterns. Used in week 4, and every day after.

Practice file: [practice.txt](practice.txt). Run every example below against it.

## Syntax
```bash
grep [options] PATTERN [FILE...]
command | grep PATTERN
```

## Essential options
| Option | Meaning | Example |
|---|---|---|
| `-i` | ignore case | `grep -i error practice.txt` |
| `-v` | invert (non-matching lines) | `grep -v '^#' practice.txt` |
| `-n` | show line numbers | `grep -n WARN practice.txt` |
| `-c` | count matching lines | `grep -c ERROR practice.txt` |
| `-w` | whole word only | `grep -w log practice.txt` |
| `-x` | whole line must match | `grep -x 'END' practice.txt` |
| `-o` | print only the match | `grep -o '[0-9]\{3\}-[0-9]\{4\}' practice.txt` |
| `-l` / `-L` | files that do / don't match | `grep -l TODO *.sh` |
| `-r` / `-R` | recursive (R follows symlinks) | `grep -rn TODO ~/projects` |
| `-A n` `-B n` `-C n` | lines After / Before / Context | `grep -C 1 ERROR practice.txt` |
| `-E` | extended regex (`+ ? \| () {}`) | `grep -E 'ERROR\|WARN' practice.txt` |
| `-F` | fixed string (no regex) | `grep -F 'a.b*c' file` |
| `-P` | Perl regex (`\d`, lookahead) | `grep -P '\d{3}' practice.txt` |
| `-q` | quiet: just exit code | `grep -q root /etc/passwd && echo yes` |
| `-s` | suppress file errors | `grep -rs pattern /etc` |
| `-e` | multiple patterns | `grep -e ERROR -e FATAL file` |
| `-f file` | patterns from a file | `grep -f badips.txt access.log` |
| `--include` / `--exclude` / `--exclude-dir` | filter recursive search | `grep -r --include='*.js' --exclude-dir=node_modules fetch .` |
| `--color=auto` | highlight matches | usually on by default |

## Regex in grep
```bash
grep '^ERROR' practice.txt           # lines starting with ERROR
grep 'done$' practice.txt            # ending with "done"
grep '^$' practice.txt               # empty lines   (count: grep -c '^$')
grep 'c.t' practice.txt              # cat, cut, c9t ...
grep -E 'colou?r' practice.txt       # color or colour
grep -E '[0-9]{3}-[0-9]{3}-[0-9]{4}' practice.txt   # phone numbers
grep -Eo '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-z]{2,}' practice.txt   # emails
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' practice.txt # IPv4 addresses
grep -E '\b(ERROR|FATAL)\b' practice.txt
```

## Real-world one-liners
```bash
grep -rn "TODO\|FIXME" --include='*.{js,ts,py}' .          # find TODOs in code
grep -v '^\s*#' /etc/ssh/sshd_config | grep -v '^$'         # config without comments/blank lines
grep "Failed password" /var/log/auth.log | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | sort -nr
ps aux | grep '[n]ginx'                                     # the [n] trick hides grep itself
history | grep -i docker
grep -c processor /proc/cpuinfo                             # number of CPUs
```

## Related tools
- `egrep` = `grep -E`, `fgrep` = `grep -F` (deprecated aliases)
- `zgrep` searches `.gz` files: `zgrep ERROR /var/log/syslog.2.gz`
- `ripgrep` (`rg`) is a much faster recursive grep that respects `.gitignore`: `rg TODO`

## Exercises (use practice.txt)
1. Count lines containing `ERROR` (case-insensitive).
2. Print all email addresses, one per line, unique.
3. Print all IP addresses and how many times each appears.
4. Show every line that is NOT a comment and NOT blank.
5. Show each `FATAL` line with 2 lines of context before it.
6. Find lines containing a phone number in the format `555-123-4567`.
7. Print line numbers of lines that contain the whole word `log` (not `login`, `logs`).
