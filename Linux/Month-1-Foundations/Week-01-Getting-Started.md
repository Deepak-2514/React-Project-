# Week 1: Getting Started, the Shell and Getting Help

## Goals
- Understand what Linux, a distribution, a kernel, and a shell are
- Open a terminal and run commands confidently
- Learn to find help on your own (`man`, `--help`, `tldr`)

---

## Core concepts

| Term | Meaning |
|---|---|
| **Kernel** | The core of the OS. It talks to hardware and manages memory, processes and devices. Linux *is* the kernel. |
| **Distribution (distro)** | Kernel + tools + package manager + defaults (Ubuntu, Fedora, Arch, Debian). |
| **Shell** | Program that reads your commands and runs them (`bash`, `zsh`, `fish`). |
| **Terminal** | The window that hosts the shell. |
| **Prompt** | `user@host:~$`. A `$` means a normal user and `#` means root. |

Anatomy of a command:
```
ls   -l -a   /etc
│    │       └── argument (what to act on)
│    └────────── options/flags (how to act)
└─────────────── command (what to do)
```

---

## Day-by-day

### Day 1: First commands
```bash
whoami          # your username
hostname        # machine name
date            # current date/time
cal             # calendar
uptime          # how long the system has been running
uname -a        # kernel info
cat /etc/os-release   # which distro you're on
echo "Hello, Linux"   # print text
clear           # clear screen (or Ctrl+L)
```

### Day 2: Getting help (the most important skill)
```bash
man ls          # full manual. Navigate with / to search, n for next, q to quit
ls --help       # quick summary
whatis ls       # one-line description
apropos copy    # search manuals by keyword (also: man -k copy)
type cd         # is it a builtin, alias, or program?
which python3   # where is the program?
help cd         # help for bash builtins
```
Install `tldr` for practical examples: `sudo apt install tldr` / `sudo pacman -S tldr`, then `tldr tar`.

### Day 3: Shell shortcuts (huge time savers)
| Shortcut | Action |
|---|---|
| `Tab` | Autocomplete (press twice to list options) |
| `↑ / ↓` | Previous/next command |
| `Ctrl+R` | Search command history |
| `Ctrl+C` | Cancel running command |
| `Ctrl+D` | Exit shell / end input |
| `Ctrl+A / Ctrl+E` | Jump to start / end of line |
| `Ctrl+U / Ctrl+K` | Delete to start / end of line |
| `Ctrl+W` | Delete previous word |
| `!!` | Repeat last command (`sudo !!`) |
| `!$` | Last argument of previous command |

```bash
history         # see past commands
!42             # rerun command #42 from history
```

### Day 4: Your first navigation
```bash
pwd             # print working directory
ls              # list
ls -la          # long format, include hidden files
cd /            # go to root
cd ~            # go home (or just `cd`)
cd -            # go back to previous directory
cd ..           # up one level
```

### Day 5: sudo and root
```bash
sudo apt update     # run one command as root (Debian/Ubuntu)
sudo -i             # root shell. Be careful and exit when done
id                  # your user id and groups
```
> Never run commands you don't understand with `sudo`, especially anything from the internet with `rm`, `dd`, `mkfs` or `curl ... | sudo bash`.

### Day 6: Linux philosophy
- Everything is a file (devices in `/dev`, processes in `/proc`).
- Small programs that each do one thing well, combined with pipes.
- Silence is golden: no output usually means success.
- Check the exit code: `echo $?` (0 = success, anything else = error).

```bash
ls /nonexistent; echo $?    # non-zero
ls /;            echo $?    # 0
```

### Day 7: Review + Bandit
Start [OverTheWire Bandit](https://overthewire.org/wargames/bandit/) levels 0–2.

---

## Exercises
1. Find out which kernel version and distro you're running.
2. Use `man` to find the flag for `ls` that sorts by modification time. Use it.
3. Use `apropos` to find a command that shows disk free space.
4. Use `Ctrl+R` to find and rerun a command from earlier today.
5. Find out whether `echo`, `ls`, and `cd` are builtins or programs.

## Mini-project
Create a file `~/notes/linux.md` (you'll learn `mkdir`/editors properly later; for now:
`mkdir -p ~/notes && echo "# My Linux Notes" > ~/notes/linux.md`). Add every new command you learn this week.

## Checkpoint (answer without notes)
- [ ] What's the difference between the kernel, shell and terminal?
- [ ] How do you search inside a `man` page?
- [ ] What does `echo $?` tell you?
- [ ] What does `cd -` do?
- [ ] Why is `$` vs `#` in the prompt important?
