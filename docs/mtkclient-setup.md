# mtkclient setup — rabbit r1 vendor extraction (macOS)

> **Status: procedure documented, not yet executed.** The physical r1 is not
> connected yet; no device has been read or flashed. This page records the
> tooling and the exact steps to run once the r1 is attached. See
> [`docs/vendor-blobs.md`](vendor-blobs.md) for *why* the blobs are needed.

## 1. What is installed and where

`mtkclient` is installed on the Mac mini (`mini.heeheesoftware.com`, Apple
Silicon / arm64) from the official repository:

- **Repo:** <https://github.com/bkerler/mtkclient>, checked out at tag
  **`v2.1.4.1`** (project version string **2.1.4**).
- **Location:** `~/mtkclient`, with a dedicated virtualenv at
  `~/mtkclient/mtk_venv` (Homebrew Python 3.12, arm64).
- **Install method:** `git clone` + `pip install -r requirements.txt` +
  `pip install .` — the supported path from the project's `README-INSTALL.md`.
  Native dependencies were built from source on arm64: `capstone` 6.0.0a11
  (`--no-binary`), `keystone-engine` 0.9.2, `unicorn` 2.1.4. Also `pyusb`
  1.3.1, `pyserial` 3.5, `pyside6` 6.12.0, `fusepy` 3.0.1.
- **CLI entry point:** `mtk` (there is no `mtkclient` command). Verified:
  `mtk --help` exits 0 and prints `MTK Flash/Exploit Client V2.1.4`.

## 2. macOS specifics

### USB (libusb / pyusb) — resolved

The USB path needs `libusb` + `pyusb`:

- `libusb` installed via Homebrew (`brew install libusb`; keg-only at
  `/opt/homebrew/opt/libusb`).
- `pyusb` 1.3.1 installed in the venv (an mtkclient dependency).

Verified on this Mac that pyusb's `libusb1` backend loads and finds the
Homebrew libusb with **no extra environment variables**. The r1 will enumerate
as **MediaTek PreLoader USB VCOM** (`VID:PID 0E8D:2000`) in preloader mode, or
`0E8D:0003` in BROM mode.

### FUSE (macFUSE) — worked around for readback/printgpt

mtkclient imports `fuse` (fusepy) unconditionally, and fusepy raises unless it
can load a `libfuse` dylib. On macOS that normally means installing macFUSE
(`brew install --cask macfuse`), which requires **sudo + a System Settings
kernel-extension approval + a reboot** — a manual step.

For this prep we vendor the macFUSE 5.5.0 `libfuse.2.dylib` and its
`MFMount.framework` dependency under `~/mtkclient/libfuse/`, and point fusepy
at them via `FUSE_LIBRARY_PATH` and `DYLD_FRAMEWORK_PATH`. This satisfies the
import so `mtk` runs for **readback / printgpt** (which never touch FUSE).

- **Not covered by the workaround:** the optional `mtk fs <mountpoint>` feature
  (mounting flash as a filesystem) still needs the full macFUSE kernel
  extension. It is **not** part of the vendor-extraction path below.

### Launcher

A wrapper sets the two FUSE variables and runs the venv's `mtk`:

```bash
~/mtkclient/run-mtk.sh <args...>
```

(equivalent to `~/mtkclient/mtk_venv/bin/mtk` with those variables exported).

## 3. Entering preloader / BROM mode on the r1

The r1 has **no volume buttons** — a single side (push-to-talk) button and a
scroll wheel. The community `r1_escape` flow therefore does **not** use a
button combo; it uses the **MediaTek preloader**, which enumerates when the
device is powered off and connected over USB.

**Preloader mode (what `r1_escape` uses — the primary path):**

1. Power the r1 **fully off**.
2. Connect it to the Mac with a USB cable.
3. The preloader enumerates as **MediaTek PreLoader USB VCOM**
   (`VID:PID 0E8D:2000`). mtkclient auto-detects it and performs the preloader
   handshake — the r1's preloader is not patched, so no BROM exploit is needed
   for read/write.

**BROM (bootrom) mode — TBD, not needed for the primary path:**

The generic MediaTek BROM entry is "power off, hold a volume key + power,
connect USB", but the r1 has no volume keys, and no authoritative r1-specific
BROM button sequence was found in the community sources reviewed. If BROM is
ever required (e.g. a corrupted preloader), the sequence must be confirmed on
the device before use — do not assume one.

## 4. Extraction procedure (not yet executed)

Run from `~/mtkclient`, with the r1 in preloader mode (§3).

1. **Confirm the device is seen and read the partition map:**
   ```bash
   ./run-mtk.sh printgpt
   ```
   Prints the GPT. Expected A/B layout: `boot`, `dtbo`, `product`, `system`,
   `vbmeta` / `vbmeta_system` / `vbmeta_vendor`, `vendor`, etc.

2. **Read back the vendor partition** (and, recommended, a full backup):
   ```bash
   # vendor only
   ./run-mtk.sh r vendor vendor.img
   # or dump every partition into out/
   ./run-mtk.sh rl out
   # or a full-flash image (restore-to-stock safety net)
   ./run-mtk.sh rf flash.bin
   ```
   On the r1 the preloader path is used, so no `--preloader` / `--loader`
   argument is expected; add `--preloader <file>` only if the tool falls back
   to BROM.

3. **Unpack the vendor image.** The dump is the raw partition. Check it first:
   ```bash
   file vendor.img
   ```
   - If it reports **"Android sparse image"**, convert to a raw ext4 image with
     `simg2img` (from `android-platform-tools`) before mounting.
   - Otherwise mount the ext4 filesystem directly and copy the HALs/firmware
     out (GPU/Mali-G72, camera, audio DSP, WiFi/BT `MT6631N`, sensors, etc.).

4. **Map blobs into `vendor/rabbit/r1`** using the community
   `extract-files.sh` from `RabbitHoleEscapeR1/device_rabbit_r1` as the
   starting inventory (see [`docs/vendor-blobs.md`](vendor-blobs.md)). Note the
   community `extract-files.sh` is written to `adb pull` from a *booted*
   device; for a from-scratch extraction from the dumped image, adapt it to
   copy from the mounted vendor filesystem instead.

## 5. macOS caveat / Linux fallback

macOS is a documented-supported mtkclient host, and the USB + FUSE-import
requirements above are resolved. If a full readback over USB proves unreliable
on macOS (an occasional known issue with MediaTek VCOM on macOS), the fallback
is to run the same commands from a Linux node in the homelab (mtkclient's
primary platform): install there with the same `git clone` + venv + udev-rules
flow, and copy the dumped images back.