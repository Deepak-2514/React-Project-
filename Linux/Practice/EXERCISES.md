# Practice Challenges

Extra drills, grouped by month. Try them without notes; check with `man` only when stuck.

## Setup
```bash
cd Linux/Practice
chmod +x *.sh
./generate-log.sh            # creates sample-access.log
```

## Month 1: Foundations
1. Make `~/lab/{a,b,c}/{1,2,3}` in one command, then count the directories with `find`.
2. Create 100 files `f001.txt`…`f100.txt` (hint: `touch f{001..100}.txt`). Delete only those divisible by 10.
3. Find all files in `/etc` owned by root that you *can* read and that contain the word `ssh`.
4. Make a file readable by group only (not even you can write it). Then fix it.
5. `sample-access.log`: count requests per status code, sorted by count.
6. `sample-access.log`: which IP got the most `404`s?
7. `sample-access.log`: list unique user agents and how often each appears.
8. `sample-access.log`: total bytes sent (column 10) using `awk`.
9. Print the 10 most common words in any text file (`tr -cs 'A-Za-z' '\n' | tr A-Z a-z | sort | uniq -c | sort -nr | head`). Explain each step.

## Month 2: Power user
10. Start 3 background jobs; kill them all with one command.
11. Write `watchdog.sh PROCESS`: restarts a process if it isn't running (check every 5s).
12. Write `bulk-rename.sh PREFIX`: renames every file in a dir to `PREFIX_001.ext`, `PREFIX_002.ext`...
13. Write `wordfreq.sh FILE N`: prints the top N words (reuse #9) with nice formatting.
14. Write `passgen.sh -l LENGTH -n COUNT`: generates random passwords (`/dev/urandom` + `tr`).
15. Write `logreport.sh LOGFILE` that produces the Week 4 report with colors and a `-h` flag.
16. Make a `.bashrc` function `mkcd` that creates a directory and `cd`s into it.
17. Make a `.bashrc` function `extract` that extracts any archive based on its extension.

## Month 3: SysAdmin
18. Write a systemd service that runs a Python HTTP server on port 8000 as a non-root user.
19. Write a timer that deletes files older than 7 days from `~/Downloads/tmp`.
20. Find which process is listening on every open TCP port and output it as CSV.
21. Set up two VMs (or containers) and SSH from one to the other with keys only.
22. Use `rsync` over SSH to make an incremental backup; run it twice and confirm the second is fast.
23. Simulate a full disk with a loop device (`fallocate` a big file into it). Find the culprit using only `df` and `du`.
24. Break your SSH config on purpose (in a VM!), get locked out, recover via the console.
25. Run nginx in Docker, mount a local folder as the web root, edit a file, see it change live.
