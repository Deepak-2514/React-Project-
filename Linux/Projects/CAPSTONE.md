# Capstone Projects (Week 12)

Pick one. Each one should end up in a Git repo with a README that explains what you built and how to reproduce it.

---

## Option 1: Production-style server from scratch
**You prove:** installation, hardening, networking, services, automation.

Requirements:
- [ ] Fresh Ubuntu/Debian/Fedora VM or cloud server
- [ ] Non-root sudo user; SSH keys only; root login disabled
- [ ] Firewall allowing only 22, 80, 443
- [ ] fail2ban + automatic security updates
- [ ] nginx serving a static site (deployed with `rsync`)
- [ ] HTTPS via certbot (if you have a domain), otherwise a self-signed cert
- [ ] Nightly backup of the site + nginx config via a **systemd timer** using your `backup.sh`
- [ ] `disk-alert` timer from week 9
- [ ] README with every step, so someone else could rebuild it

Stretch: turn your notes into a single `provision.sh` that rebuilds the whole server.

---

## Option 2: Sysadmin toolkit
**You prove:** advanced Bash, code quality, packaging.

Build a repo `sysadmin-toolkit/` with:
- [ ] `bin/sysinfo`: system summary (OS, kernel, uptime, CPU, mem, disk, top processes, open ports)
- [ ] `bin/backup`: backups with rotation and dry-run
- [ ] `bin/organize`: sort files by type
- [ ] `bin/logreport`: summarize an nginx/apache access log (top IPs, status codes, top paths, errors)
- [ ] `bin/disk-alert`: warn via `logger` above a threshold
- [ ] `lib/common.sh`: shared `log`/`warn`/`die`/`require` functions
- [ ] Every tool: `-h` help, strict mode, exit codes, **shellcheck clean**
- [ ] `install.sh` that symlinks tools into `~/.local/bin`
- [ ] README with usage examples

Stretch: add tests with [bats](https://github.com/bats-core/bats-core) and a GitHub Actions workflow running shellcheck + bats.

---

## Option 3: Containerized application
**You prove:** containers, services, networking, backups, monitoring.

- [ ] `compose.yaml` with a web app (any language, or a ready image like a wiki/blog) + PostgreSQL/MySQL
- [ ] Data in named volumes; secrets in a `.env` file (git-ignored)
- [ ] A systemd unit that runs `docker compose up` at boot
- [ ] Nightly `pg_dump`/`mysqldump` backup via systemd timer, with rotation
- [ ] `healthcheck.sh`: curls the app, logs to journal, restarts the stack on failure
- [ ] nginx reverse proxy in front of the app
- [ ] README with architecture diagram (ASCII is fine)

Stretch: run it rootless with Podman, or deploy it with Ansible.

---

## Grading yourself
| Level | Criteria |
|---|---|
| ✅ Done | It works on your machine |
| ⭐ Good | Someone else can reproduce it from your README |
| 🏆 Hero | It's automated, secure, logged, backed up, and survives a reboot |
