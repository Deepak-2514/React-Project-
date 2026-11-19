# Linux Command Cheatsheet

## Navigation and files
| Command | Purpose |
|---|---|
| `pwd`, `cd DIR`, `cd -`, `cd ~` | where am I / move |
| `ls -lah` | list everything with sizes |
| `tree -L 2` | directory tree |
| `mkdir -p a/b/c` | make nested dirs |
| `touch f` | create empty file |
| `cp -r src dst` / `mv a b` / `rm -ri x` | copy / move / remove |
| `ln -s target link` | symlink |
| `find . -name '*.log' -mtime -1` | find files |
| `locate name` | fast find (indexed) |
| `stat f`, `file f` | metadata / file type |
| `du -sh dir`, `df -h` | dir size / disk free |

## Viewing text
| Command | Purpose |
|---|---|
| `cat`, `less`, `head -n`, `tail -n`, `tail -f` | view files |
| `wc -l` | count lines |
| `diff a b`, `diff -u a b` | compare files |
| `grep -rn pat dir` | search text |
| `sort`, `uniq -c`, `cut -d, -f2`, `tr` | slice and count |
| `sed 's/a/b/g'`, `awk '{print $1}'` | transform |
| `tee file` | write and pass through |
| `xargs` | build commands from input: `find . -name '*.tmp' \| xargs rm` |

## Permissions and users
| Command | Purpose |
|---|---|
| `chmod 755 f`, `chmod u+x f` | change mode |
| `chown user:group f` | change owner |
| `id`, `groups`, `whoami` | who am I |
| `sudo cmd`, `sudo -i`, `su - user` | elevate / switch |
| `useradd -m -s /bin/bash u`, `usermod -aG grp u`, `passwd u` | manage users |

## Processes
| Command | Purpose |
|---|---|
| `ps aux`, `pgrep -a name`, `pstree` | list |
| `top`, `htop` | live view |
| `kill PID`, `kill -9 PID`, `pkill name` | signal |
| `cmd &`, `jobs`, `fg`, `bg`, `Ctrl+Z` | job control |
| `nohup cmd &`, `tmux` | survive logout |
| `nice`, `renice` | priority |
| `lsof -i :PORT` | who uses this port/file |

## System
| Command | Purpose |
|---|---|
| `uname -a`, `cat /etc/os-release` | kernel / distro |
| `uptime`, `free -h`, `vmstat 1` | load / memory |
| `lscpu`, `lsblk`, `lspci`, `lsusb` | hardware |
| `systemctl status/start/stop/enable svc` | services |
| `journalctl -u svc -f`, `dmesg -T` | logs |
| `crontab -e`, `systemctl list-timers` | scheduling |
| `reboot`, `shutdown -h now` | power |

## Networking
| Command | Purpose |
|---|---|
| `ip a`, `ip r` | addresses / routes |
| `ping`, `traceroute`, `mtr` | reachability |
| `dig name`, `host name` | DNS |
| `ss -tulpn` | listening ports |
| `curl -I url`, `wget url` | HTTP |
| `ssh`, `scp`, `rsync -avz` | remote access / copy |
| `nc -zv host port` | test a port |

## Archives
| Command | Purpose |
|---|---|
| `tar -czvf out.tar.gz dir` | create |
| `tar -xzvf in.tar.gz -C dest` | extract |
| `tar -tzvf in.tar.gz` | list |
| `zip -r out.zip dir`, `unzip f.zip` | zip |

## Packages
| | apt | dnf | pacman |
|---|---|---|---|
| install | `apt install x` | `dnf install x` | `pacman -S x` |
| remove | `apt remove x` | `dnf remove x` | `pacman -Rns x` |
| update all | `apt update && apt upgrade` | `dnf upgrade` | `pacman -Syu` |
| search | `apt search x` | `dnf search x` | `pacman -Ss x` |
