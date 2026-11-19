#!/usr/bin/env bash
#
# generate-log.sh: creates a fake web server access log for the Week 4 exercises.
# Usage: ./generate-log.sh [LINES] [OUTPUT_FILE]
#   default: 1000 lines → sample-access.log (next to this script)

set -euo pipefail

lines="${1:-1000}"
out="${2:-$(dirname "$0")/sample-access.log}"

ips=(10.0.0.5 10.0.0.5 10.0.0.5 192.168.1.20 192.168.1.20 172.16.4.2 203.0.113.9 198.51.100.7 10.0.0.12 192.168.1.33)
methods=(GET GET GET GET POST POST PUT DELETE)
paths=(/ /index.html /login /api/users /api/users/42 /api/orders /static/app.js /static/style.css /admin /favicon.ico)
codes=(200 200 200 200 200 200 301 304 401 403 404 404 500 502)
agents=("Mozilla/5.0" "curl/8.5.0" "python-requests/2.31" "Googlebot/2.1")

: > "$out"
start=$(date -u -d "2026-11-01 00:00:00" +%s 2>/dev/null || echo 1793491200)

for (( i=0; i<lines; i++ )); do
    ts=$(( start + i * 37 ))
    when=$(date -u -d "@$ts" '+%d/%b/%Y:%H:%M:%S +0000' 2>/dev/null || date -u -r "$ts" '+%d/%b/%Y:%H:%M:%S +0000')
    ip=${ips[RANDOM % ${#ips[@]}]}
    m=${methods[RANDOM % ${#methods[@]}]}
    p=${paths[RANDOM % ${#paths[@]}]}
    c=${codes[RANDOM % ${#codes[@]}]}
    a=${agents[RANDOM % ${#agents[@]}]}
    size=$(( RANDOM % 5000 + 100 ))
    printf '%s - - [%s] "%s %s HTTP/1.1" %s %s "-" "%s"\n' "$ip" "$when" "$m" "$p" "$c" "$size" "$a" >> "$out"
done

echo "Wrote $lines lines to $out"
