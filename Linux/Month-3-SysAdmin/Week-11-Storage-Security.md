# Week 11: Storage, Disks, Archives, Security and Hardening

> ⚠️ Do the disk exercises in a **VM** or on a loop device. Never experiment on your real disks.

## Goals
- Partition, format, mount and auto-mount disks
- Understand LVM and swap at a practical level
- Compress and archive files
- Apply core security practices to a Linux system

---

## Day 1: Disks and partitions
```bash
lsblk                   # block devices tree
lsblk -f                # with filesystems and UUIDs
sudo fdisk -l           # partition tables
blkid                   # UUIDs
df -hT                  # mounted filesystems with types
```
Device names: `/dev/sda`, `/dev/sdb` (SATA/USB), `/dev/nvme0n1` (NVMe), `/dev/vda` (VMs), partitions `sda1`, `nvme0n1p1`.

Safe practice disk using a file:
```bash
truncate -s 1G ~/disk.img
sudo losetup -fP --show ~/disk.img     # → /dev/loop0 (for example)
```

## Day 2: Partition, format, mount
```bash
sudo fdisk /dev/loop0          # n (new), p, enter, enter, w (write)
# or: sudo parted /dev/loop0 mklabel gpt mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/loop0p1    # format (also mkfs.xfs, mkfs.btrfs, mkfs.vfat)
sudo mkdir -p /mnt/data
sudo mount /dev/loop0p1 /mnt/data
df -h /mnt/data
sudo umount /mnt/data
```
Permanent mount in `/etc/fstab` (use UUID, then test with `sudo mount -a` **before** rebooting):
```
UUID=xxxx-xxxx  /mnt/data  ext4  defaults,nofail  0  2
```
> A broken fstab can stop a system from booting. Always run `sudo mount -a` to test.

## Day 3: LVM and swap
LVM = flexible volumes you can resize: **PV** (physical volume) → **VG** (volume group) → **LV** (logical volume).
```bash
sudo pvcreate /dev/loop0p1
sudo vgcreate vgdata /dev/loop0p1
sudo lvcreate -L 500M -n lvapp vgdata
sudo mkfs.ext4 /dev/vgdata/lvapp
sudo lvextend -r -L +200M /dev/vgdata/lvapp   # grow + resize filesystem
sudo pvs; sudo vgs; sudo lvs
```
Swap file:
```bash
sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile
sudo mkswap /swapfile && sudo swapon /swapfile
swapon --show; free -h
```

## Day 4: Archives and compression
```bash
tar -czvf backup.tar.gz dir/      # create gzip   (c=create z=gzip v=verbose f=file)
tar -cJvf backup.tar.xz dir/      # xz (smaller, slower)
tar --zstd -cvf backup.tar.zst dir/
tar -tzvf backup.tar.gz           # list contents
tar -xzvf backup.tar.gz -C /tmp   # extract somewhere
zip -r site.zip site/ ; unzip site.zip
gzip file ; gunzip file.gz
dd if=/dev/sdX of=disk.img bs=4M status=progress   # raw copy. Triple-check if= and of=!
```

## Day 5: Security fundamentals
- **Least privilege**: users and services get only what they need. Don't run things as root.
- **Updates**: patch regularly (`unattended-upgrades` on Ubuntu).
- **SSH**: keys only, no root login, fail2ban (week 10).
- **Firewall**: deny by default, allow what's needed.
- **Audit**:
```bash
sudo ss -tulpn                        # what's exposed?
last; lastb                           # logins / failed logins
who; w                                # who's logged in now
sudo find / -perm -4000 -type f 2>/dev/null   # setuid binaries
sudo find / -perm -o+w -type f 2>/dev/null | grep -v proc   # world-writable files
sudo grep -E "Failed|Invalid" /var/log/auth.log | tail
```

## Day 6: More security tools
```bash
sha256sum file.iso                # verify downloads
gpg --verify file.sig file        # verify signatures
gpg -c secret.txt                 # encrypt with a passphrase
openssl rand -base64 32           # random password
sudo lynis audit system           # security audit (install lynis)
```
Mandatory Access Control: **SELinux** (Fedora/RHEL: `getenforce`, `sestatus`) and **AppArmor** (Ubuntu: `sudo aa-status`).
Learn to read their denials instead of disabling them.

## Day 7: Review

---

## Exercises
1. Create a 1GB loop disk, partition it, format ext4, mount it, write files, unmount.
2. Add it to `/etc/fstab` by UUID with `nofail`; test with `mount -a`.
3. Build an LVM volume on it and grow it while mounted.
4. Archive your `~/dotfiles` with tar+zstd; list it; extract to `/tmp`.
5. Run `lynis` and fix 3 suggestions.
6. List all setuid binaries and explain why 3 of them need setuid.

## Mini-project: Harden a fresh server
Starting from a fresh VM, write `harden.sh` (or a checklist) that: creates a sudo user, sets up SSH keys, disables
root and password login, enables the firewall (allow only SSH + HTTP/S), enables automatic security updates, and installs
fail2ban. Document what each step defends against.

## Checkpoint
- [ ] Mount a disk permanently and safely
- [ ] PV → VG → LV in one sentence
- [ ] Create and extract a `.tar.gz` without looking it up
- [ ] 5 things you'd do first on a new internet-facing server
- [ ] What's the risk of a world-writable file in `/etc`?
