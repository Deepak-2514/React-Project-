# Linux: Zero to Hero in 3 Months

A 12-week, hands-on roadmap. Budget **1–2 hours per day, 6 days a week**, with day 7 for review.
By the end you will be comfortable on the command line, able to write Bash scripts, administer a
Linux server, and debug real problems.

> Rule #1: **Type every command yourself.** Reading about Linux doesn't teach it. Using it does.

---

## Setup (do this on day 0)

Pick **one** practice environment:

| Option | Good for | How |
|---|---|---|
| Your own Linux machine | Everyday practice | You already have one |
| Virtual machine (VirtualBox/QEMU + Ubuntu Server) | Safe to break things | Install Ubuntu Server 24.04 LTS |
| WSL2 (Windows) | Windows users | `wsl --install` |
| Docker container | Throwaway sandboxes | `docker run -it --rm ubuntu bash` |
| Cloud VM (free tier) | Month 3 networking/SSH | Any provider's smallest VM |

**Recommendation:** use your daily machine for months 1–2, plus a VM you can break and rebuild for month 3.

---

## The Roadmap

### Month 1: Foundations (Survive in the terminal)
| Week | Topic | File |
|---|---|---|
| 1 | Getting started, the shell, getting help | [Week-01](Month-1-Foundations/Week-01-Getting-Started.md) |
| 2 | Filesystem and navigation | [Week-02](Month-1-Foundations/Week-02-Filesystem.md) |
| 3 | Files, users and permissions | [Week-03](Month-1-Foundations/Week-03-Permissions.md) |
| 4 | Text processing, pipes and redirection | [Week-04](Month-1-Foundations/Week-04-Text-Processing.md) |

### Month 2: Power User (Make the terminal work for you)
| Week | Topic | File |
|---|---|---|
| 5 | Processes, jobs and signals | [Week-05](Month-2-Power-User/Week-05-Processes.md) |
| 6 | Packages, editors (Vim) and environment | [Week-06](Month-2-Power-User/Week-06-Packages-Vim-Env.md) |
| 7 | Bash scripting I: variables, conditions, loops | [Week-07](Month-2-Power-User/Week-07-Bash-Scripting-1.md) |
| 8 | Bash scripting II: functions, arguments, robust scripts | [Week-08](Month-2-Power-User/Week-08-Bash-Scripting-2.md) |

### Month 3: SysAdmin and Hero (Run and fix real systems)
| Week | Topic | File |
|---|---|---|
| 9 | systemd, services, logs and scheduling | [Week-09](Month-3-SysAdmin/Week-09-Systemd-Logs-Cron.md) |
| 10 | Networking and SSH | [Week-10](Month-3-SysAdmin/Week-10-Networking-SSH.md) |
| 11 | Storage, disks, security and hardening | [Week-11](Month-3-SysAdmin/Week-11-Storage-Security.md) |
| 12 | Containers, Git, troubleshooting and capstone | [Week-12](Month-3-SysAdmin/Week-12-Capstone.md) |

---

## Folder guide

```
Linux/
├── README.md                 ← you are here
├── PROGRESS.md               ← tick off checkpoints as you go
├── RESOURCES.md              ← books, sites, games, videos
├── Month-1-Foundations/      ← weeks 1–4
├── Month-2-Power-User/       ← weeks 5–8
├── Month-3-SysAdmin/         ← weeks 9–12
├── Grep/                     ← grep deep dive + practice file
├── Cheatsheets/              ← commands, vim, bash, networking
├── Practice/                 ← ready-to-run practice scripts and exercises
└── Projects/                 ← mini-projects + capstone ideas
```

## How to study each week

1. **Read** the week file top to bottom (about 30 min).
2. **Do** the daily tasks. Each day has commands to try.
3. **Solve** the exercises without looking at answers first.
4. **Build** the mini-project at the end of the week.
5. **Pass** the checkpoint: if you can answer every question without notes, move on.
6. **Log** what you learned in `PROGRESS.md`.

## Daily habits that make you a hero

- Use the terminal for things you would normally do with a mouse (moving files, opening apps, searching).
- When a command is new, run `man <cmd>` or `tldr <cmd>` before searching the web.
- Keep a `~/notes/linux.md` of commands you had to look up twice.
- Break things on purpose (in your VM), then fix them.
- Play [OverTheWire Bandit](https://overthewire.org/wargames/bandit/): about one level a day starting in week 2.
