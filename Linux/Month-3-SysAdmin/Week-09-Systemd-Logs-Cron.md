# Week 9: systemd, Services, Logs and Scheduling

## Goals
- Manage services with `systemctl`
- Read and filter logs with `journalctl` and `/var/log`
- Write your own systemd service and timer
- Schedule jobs with cron
- Understand the boot process

---

## Day 1: The boot process (overview)
1. **Firmware** (UEFI/BIOS) → finds the bootloader
2. **Bootloader** (GRUB/systemd-boot) → loads kernel + initramfs
3. **Kernel** → initializes hardware, mounts root filesystem
4. **systemd** (PID 1) → starts services in parallel to reach a **target** (e.g. `multi-user.target`, `graphical.target`)

```bash
systemd-analyze               # boot time
systemd-analyze blame | head  # slowest units
systemctl get-default         # default target
```

## Day 2: systemctl
```bash
systemctl status sshd
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx        # reload config without restart
sudo systemctl enable nginx        # start at boot
sudo systemctl enable --now nginx  # enable + start
sudo systemctl disable nginx
systemctl is-active nginx; systemctl is-enabled nginx
systemctl list-units --type=service --state=running
systemctl --failed                 # what's broken?
systemctl cat sshd                 # show unit file
sudo systemctl daemon-reload       # after editing unit files
```

## Day 3: journalctl
```bash
journalctl -u nginx              # logs for one service
journalctl -u nginx -f           # follow
journalctl -b                    # since this boot
journalctl -b -1                 # previous boot (did it crash?)
journalctl -p err                # errors and worse
journalctl --since "1 hour ago"
journalctl --since "2026-11-01" --until "2026-11-02"
journalctl -k                    # kernel messages (also: dmesg)
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
```
Classic log files in `/var/log`: `syslog` or `messages`, `auth.log` or `secure` (logins/sudo), `kern.log`, app dirs like `nginx/`.

## Day 4: Write your own service
`/etc/systemd/system/hello.service`:
```ini
[Unit]
Description=Hello world demo service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/hello-loop.sh
Restart=on-failure
RestartSec=5
User=nobody

[Install]
WantedBy=multi-user.target
```
`/usr/local/bin/hello-loop.sh`:
```bash
#!/usr/bin/env bash
while true; do echo "hello at $(date)"; sleep 10; done
```
```bash
sudo chmod +x /usr/local/bin/hello-loop.sh
sudo systemctl daemon-reload
sudo systemctl enable --now hello
journalctl -u hello -f
```

## Day 5: cron
```bash
crontab -e        # edit your cron jobs
crontab -l        # list
sudo crontab -e   # root's jobs
```
```
# ┌ min (0-59) ┌ hour (0-23) ┌ day of month ┌ month ┌ day of week (0=Sun)
# │            │             │              │       │
  */5          *             *              *       *     /home/me/bin/check.sh
  0            2             *              *       *     /home/me/bin/backup.sh >> /home/me/backup.log 2>&1
  30           9             *              *       1-5   echo "weekday 9:30"
  @reboot                                                 /home/me/bin/on-boot.sh
```
Use [crontab.guru](https://crontab.guru) to check expressions. Cron runs with a minimal `PATH`, so use absolute paths.

## Day 6: systemd timers (modern cron)
`/etc/systemd/system/backup.timer`:
```ini
[Unit]
Description=Daily backup

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```
plus a matching `backup.service` with `Type=oneshot` and `ExecStart=/usr/local/bin/backup.sh`.
```bash
sudo systemctl enable --now backup.timer
systemctl list-timers
```
One-off scheduling: `echo "reboot" | at 03:00` (needs `at`), or `systemd-run --on-active=10m cmd`.

## Day 7: Review + Bandit levels 21–25 (they're about cron!)

---

## Exercises
1. List all failed units and all enabled services on your machine.
2. Find every failed SSH/sudo login attempt in the last day (`journalctl` or `/var/log/auth.log`).
3. Create the `hello` service above. Kill its process and confirm systemd restarts it.
4. Add a cron job that appends `date` to `~/cron-test.log` every minute. Verify, then remove it.
5. Convert that cron job into a systemd timer.
6. Find which service took longest during boot.

## Mini-project: Disk alert service
Write `disk-alert.sh` that logs a warning (via `logger -t disk-alert "..."`) if any filesystem is over 80% full.
Run it every 15 minutes with a systemd timer. Verify with `journalctl -t disk-alert`.

## Checkpoint
- [ ] `start` vs `enable`
- [ ] Show logs for one service since the last boot
- [ ] Write a unit file from memory
- [ ] Read a cron expression: `0 */6 * * 1`
- [ ] What happens at each boot stage?
