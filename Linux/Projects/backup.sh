#!/usr/bin/env bash
#
# backup.sh: reference solution for the Week 8 mini-project.
# Creates timestamped, compressed backups and keeps only the newest N.
#
# Usage: ./backup.sh -s SOURCE -d DEST [-k KEEP] [-n] [-v] [-h]

set -euo pipefail

SRC=""
DEST=""
KEEP=7
DRY_RUN=false
VERBOSE=false
LOG_FILE=""

log()  { local m; m="$(date '+%F %T') [INFO]  $*"; echo "$m"; [[ -n "$LOG_FILE" ]] && echo "$m" >> "$LOG_FILE"; return 0; }
die()  { echo "$(date '+%F %T') [ERROR] $*" >&2; exit 1; }
vlog() { if [[ "$VERBOSE" == true ]]; then log "$@"; fi; }

usage() {
    cat <<EOF
Usage: $(basename "$0") -s SOURCE -d DEST [-k KEEP] [-n] [-v] [-h]

  -s SOURCE   directory to back up
  -d DEST     directory to store backups in
  -k KEEP     number of backups to keep (default: $KEEP)
  -n          dry run
  -v          verbose
  -h          help

Example (cron, daily at 02:00):
  0 2 * * * /path/to/backup.sh -s \$HOME/docs -d /mnt/backup -k 14
EOF
}

while getopts ":s:d:k:nvh" opt; do
    case "$opt" in
        s) SRC="$OPTARG" ;;
        d) DEST="$OPTARG" ;;
        k) KEEP="$OPTARG" ;;
        n) DRY_RUN=true ;;
        v) VERBOSE=true ;;
        h) usage; exit 0 ;;
        :) die "option -$OPTARG requires a value" ;;
        \?) usage >&2; die "unknown option -$OPTARG" ;;
    esac
done

[[ -n "$SRC" && -n "$DEST" ]] || { usage >&2; exit 1; }
[[ -d "$SRC" ]] || die "source '$SRC' is not a directory"
[[ "$KEEP" =~ ^[0-9]+$ && "$KEEP" -ge 1 ]] || die "KEEP must be a positive integer"
command -v tar >/dev/null || die "tar is required"

mkdir -p "$DEST"
LOG_FILE="$DEST/backup.log"

name="$(basename "$(realpath "$SRC")")"
stamp="$(date '+%Y%m%d-%H%M%S')"
archive="$DEST/${name}-${stamp}.tar.gz"
tmp="$archive.partial"

trap 'rm -f "$tmp"' EXIT

log "backing up $SRC → $archive"
if [[ "$DRY_RUN" == true ]]; then
    log "[dry-run] tar -czf $archive -C $(dirname "$(realpath "$SRC")") $name"
else
    tar -czf "$tmp" -C "$(dirname "$(realpath "$SRC")")" "$name"
    mv "$tmp" "$archive"
    log "created $(du -h "$archive" | cut -f1) archive"
fi

# Rotation: list backups newest first, delete everything after KEEP
mapfile -t old < <(ls -1t "$DEST/${name}-"*.tar.gz 2>/dev/null | tail -n +"$((KEEP + 1))")
for f in "${old[@]}"; do
    if [[ "$DRY_RUN" == true ]]; then
        log "[dry-run] would delete $f"
    else
        rm -f -- "$f"
        vlog "deleted old backup $f"
    fi
done

log "done (keeping newest $KEEP)"
