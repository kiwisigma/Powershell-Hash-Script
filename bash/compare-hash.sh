#!/usr/bin/env bash
# ============================================================
# compare-hash.sh
# ============================================================
# PURPOSE:
#   This script calculates a cryptographic hash of a file
#   (SHA256 by default) and optionally compares it against
#   an expected hash to verify file integrity.
#
#   This is the Linux/Bash equivalent of your PowerShell
#   hash verification script.
#
# SECURITY CONTEXT:
#   Used to verify downloads (ISOs, installers, binaries)
#   to detect corruption or tampering.
# ============================================================


# ------------------------------------------------------------
# SAFETY SETTINGS
# ------------------------------------------------------------
# -e : exit immediately if any command fails
# -u : treat unset variables as errors
# -o pipefail : fail if any command in a pipeline fails
#
# These settings prevent silent failures and are considered
# best practice in security-sensitive scripts.
set -euo pipefail


# ------------------------------------------------------------
# INPUT ARGUMENTS
# ------------------------------------------------------------
# $1 = file path to hash (required)
# $2 = hashing algorithm (optional, defaults to sha256)
# $3 = expected hash to compare against (optional)
#
# This is similar to PowerShell's `param()` block.
FILE="${1:-}"
ALGO="${2:-sha256}"
EXPECTED="${3:-}"


# ------------------------------------------------------------
# INPUT VALIDATION
# ------------------------------------------------------------
# If no file was provided, print usage instructions and exit.
# This prevents running the script with invalid input.
if [[ -z "$FILE" ]]; then
  echo "Usage: $0 <file> [algorithm] [expected_hash]"
  exit 2
fi

# Check that the file actually exists on disk.
# This prevents hashing a non-existent path.
if [[ ! -f "$FILE" ]]; then
  echo "File not found: $FILE"
  exit 2
fi


# ------------------------------------------------------------
# HASH ALGORITHM SELECTION
# ------------------------------------------------------------
# Bash does not have a single built-in hash function like
# PowerShell's Get-FileHash, so we map algorithms to
# Linux utilities instead.
#
# This `case` statement ensures only supported algorithms
# are allowed.
case "$ALGO" in
  sha256) CMD="sha256sum" ;;
  sha1)   CMD="sha1sum" ;;
  sha384) CMD="sha384sum" ;;
  sha512) CMD="sha512sum" ;;
  md5)    CMD="md5sum" ;;
  *)
    echo "Unsupported algorithm: $ALGO"
    echo "Supported: sha256, sha1, sha384, sha512, md5"
    exit 2
    ;;
esac


# ------------------------------------------------------------
# HASH CALCULATION
# ------------------------------------------------------------
# Example output of sha256sum:
#   HASHVALUE  filename
#
# We use `awk '{print $1}'` to extract ONLY the hash value,
# ignoring the filename.
ACTUAL="$($CMD "$FILE" | awk '{print $1}')"


# ------------------------------------------------------------
# DISPLAY COMPUTED RESULTS
# ------------------------------------------------------------
# This mirrors the PowerShell script output:
# - file name
# - algorithm used
# - computed hash
echo
echo "File:      $FILE"
echo "Algorithm: $ALGO"
echo "Actual:    $ACTUAL"


# ------------------------------------------------------------
# GUARD: EXPECTED HASH NOT PROVIDED
# ------------------------------------------------------------
# If the user did not provide an expected hash, we stop here.
# This avoids false mismatch results and mirrors your
# PowerShell safety check.
if [[ -z "$EXPECTED" ]]; then
  echo
  echo "No expected hash provided. Computed hash shown above."
  exit 0
fi


# ------------------------------------------------------------
# HASH NORMALIZATION
# ------------------------------------------------------------
# Hashes may be copied with:
# - spaces
# - newlines
# - uppercase or lowercase letters
#
# To prevent false mismatches, we:
# - remove whitespace
# - convert both hashes to lowercase
EXPECTED_NORM="$(echo "$EXPECTED" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
ACTUAL_NORM="$(echo "$ACTUAL"   | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"

echo "Expected:  $EXPECTED"


# ------------------------------------------------------------
# HASH COMPARISON
# ------------------------------------------------------------
# If the normalized hashes match, the file integrity is verified.
# If they differ, the file may be corrupted or tampered with.
if [[ "$ACTUAL_NORM" == "$EXPECTED_NORM" ]]; then
  echo
  echo "The hash values match"
  exit 0
else
  echo
  echo "The hash values do not match"
  exit 1
fi
