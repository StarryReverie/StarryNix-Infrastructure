#!/usr/bin/env bash
 
# Clipboard selector
# 
# Usage:
# 
#     clipboard-select [--copy] [selector [args...]]
# 
# Examples:
# 
#     clipboard-select fzf
#     clipboard-select --copy rofi -dmenu
#
# Behavior summary:
# 
# - The default selector is fzf.
# - Shows only the <content> to the selector (no index visible).
# - If cliphist has no entries, the selector is invoked with one entry:
#   "No clipboard history entries"
#   Whatever the selector returns in that case, nothing is copied and
#   the error message is printed to stderr; exit status is non‑zero.
# - Otherwise, the chosen raw "<index>\t<content>" line is piped to
#   `cliphist decode`. The decoded bytes are always printed to stdout.
#   If --copy is given, the decoded bytes are also sent to wl-copy
#   (stdout and clipboard will be identical).

set -euo pipefail

ERROR_MSG="No clipboard history entries"
copy_enabled=0
selector_cmd=()

# Parse args: --copy is consumed, everything else is treated as selector command/args
while (( $# )); do
    case "$1" in
        --copy) copy_enabled=1; shift ;;
        --) shift; selector_cmd+=( "$@" ); break ;;
        *)
            selector_cmd+=( "$1" )
            shift
            ;;
    esac
done

if [ ${#selector_cmd[@]} -eq 0 ]; then
    selector_cmd=(fzf)
fi

command -v cliphist >/dev/null 2>&1 || { echo "cliphist not found" >&2; exit 2; }

# Read raw cliphist lines (each: index<TAB>content)
mapfile -t raw_lines < <(cliphist list)

# If no entries, still call selector with single error message,
# then print error to stderr and exit non-zero without copying.
if [ "${#raw_lines[@]}" -eq 0 ]; then
    # Call selector with the single error message as the only choice.
    # Ignore its output; always print the error to stderr and exit 1.
    # Don't check for wl-copy here because nothing will be copied.
    if ! printf '%s\n' "$ERROR_MSG" | "${selector_cmd[@]}" >/dev/null 2>&1; then
        :    # selector cancelled/failed; still behave the same
    fi
    printf '%s\n' "$ERROR_MSG" >&2
    exit 1
fi

# Build the visible contents (no indices)
displays=()
for ln in "${raw_lines[@]}"; do
    if [[ "$ln" == *$'\t'* ]]; then
        displays+=( "${ln#*$'\t'}" )
    else
        displays+=( "$ln" )
    fi
done

# If copying is requested, ensure wl-copy exists (only needed in that case)
if [ "$copy_enabled" -eq 1 ]; then
    command -v wl-copy >/dev/null 2>&1 || { echo "wl-copy not found" >&2; exit 2; }
fi

# Run selector with only the content shown
selected=""
if ! selected=$(printf '%s\n' "${displays[@]}" | "${selector_cmd[@]}"); then
    # selector cancelled or failed
    exit 1
fi

# empty selection -> exit
[ -n "$selected" ] || exit 1

# Map selected content back to the original raw line (first match)
chosen_raw=""
for i in "${!displays[@]}"; do
    if [ "${displays[i]}" = "$selected" ]; then
        chosen_raw="${raw_lines[i]}"
        break
    fi
done

if [ -z "$chosen_raw" ]; then
    echo "failed to map selection back to cliphist entry" >&2
    exit 2
fi

# Decode and print decoded bytes to stdout always.
# If --copy was given, also send decoded bytes to wl-copy so stdout == clipboard.
if [ "$copy_enabled" -eq 1 ]; then
    # tee duplicates decoded bytes to wl-copy and stdout
    printf '%s\n' "$chosen_raw" | cliphist decode | wl-copy
else
    # just print decoded bytes to stdout
    printf '%s\n' "$chosen_raw" | cliphist decode
fi

exit 0
