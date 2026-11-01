#!/bin/bash
# Copyright (C) 2026 The r1_firmware Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Pulls the vendor blobs listed in proprietary-files.txt from a connected
# stock r1 over adb, into vendor/rabbit/r1/proprietary/.
#
# PREREQUISITE: a stock r1 with adb enabled, OR the blobs already dumped to
# a local directory (see docs/vendor-blobs.md for the mtkclient full-readback
# flow). This script only copies over adb; it does NOT perform the low-level
# extraction, which requires the physical device and mtkclient.
#
# Usage: ./extract-files.sh [path-to-dumped-vendor-root]
#   (default: pull over adb from a live device)

set -e

MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_DIR="$MY_DIR/../../vendor/rabbit/r1/proprietary"
SRC_ROOT="${1:-}"

mkdir -p "$VENDOR_DIR"

if [ -z "$SRC_ROOT" ]; then
    # Live device over adb.
    if ! command -v adb >/dev/null 2>&1; then
        echo "adb not found; install android-tools-adb" >&2
        exit 1
    fi
    adb root || true
    while IFS= read -r line; do
        case "$line" in ""|\#*|*TBD*|*---*) continue ;; esac
        dest="$VENDOR_DIR/$line"
        mkdir -p "$(dirname "$dest")"
        adb pull "/$line" "$dest"
    done < "$MY_DIR/proprietary-files.txt"
else
    # Copy from a local dump (e.g. an unpacked vendor image).
    while IFS= read -r line; do
        case "$line" in ""|\#*|*TBD*|*---*) continue ;; esac
        src="$SRC_ROOT/$line"
        dest="$VENDOR_DIR/$line"
        if [ -f "$src" ]; then
            mkdir -p "$(dirname "$dest")"
            cp "$src" "$dest"
        else
            echo "missing: $src" >&2
        fi
    done < "$MY_DIR/proprietary-files.txt"
fi

echo "Done. Run ./setup-makefiles.sh to regenerate Android.mk."