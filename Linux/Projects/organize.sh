#!/usr/bin/env bash
#
# organize.sh: reference solution for the Week 7 mini-project.
# Sorts files in a directory into subfolders by extension.
#
# Usage: ./organize.sh [-n] DIR
#   -n  dry run (show what would move)

set -euo pipefail

dry_run=false
if [[ "${1:-}" == "-n" ]]; then dry_run=true; shift; fi

dir="${1:-}"
if [[ -z "$dir" || ! -d "$dir" ]]; then
    echo "Usage: $0 [-n] DIR" >&2
    exit 1
fi

declare -A counts=()

category_for() {
    local ext="${1,,}"   # lowercase
    case "$ext" in
        jpg|jpeg|png|gif|webp|svg)   echo images ;;
        pdf|doc|docx|txt|md|odt|xlsx) echo docs ;;
        zip|tar|gz|tgz|xz|zst|7z|rar) echo archives ;;
        mp3|wav|flac|ogg)             echo audio ;;
        mp4|mkv|mov|webm)             echo video ;;
        *)                            echo other ;;
    esac
}

for path in "$dir"/*; do
    [[ -f "$path" ]] || continue             # skip directories
    name="$(basename "$path")"
    if [[ "$name" == *.* ]]; then ext="${name##*.}"; else ext=""; fi
    cat="$(category_for "$ext")"

    if [[ "$dry_run" == true ]]; then
        echo "would move: $name → $cat/"
    else
        mkdir -p "$dir/$cat"
        mv -n -- "$path" "$dir/$cat/"
    fi
    counts[$cat]=$(( ${counts[$cat]:-0} + 1 ))
done

echo "Summary:"
if [[ ${#counts[@]} -eq 0 ]]; then
    echo "  no files to organize"
else
    for c in "${!counts[@]}"; do
        printf "  %-10s %d\n" "$c" "${counts[$c]}"
    done | sort
fi
