#!/usr/bin/env bash
#
# script-template.sh: starting point for new scripts.
# Copy it, rename it, and replace the main() body.
#
# Usage: ./script-template.sh [-v] [-n] [-h] ARG...

set -euo pipefail
IFS=$'\n\t'

SCRIPT_NAME="$(basename "$0")"
VERBOSE=false
DRY_RUN=false

RED='\e[31m'; YELLOW='\e[33m'; GREEN='\e[32m'; NC='\e[0m'

log()   { echo -e "$(date '+%F %T') ${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "$(date '+%F %T') ${YELLOW}[WARN]${NC}  $*" >&2; }
die()   { echo -e "$(date '+%F %T') ${RED}[ERROR]${NC} $*" >&2; exit 1; }
debug() { if [[ "$VERBOSE" == true ]]; then echo "[DEBUG] $*" >&2; fi; }

# Run a command, or only print it in dry-run mode
run() {
    if [[ "$DRY_RUN" == true ]]; then
        local IFS=" "
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [options] ARG...

Options:
  -v    verbose output
  -n    dry run (print commands, change nothing)
  -h    show this help
EOF
}

cleanup() {
    # remove temp files etc.
    if [[ -n "${TMP_DIR:-}" && -d "$TMP_DIR" ]]; then rm -rf "$TMP_DIR"; fi
}
trap cleanup EXIT
trap 'die "failed at line $LINENO"' ERR

parse_args() {
    while getopts ":vnh" opt; do
        case "$opt" in
            v) VERBOSE=true ;;
            n) DRY_RUN=true ;;
            h) usage; exit 0 ;;
            \?) usage >&2; die "unknown option: -$OPTARG" ;;
        esac
    done
    shift $((OPTIND - 1))
    ARGS=("$@")
}

main() {
    parse_args "$@"
    TMP_DIR="$(mktemp -d)"
    debug "temp dir: $TMP_DIR"

    if [[ ${#ARGS[@]} -eq 0 ]]; then
        usage >&2
        exit 1
    fi

    for arg in "${ARGS[@]}"; do
        log "processing: $arg"
        run touch "$TMP_DIR/$(basename "$arg")"
    done

    log "done"
}

main "$@"
