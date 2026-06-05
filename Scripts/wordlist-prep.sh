#!/usr/bin/env bash
#
# wordlist-prep.sh — clean and prepare any wordlist for WPA2 dictionary attacks.
#
# Takes one or more wordlists (plain .txt or gzipped .gz), or a whole directory,
# and produces a single cleaned file with:
#   * duplicates removed        (memory-safe sort -u, handles multi-GB files)
#   * Windows CR (\r) stripped
#   * entries shorter than 8 characters removed   (invalid for WPA2)
#   * entries longer than 63 characters removed    (WPA2 max; strips junk/HTML)
#   * lines with non-printable characters removed
#
# WPA2 passphrases are always 8-63 printable characters, so this leaves only
# candidates that could actually be a valid key.
#
# Usage:
#   ./wordlist-prep.sh [-o output.txt] [-z] <file|dir> [more files...]
#
#   -o FILE   Output filename (default: wpa2-clean.txt)
#   -z        Also write a gzipped copy (FILE.gz)
#   -h        Show this help
#
# Examples:
#   ./wordlist-prep.sh rockyou.txt
#   ./wordlist-prep.sh -o ultimate-clean.txt -z Wordlists/Ultimate2016/
#   ./wordlist-prep.sh -z list1.txt list2.txt.gz
#
# For education and authorized security testing only.

set -euo pipefail

OUT="wpa2-clean.txt"
GZIP=0

usage() { sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

# --- parse options ---
while getopts ":o:zh" opt; do
  case "$opt" in
    o) OUT="$OPTARG" ;;
    z) GZIP=1 ;;
    h) usage 0 ;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage 1 ;;
    :)  echo "Option -$OPTARG needs an argument" >&2; usage 1 ;;
  esac
done
shift $((OPTIND - 1))

if [ "$#" -eq 0 ]; then
  echo "Error: no input files or directory given." >&2
  usage 1
fi

# --- gather input files (expand directories, accept .txt and .gz) ---
INPUTS=()
for arg in "$@"; do
  if [ -d "$arg" ]; then
    while IFS= read -r f; do INPUTS+=("$f"); done \
      < <(find "$arg" -type f \( -name '*.txt' -o -name '*.gz' \) | sort)
  elif [ -f "$arg" ]; then
    INPUTS+=("$arg")
  else
    echo "Warning: skipping '$arg' (not a file or directory)" >&2
  fi
done

if [ "${#INPUTS[@]}" -eq 0 ]; then
  echo "Error: no usable .txt or .gz files found." >&2
  exit 1
fi

echo "Inputs (${#INPUTS[@]}):"
printf '  %s\n' "${INPUTS[@]}"

TMP="$(mktemp -t wlprep.XXXXXX)"
trap 'rm -f "$TMP"' EXIT

# --- combine: decompress .gz on the fly, cat .txt directly ---
: > "$TMP"
for f in "${INPUTS[@]}"; do
  case "$f" in
    *.gz) gzip -dc -- "$f" >> "$TMP" ;;
    *)    cat -- "$f"      >> "$TMP" ;;
  esac
done

RAW=$(wc -l < "$TMP" | tr -d ' ')

# --- strip CR, dedupe (memory-safe), then filter to valid WPA2 candidates ---
LC_ALL=C tr -d '\r' < "$TMP" \
  | LC_ALL=C sort -u \
  | LC_ALL=C awk 'length($0) >= 8 && length($0) <= 63 && /^[[:print:]]+$/' \
  > "$OUT"

CLEAN=$(wc -l < "$OUT" | tr -d ' ')

echo
echo "Done."
echo "  raw lines:   $RAW"
echo "  cleaned:     $CLEAN  (removed $((RAW - CLEAN)))"
echo "  output:      $OUT"

if [ "$GZIP" -eq 1 ]; then
  gzip -9 -kf -- "$OUT"
  echo "  gzipped:     ${OUT}.gz"
fi
