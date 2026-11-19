# Week 2: Filesystem and Navigation

## Goals
- Understand the Linux directory tree (FHS)
- Create, copy, move, delete and find files
- Understand absolute vs relative paths, links, and globbing

---

## The directory tree

Everything starts at `/` (root). There are no drive letters.

| Path | What lives there |
|---|---|
| `/` | Root of everything |
| `/home/<user>` | Your files (`~`) |
| `/root` | Root user's home |
| `/etc` | System configuration (text files!) |
| `/bin`, `/usr/bin` | User programs |
| `/sbin`, `/usr/sbin` | System admin programs |
| `/var` | Variable data: logs (`/var/log`), caches, mail |
| `/tmp` | Temporary files (cleared on reboot) |
| `/dev` | Device files (`/dev/sda`, `/dev/null`) |
| `/proc`, `/sys` | Virtual files exposing kernel/process info |
| `/opt` | Optional third-party software |
| `/mnt`, `/media` | Mount points for drives/USBs |
| `/boot` | Kernel and bootloader |
| `/lib`, `/usr/lib` | Shared libraries |

```bash
man hier        # official description of the hierarchy
```

---

## Day-by-day

### Day 1: Paths
- **Absolute** paths start with `/`: `/home/alex/docs`
- **Relative** paths start from where you are: `docs/notes.txt`, `../other`
- `.` = current dir, `..` = parent dir, `~` = home

```bash
cd /var/log && pwd
cd ../../etc && pwd
ls ~/.config
```

### Day 2: Creating and viewing
```bash
mkdir projects
mkdir -p a/b/c          # create parents as needed
touch file.txt          # create empty file / update timestamp
cat file.txt            # print whole file
less /etc/services      # page through (q to quit, / to search)
head -n 5 /etc/passwd   # first 5 lines
tail -n 5 /etc/passwd   # last 5 lines
tail -f /var/log/syslog # follow a growing file (Ctrl+C to stop)
file /bin/ls            # what kind of file is it?
stat file.txt           # detailed metadata
```

### Day 3: Copy, move, delete
```bash
cp file.txt backup.txt
cp -r dir1 dir2         # copy directory recursively
cp -i a b               # ask before overwrite
mv old.txt new.txt      # rename
mv file.txt ~/projects/ # move
rm file.txt
rm -r dir               # delete a directory
rm -ri dir              # interactive. Safer
rmdir emptydir          # only removes empty dirs
```
> ⚠️ There is no recycle bin. `rm -rf` is permanent. Double-check paths, especially ones with variables or `*`.

### Day 4: Globbing (wildcards)
```bash
ls *.txt          # any .txt
ls file?.txt      # single character
ls file[1-3].txt  # range
ls {a,b,c}.txt    # brace expansion (also: mkdir -p proj/{src,docs,tests})
echo ~/*.md       # see what a glob expands to before using it with rm!
```

### Day 5: Finding things
```bash
find ~ -name "*.md"                 # by name
find . -type d -name "node_modules" # directories only
find /var/log -size +10M            # bigger than 10MB
find . -mtime -1                    # modified in last 24h
find . -name "*.tmp" -delete        # find and delete (careful!)
find . -name "*.sh" -exec chmod +x {} \;

locate passwd                       # fast, uses a database (sudo updatedb)
which ls; whereis ls
```

### Day 6: Links and disk usage
```bash
ln -s /path/to/target linkname  # symbolic (soft) link, like a shortcut
ln target hardlink              # hard link: same inode, different name
ls -li                          # show inode numbers
readlink -f linkname            # resolve where a link points

du -sh ~/Downloads              # size of a directory
du -h --max-depth=1 . | sort -h # what's using space here?
df -h                           # free space per filesystem
tree -L 2                       # visual tree (install `tree`)
```

### Day 7: Review + Bandit levels 3–6

---

## Exercises
1. Create this structure in one command: `practice/{src,docs,tests}/` with `mkdir -p`.
2. Create 10 files `note1.txt` … `note10.txt` using brace expansion `{1..10}`.
3. Move all notes with odd numbers into `practice/docs`.
4. Find every `.conf` file under `/etc` that is less than 1KB.
5. Find the 5 largest directories in your home folder.
6. Create a symlink in your home called `logs` that points to `/var/log`. Then `cd logs`.
7. Explain the difference between deleting a symlink's target and deleting a hard link's original.

## Mini-project: "Downloads Organizer" (manual version)
In a test folder with mixed files (`.jpg`, `.pdf`, `.txt`, `.zip`), use `mkdir` + `mv` + globs to sort them
into `images/`, `docs/`, `archives/`. In week 7 you'll automate this with a script.

## Checkpoint
- [ ] Where are config files? Logs? User programs?
- [ ] Absolute vs relative path: give an example of each
- [ ] How do you safely preview what `rm *.log` will delete?
- [ ] Soft link vs hard link
- [ ] Find all files modified in the last 2 days under `~`
