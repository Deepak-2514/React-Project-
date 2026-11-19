# Week 12: Containers, Git, Troubleshooting and Capstone

## Goals
- Use Git from the command line
- Understand and run containers with Docker/Podman
- Troubleshoot systematically
- Complete a capstone that proves your skills

---

## Day 1: Git essentials
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git init; git clone <url>
git status; git diff; git log --oneline --graph
git add file; git add -p              # stage interactively by hunk
git commit -m "message"
git switch -c feature; git switch main
git merge feature
git pull; git push -u origin feature
git stash; git stash pop
git restore file                      # discard changes
```

## Day 2: Containers
Containers = isolated processes using kernel features (**namespaces** + **cgroups**). Not VMs.
```bash
docker run -it --rm ubuntu bash             # throwaway shell
docker run -d --name web -p 8080:80 nginx   # background web server
docker ps; docker ps -a
docker logs -f web
docker exec -it web bash
docker stop web && docker rm web
docker images; docker pull alpine
docker run -v "$PWD":/data alpine ls /data  # mount a folder
```
Minimal `Dockerfile`:
```dockerfile
FROM nginx:alpine
COPY site/ /usr/share/nginx/html/
```
```bash
docker build -t mysite .
docker run -d -p 8080:80 mysite
```
`docker compose up -d` runs multi-container apps from `compose.yaml`. **Podman** is a daemonless, rootless drop-in (`alias docker=podman`).

## Day 3: Troubleshooting methodology
1. **What exactly is the symptom?** Reproduce it.
2. **What changed?** (updates, config, deploys: check `git log`, `/var/log/apt/history.log`, `pacman.log`)
3. **Check the layers**: hardware → disk/memory → network → service → application.
4. **Read the logs**: `journalctl -xe`, `journalctl -u svc`, `/var/log/*`, `dmesg`.
5. **Form a hypothesis, test one change at a time**, and write down what you did.

### The 60-second performance check
```bash
uptime                 # load
dmesg -T | tail        # kernel errors (OOM killer, disk errors)
vmstat 1 5             # CPU, memory, swap, IO wait
free -h                # memory
df -h; df -i           # disk space AND inodes
iostat -xz 1 3         # disk IO (sysstat)
ss -s                  # socket summary
top / htop             # who's using what
```

### Common problems → first command
| Symptom | Try |
|---|---|
| "Disk full" | `df -h`, `du -h --max-depth=1 / \| sort -h`, `ncdu /`, check `df -i` |
| Deleted file still using space | `lsof +L1` (restart the process holding it) |
| Service won't start | `systemctl status svc`, `journalctl -u svc -b` |
| Port already in use | `ss -tulpn \| grep :PORT` |
| Permission denied | `ls -l`, `namei -l /full/path`, check SELinux/AppArmor |
| Command not found | `echo $PATH`, `which cmd`, is it installed? |
| Can't resolve names | `cat /etc/resolv.conf`, `dig name`, `resolvectl status` |
| Slow system | `top`, `vmstat 1`, `iostat`, check swap usage |
| Process killed randomly | `dmesg \| grep -i oom` |

## Days 4–6: Capstone project
Pick **one** (or do all three if you're ambitious). Full specs: [../Projects/CAPSTONE.md](../Projects/CAPSTONE.md).

1. **Server from scratch**: Fresh VM → hardened → nginx + your site + HTTPS → automated backups via systemd timer →
   log monitoring script → documented in a README.
2. **Sysadmin toolkit**: A Git repo of polished Bash tools (`sysinfo`, `backup`, `organize`, `disk-alert`,
   `log-report`) with `--help`, strict mode, shellcheck-clean, and an install script.
3. **Containerized app**: A multi-container app (web + database) with Docker Compose, a systemd service to start it on boot,
   nightly DB backups, and a health-check script that alerts on failure.

## Day 7: Graduation
- Re-take every checkpoint in `PROGRESS.md`
- Push your capstone and dotfiles to GitHub
- Pick your next path (see below)

---

## Where to go next
| Path | Learn next |
|---|---|
| DevOps / Cloud | Ansible, Terraform, Kubernetes, CI/CD (GitHub Actions), AWS/GCP |
| Security | TryHackMe/HackTheBox, networking deep dive, iptables/nftables, SELinux |
| Development | Make, GCC/Clang, gdb, Python/Go system tooling |
| Certification | LFCS, RHCSA, Linux+ |
| Deep internals | *How Linux Works* (Ward), Linux From Scratch, kernel modules |

## Final checkpoint
- [ ] Run, inspect, and clean up a container; build an image from a Dockerfile
- [ ] Commit, branch, merge, and push with Git
- [ ] Diagnose a full disk, a failed service, and a busy port
- [ ] Capstone complete and documented
