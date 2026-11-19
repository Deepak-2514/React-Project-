# Week 4: Text Processing, Pipes and Redirection

This is the week where Linux becomes powerful. Most of Linux is text, and these tools let you slice it.

## Goals
- Master redirection (`>`, `>>`, `2>`, `|`)
- Use `grep`, `sort`, `uniq`, `wc`, `cut`, `tr`, `sed`, `awk`
- Build one-liners that answer real questions about logs and data

---

## Day-by-day

### Day 1: Streams and redirection
Every program has 3 streams: **stdin (0)**, **stdout (1)**, **stderr (2)**.

```bash
ls > files.txt          # stdout to file (overwrite)
ls >> files.txt         # append
ls /nope 2> errors.txt  # stderr to file
cmd > out.txt 2>&1      # both to same file (or: cmd &> out.txt)
cmd 2>/dev/null         # throw errors away
wc -l < files.txt       # file as stdin
cat <<EOF > config.txt  # here-document
name=demo
port=8080
EOF
```

### Day 2: Pipes
`|` sends the stdout of one command to the stdin of the next.
```bash
ls -l /etc | less
cat /etc/passwd | wc -l
history | grep ssh
ps aux | sort -k3 -nr | head -5     # top 5 CPU users
ls | tee list.txt | wc -l           # tee = save AND pass along
```

### Day 3: grep (see the deep dive in [../Grep/README.md](../Grep/README.md))
```bash
grep "error" app.log
grep -i "error" app.log       # case-insensitive
grep -r "TODO" ./src          # recursive
grep -n -C 2 "fail" app.log   # line numbers + 2 lines context
grep -v "^#" config.conf      # invert: hide comments
grep -c "200" access.log      # count matches
grep -E "warn|error" app.log  # extended regex (OR)
grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" access.log  # only the match (IPs)
```

### Day 4: sort, uniq, wc, cut, tr
```bash
sort names.txt               # alphabetical
sort -n numbers.txt          # numeric
sort -rh sizes.txt           # reverse, human sizes (1K, 2M)
sort -t: -k3 -n /etc/passwd  # by 3rd field, ':' separated
uniq                         # removes ADJACENT duplicates, so sort first
sort file | uniq -c | sort -nr   # frequency count (classic!)
wc -l -w -c file             # lines, words, bytes
cut -d: -f1 /etc/passwd      # 1st field with ':' delimiter
cut -c1-10 file              # characters 1–10
tr 'a-z' 'A-Z' < file        # translate chars
tr -d '\r' < win.txt > unix.txt  # strip Windows line endings
```

### Day 5: sed (stream editor)
```bash
sed 's/foo/bar/' file         # replace first per line
sed 's/foo/bar/g' file        # replace all
sed -i 's/8080/9090/g' cfg    # edit file in place (-i.bak to keep backup)
sed -n '10,20p' file          # print lines 10–20
sed '/^$/d' file              # delete empty lines
sed '/^#/d' file              # delete comment lines
```

### Day 6: awk (column-oriented processing)
```bash
awk '{print $1}' access.log                 # first column
awk -F: '{print $1, $7}' /etc/passwd        # user and shell
awk '$3 >= 1000' FS=: /etc/passwd           # human users (uid >= 1000)
awk '{sum += $2} END {print sum}' data.txt  # sum a column
awk 'NR==5' file                            # 5th line
awk '{print NF}' file                       # number of fields per line
```

### Day 7: Regular expressions cheat sheet
| Pattern | Meaning |
|---|---|
| `.` | any char |
| `*` / `+` / `?` | 0+ / 1+ / 0-1 of previous (`+ ?` need `-E`) |
| `^` / `$` | start / end of line |
| `[abc]` / `[^abc]` | one of / none of |
| `[0-9]`, `[a-zA-Z]` | ranges |
| `\b` | word boundary |
| `(a\|b)` | alternation (with `-E`: `(a|b)`) |
| `{3}` / `{2,5}` | exact / range repeat (with `-E`) |

---

## Exercises
Use `../Practice/sample-access.log` (generate it with `../Practice/generate-log.sh`).
1. How many requests are in the log?
2. Top 5 IP addresses by request count.
3. How many responses were `404`? `500`?
4. Which URL paths were requested most?
5. List all unique HTTP methods.
6. Replace every `GET` with `FETCH` and save to a new file without modifying the original.
7. From `/etc/passwd`, print the usernames of accounts whose shell is `/bin/bash`, sorted.

## Mini-project: Log report one-liner
Write a single pipeline (can be multi-line with `\`) that prints:
```
Total requests: N
Top 3 IPs:
   120 10.0.0.5
   ...
Errors (5xx): N
```

## Month 1 checkpoint
- [ ] Explain stdin/stdout/stderr and redirect each one
- [ ] Why `sort | uniq -c` and not just `uniq -c`?
- [ ] Do an in-place find/replace across a file with a backup
- [ ] Print the 2nd column of a CSV with `cut` and with `awk`
- [ ] Solve Bandit up to level 12
