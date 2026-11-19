# Week 10: Networking and SSH

## Goals
- Understand IP addresses, ports, DNS, routing at a practical level
- Diagnose network problems with standard tools
- Use SSH like a pro: keys, config, tunnels, file transfer
- Configure a basic firewall

---

## Day 1: Networking fundamentals
| Concept | Quick explanation |
|---|---|
| IP address | Host address. IPv4 `192.168.1.10`, IPv6 `fe80::1` |
| CIDR / subnet | `192.168.1.0/24` = 256 addresses, 192.168.1.0–255 |
| Private ranges | `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` |
| Gateway | Router that forwards traffic out of your subnet |
| DNS | Turns names into IPs |
| Port | Which service on a host: 22 SSH, 80 HTTP, 443 HTTPS, 53 DNS, 5432 Postgres |
| TCP vs UDP | Reliable connection vs fast fire-and-forget |
| localhost | `127.0.0.1`, this machine |

## Day 2: Inspecting your network
```bash
ip a                     # interfaces + IPs (replaces ifconfig)
ip r                     # routing table / default gateway
ip link                  # interface state
nmcli device status      # NetworkManager
cat /etc/resolv.conf     # DNS servers
cat /etc/hosts           # static name overrides
hostname -I
```

## Day 3: Diagnosing problems (work bottom-up)
```bash
ping -c 4 8.8.8.8            # 1. Can I reach the internet by IP?
ping -c 4 google.com         # 2. Does DNS work?
dig google.com               # DNS lookup details (or: nslookup, host)
dig +short MX gmail.com
traceroute google.com        # path packets take (or: mtr, tracepath)
ss -tulpn                    # listening ports + processes (replaces netstat)
ss -tn state established     # active connections
nc -zv example.com 443       # is a port open?
curl -I https://example.com  # HTTP headers
curl -v https://example.com  # verbose: TLS, headers, everything
wget https://example.com/file.zip
sudo tcpdump -i any port 53  # sniff packets (advanced)
```
Troubleshooting order: **link → IP → gateway → DNS → port → application**.

## Day 4: SSH basics and keys
```bash
ssh user@server
ssh -p 2222 user@server

ssh-keygen -t ed25519 -C "you@laptop"    # create a key pair
ssh-copy-id user@server                  # install public key on server
ssh user@server                          # no password needed now
```
- `~/.ssh/id_ed25519` = **private** key (never share, `chmod 600`)
- `~/.ssh/id_ed25519.pub` = public key (goes into the server's `~/.ssh/authorized_keys`)

`~/.ssh/config` saves typing:
```
Host myvps
    HostName 203.0.113.10
    User deploy
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
```
Now just `ssh myvps`.

## Day 5: File transfer and tunnels
```bash
scp file.txt myvps:/tmp/
scp -r myvps:/var/log/nginx ./logs
rsync -avz --progress ./site/ myvps:/var/www/site/   # sync only changes
rsync -avz --delete src/ dest/                       # mirror (careful!)

ssh -L 8080:localhost:80 myvps     # local forward: your :8080 → server's :80
ssh -R 9000:localhost:3000 myvps   # remote forward: server :9000 → your :3000
ssh -D 1080 myvps                  # SOCKS proxy
ssh -J jumphost internal-server    # hop through a bastion
```

## Day 6: Hardening SSH and firewall
`/etc/ssh/sshd_config` (then `sudo systemctl restart sshd`):
```
PermitRootLogin no
PasswordAuthentication no      # only after confirming key login works!
PubkeyAuthentication yes
```
Firewall with **ufw** (Ubuntu) or **firewalld** (Fedora):
```bash
sudo ufw allow OpenSSH
sudo ufw allow 80,443/tcp
sudo ufw enable
sudo ufw status verbose

sudo firewall-cmd --add-service=http --permanent && sudo firewall-cmd --reload
```
Add **fail2ban** to block brute-force attempts.

## Day 7: Review + finish Bandit (levels 26–33)

---

## Exercises
1. Find your IP, gateway, and DNS server.
2. List every listening port on your machine and the process behind each.
3. Use `dig` to find the A, MX, and NS records of a domain you use.
4. Set up key-based SSH to a VM or server; disable password login; confirm passwords are rejected.
5. Create an `~/.ssh/config` entry and use `rsync` to deploy a folder through it.
6. Use a local port forward to access a web service bound only to `127.0.0.1` on a remote machine.
7. Run `python3 -m http.server 8000`, then access it from another machine and close it with a firewall rule.

## Mini-project: Deploy a static website
On a VM or cloud server: install nginx, open ports 80/443 in the firewall, `rsync` an `index.html` to `/var/www/html`,
and reach it from your browser. Bonus: point a domain at it and add HTTPS with `certbot`.

## Checkpoint
- [ ] Walk through debugging "the website is down" layer by layer
- [ ] What does `/24` mean?
- [ ] Generate, install and use SSH keys
- [ ] Local vs remote port forwarding
- [ ] Which command shows what's listening on a port?
