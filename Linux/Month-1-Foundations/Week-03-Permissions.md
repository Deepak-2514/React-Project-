# Week 3: Files, Users and Permissions

## Goals
- Read and change permissions (`chmod`) and ownership (`chown`)
- Understand users, groups, root and `sudo`
- Know special bits (setuid, setgid, sticky) and `umask`

---

## Reading `ls -l`

```
-rwxr-xr--  1  alex  devs  4096  Nov 19 10:00  deploy.sh
│└┬┘└┬┘└┬┘     └┬─┘  └┬─┘
│ │  │  │       │     └─ group owner
│ │  │  │       └─────── user owner
│ │  │  └─ others: r-- (read only)
│ │  └──── group:  r-x (read, execute)
│ └─────── user:   rwx (read, write, execute)
└───────── type: - file, d directory, l link, c/b device
```

| Permission | On a file | On a directory |
|---|---|---|
| `r` (4) | read contents | list names (`ls`) |
| `w` (2) | modify contents | create/delete/rename entries |
| `x` (1) | run as program | enter it (`cd`) and access entries |

---

## Day-by-day

### Day 1: chmod
```bash
# Symbolic
chmod u+x script.sh       # add execute for user
chmod go-w file           # remove write from group and others
chmod a=r file            # everyone read only
chmod -R u+rwX dir        # recursive (capital X = execute only on dirs)

# Numeric (octal): add r=4 w=2 x=1 for each of user/group/other
chmod 755 script.sh       # rwxr-xr-x  → programs, directories
chmod 644 notes.txt       # rw-r--r--  → normal files
chmod 600 ~/.ssh/id_ed25519  # rw------- → secrets
chmod 700 ~/private       # rwx------
```

### Day 2: Ownership
```bash
sudo chown alex file
sudo chown alex:devs file
sudo chown -R www-data:www-data /var/www/site
sudo chgrp devs file
```

### Day 3: Users and groups
```bash
id                       # your uid, gid, groups
groups
cat /etc/passwd          # user accounts (name:x:uid:gid:info:home:shell)
cat /etc/group           # groups
sudo cat /etc/shadow     # password hashes (root only)

sudo useradd -m -s /bin/bash testuser   # create user with home
sudo passwd testuser
sudo usermod -aG devs testuser          # add to group (-a is critical!)
sudo groupadd devs
su - testuser                           # switch user
sudo userdel -r testuser                # delete user + home
```
> `usermod -G` **without** `-a` *replaces* all groups. Always use `-aG`.

### Day 4: sudo
```bash
sudo -l                  # what am I allowed to run?
sudo visudo              # safely edit /etc/sudoers (never edit directly)
```
Users get sudo by being in the `sudo` (Debian/Ubuntu) or `wheel` (Arch/Fedora) group.

### Day 5: Special permissions and umask
| Bit | Octal | Effect | Example |
|---|---|---|---|
| setuid | 4000 | Program runs as the file's owner | `/usr/bin/passwd` |
| setgid | 2000 | On dirs: new files inherit the group | shared team folders |
| sticky | 1000 | On dirs: only the owner can delete their files | `/tmp` (`drwxrwxrwt`) |

```bash
ls -l /usr/bin/passwd /tmp -d
chmod 2775 /srv/shared       # setgid shared folder
umask                        # default permission mask (e.g. 0022 → files 644, dirs 755)
```

### Day 6: Hidden files and attributes
```bash
ls -a ~                      # dotfiles: .bashrc, .config, .ssh
lsattr file; sudo chattr +i file   # immutable. Even root can't modify until -i
getfacl file; setfacl -m u:bob:r file  # ACLs for fine-grained access
```

### Day 7: Review + Bandit levels 7–10

---

## Exercises
1. Create `secret.txt` that only you can read and write. Verify with `ls -l`.
2. Create a script `hello.sh` containing `echo hi`, make it executable, run it with `./hello.sh`.
3. Remove `x` from a directory you own and try to `cd` into it. Explain the result.
4. Convert to octal: `rwxr-x---`, `rw-rw-r--`, `r--------`.
5. Create a group `team`, two users, and a `/srv/team` folder where both can create files and
   new files automatically belong to `team` (hint: setgid).
6. Why does `/tmp` have the sticky bit?

## Mini-project: Shared project folder
Set up `/srv/project` for a group of users with correct group ownership, setgid, and `umask 002`, so
anyone in the group can edit anyone's files but others can't read anything. Write down every command you used.

## Checkpoint
- [ ] What does `chmod 750` mean in letters?
- [ ] What does `x` mean on a directory?
- [ ] Why `usermod -aG` and not `-G`?
- [ ] What is setuid, and why is it a security concern?
- [ ] Where are user accounts and password hashes stored?
