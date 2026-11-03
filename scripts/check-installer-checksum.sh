#!/usr/bin/env bash
# Verify the sha256 pinned in bin/install-tools matches the pinned aqua-installer URL.
# Renovate bumps only the URL version, so a stale hash must fail CI before automerge.
set -euo pipefail

file="$(cd "$(dirname "$0")/.." && pwd)/bin/install-tools"
url="$(grep -oE 'https://raw\.githubusercontent\.com/aquaproj/aqua-installer/v[0-9.]+/aqua-installer' "$file" | head -1)"
expected="$(grep -oE '[0-9a-f]{64}' "$file" | head -1)"

if [ -z "$url" ] || [ -z "$expected" ]; then
    echo "ERROR: could not find aqua-installer URL or sha256 in $file" >&2
    exit 1
fi

actual="$(curl -sSfL "$url" | sha256sum | cut -d' ' -f1)"
if [ "$expected" != "$actual" ]; then
    echo "ERROR: aqua-installer checksum mismatch" >&2
    echo "  url:      $url" >&2
    echo "  expected: $expected" >&2
    echo "  actual:   $actual" >&2
    exit 1
fi
echo "OK: aqua-installer checksum matches ($url)"
