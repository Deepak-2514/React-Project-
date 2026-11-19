# Week 5: Processes, Jobs and Signals

## Goals
- See what's running and what's using resources
- Control jobs (foreground/background) and send signals
- Understand PIDs, parent/child processes, and system resources

---

## Concepts
- **Process**: a running program with a **PID**. Every process has a parent (**PPID**); PID 1 is `systemd` (init).
- **States**: R (running), S (sleeping), D (uninterruptible, usually I/O), Z (zombie), T (stopped).
- **Signals**: messages to processes. The common ones:

| Signal | Number | Meaning |
|---|---|---|
| SIGTERM | 15 | Please exit (default for `kill`) |
| SIGKILL | 9 | Die now (can't be caught; last resort) |
| SIGINT | 2 | Interrupt (Ctrl+C) |
| SIGHUP | 1 | Hang up / often "reload config" |
| SIGSTOP / SIGTSTP | 19 / 20 | Pause (Ctrl+Z) |
| SIGCONT | 18 | Resume |

---

## Day-by-day

### Day 1: Viewing processes
```bash
ps                    # your shell's processes
ps aux                # all processes, BSD style
ps -ef                # all processes, System V style
ps -ef --forest       # tree view
pstree -p             # process tree with PIDs
pgrep -a firefox      # find PIDs by name
```

### Day 2: Live monitoring
```bash
top                   # press: P (cpu), M (mem), k (kill), q (quit), 1 (per-CPU)
htop                  # nicer (install it). F6 to sort, F9 to kill, / to search
btop                  # even nicer, if available
free -h               # memory
vmstat 1              # system stats every second
uptime                # load average: 1, 5, 15 min
nproc                 # CPU cores (load ≈ nproc means fully busy)
```

### Day 3: Killing processes
```bash
kill 1234             # SIGTERM
kill -9 1234          # SIGKILL (only if TERM fails)
kill -l               # list all signals
pkill -f "python app.py"
killall node
```

### Day 4: Jobs: foreground and background
```bash
sleep 300 &           # start in background
jobs                  # list jobs
fg %1                 # bring job 1 to foreground
# press Ctrl+Z to suspend the foreground job
bg %1                 # continue it in background
nohup ./long.sh > out.log 2>&1 &   # survives logout
disown %1             # detach a job from the shell
```

### Day 5: Priority and resources
```bash
nice -n 10 ./heavy-task.sh      # start with lower priority (−20 high … 19 low)
renice -n 5 -p 1234             # change running process
ionice -c3 ./backup.sh          # idle I/O priority
ulimit -a                       # per-process limits
```

### Day 6: /proc and inspecting a process
```bash
cat /proc/cpuinfo | grep "model name" | head -1
cat /proc/meminfo | head
ls /proc/$$                     # $$ = current shell's PID
cat /proc/$$/status
lsof -p 1234                    # files a process has open
lsof -i :8080                   # who is using port 8080?
strace -p 1234                  # watch system calls (advanced debugging)
```

### Day 7: tmux (terminal multiplexer, essential for servers)
```bash
tmux                 # new session
tmux new -s work     # named session
# Prefix is Ctrl+b, then:
#   %  split vertical     "  split horizontal    arrow  move between panes
#   c  new window         n/p next/prev window   d  detach
tmux ls              # list sessions
tmux attach -t work  # reattach (your programs kept running!)
```

---

## Exercises
1. Start `sleep 1000` three times in the background. List them, kill the second one by job number, and the third by PID.
2. Find the 3 processes using the most memory with one `ps` + `sort` + `head` pipeline.
3. Run `yes > /dev/null &` and watch it in `htop`. Renice it to 19, then kill it.
4. Find what process is listening on port 22 (or any open port).
5. Start a tmux session, run `top` inside, detach, close your terminal, reopen, reattach.

## Mini-project: `topmem`
Create a shell alias or tiny script that prints the top 5 memory-hungry processes with PID, %MEM and command name
in a clean table. (Hint: `ps -eo pid,%mem,comm --sort=-%mem | head -6`.)

## Checkpoint
- [ ] SIGTERM vs SIGKILL: which should you try first and why?
- [ ] What does a load average of 4.0 mean on a 2-core vs 8-core machine?
- [ ] How do you keep a command running after you log out?
- [ ] What's a zombie process?
- [ ] Detach/reattach in tmux
