# PLAN — r1_firmware

Roadmap for building Android firmware for the rabbit r1 from scratch. This is a
living document; update it as workstreams land.

## 1. Goal

A from-scratch Android build for the rabbit r1 that:

1. Boots on real r1 hardware.
2. Is **aware of the r1's small screen** — every surface is designed to fit a
   ~2.88" display rather than scaled-down phone UI.
3. Is reproducible from this repository (manifest, device tree, kernel config,
   vendor-blob extraction, build and flash scripts).

Reference-only prior art may inform design but is never copied directly.

## 2. Architecture

The r1 is a MediaTek MT6765V (Helio P35) device running Android 13 (AOSP) with
a Flutter-based "Rabbit OS" app on top. A from-scratch build therefore has these
layers:

```
┌─────────────────────────────────────────────┐
│  Launcher / small-screen UI (our design)     │
├─────────────────────────────────────────────┤
│  AOSP system image (chosen Android release)  │
├─────────────────────────────────────────────┤
│  Device tree (device/rabbit/r1)              │
├─────────────────────────────────────────────┤
│  Kernel (MT6765 / 4.14–4.19)                 │
├─────────────────────────────────────────────┤
│  Vendor blobs (proprietary HALs, firmware)   │
├─────────────────────────────────────────────┤
│  Bootloader (unlocked) + A/B partitions      │
└─────────────────────────────────────────────┘
```

The device uses **A/B partitions** (`AB_OTA_UPDATER`), **system-as-root** with
**recovery-as-boot**, and AVB (vbmeta / vbmeta_system / vbmeta_vendor). Any
build must respect this layout.

## 3. Workstreams

Each workstream is independently parallelizable where noted. Dependencies are
listed per workstream.

### W1 — Hardware & bootloader confirmation (mostly done, see docs/hardware.md)
- Confirm SoC, RAM/storage, display resolution, partition layout, unlock state.
- **Dependencies:** none. **Status:** research done; display resolution and
  exact RAM/storage variant still to confirm on-device.

### W2 — Android base & manifest (docs/android-base.md)
- Pick the Android release and AOSP/LineageOS manifest.
- Produce a repo manifest + build skeleton.
- **Dependencies:** W1 (SoC). **Status:** recommendation written; manifest
  skeleton next.

### W3 — Device tree & kernel
- `device/rabbit/r1` tree (BoardConfig, overlays, keylayout, sepolicy).
- Kernel: MediaTek MT6765 kernel source + r1-specific defconfig.
- **Dependencies:** W1, W2. **Status:** not started. **Blocker risk:** no public
  r1-specific kernel source or device tree from rabbit (see §6).

### W4 — Vendor blob extraction & integration
- Extract proprietary HALs/firmware from a stock r1 (via `mtkclient` backup).
- Justify each blob (docs/vendor-blobs.md).
- **Dependencies:** W1 (a real device is needed). **Status:** inventory written.

### W5 — Small-screen UI / launcher design
- Design a launcher and system UI sized for the 2.88" screen (typography, touch
  targets, info density, portrait orientation).
- **Dependencies:** W1 (exact resolution). **Status:** approach written (§7).

### W6 — Build & flash tooling
- Build scripts, flash scripts (fastboot / mtkclient), and a restore-to-stock
  path.
- **Dependencies:** W2–W4 outputs. **Status:** not started.

## 4. Build host requirements

AOSP builds need a Linux x86_64 host with substantial resources. Recommended
target in the user's homelab:

- **`bigpc`** (Proxmox VE host, 32 cores / 126 GB RAM) — provision an Ubuntu
  22.04/24.04 LTS VM or LXC with ≥ 32 GB RAM and ≥ 400 GB free disk (AOSP
  checkout + ccache + out/).
- The Mac mini (`mini.heeheesoftware.com`) is **not** suitable for a full AOSP
  build (macOS is unsupported by AOSP's build system); it is fine for repo
  management, docs, and small tooling.

## 5. Build & flash path

1. `repo init` the chosen manifest; `repo sync`.
2. Add `device/rabbit/r1`, kernel, and vendor trees.
3. `lunch gsi_r1-userdebug` (or equivalent product); `m`.
4. Flash via fastboot (bootloader is unlockable), or via `mtkclient` for
   lower-level partition writes.
5. **Restore path:** keep a stock backup (`mtkclient` full readback) so the
   device can always be returned to stock.

## 6. Known blockers (honest assessment)

- **No public r1-specific kernel source / device tree from rabbit.** The
  community GSI tree (`RabbitHoleEscapeR1/device_rabbit_r1`) is a starting
  point, not a complete board bring-up. A full "from scratch" kernel needs
  either rabbit's release or significant reverse-engineering.
- **Vendor blobs are proprietary** and must be extracted from a stock device
  (the user owns an r1, so this is feasible but must be done carefully and
  justified).
- **Android version ceiling.** MT6765 is a 2018 SoC whose mainline kernel
  support is 4.14/4.19. "Latest Android" is realistically **Android 13
  (LineageOS 20)** for a full build; newer GSIs may boot against the stock
  vendor/kernel but are not a from-scratch build.

A correct, well-documented plan with a real build skeleton is a legitimate
milestone while a bootable image is not yet possible. No progress is fabricated.

## 7. Small-screen design approach

The r1's ~2.88" display is the defining constraint. Design principles:

- **Portrait-first**, single-column layout; no phone-style multi-pane UI.
- **Large touch targets** (≥ 48 dp) despite the small physical size.
- **Minimal information density** — one primary action per screen; secondary
  actions behind a scroll wheel / long-press.
- **Custom launcher** replacing the stock AOSP launcher, with a scroll-wheel
  driven card UI matching the r1's physical controls.
- **System UI tuning** via framework overlays: font scale, icon density, status
  bar, navigation; target the confirmed resolution/density once measured on
  device.

Exact resolution and density must be read from a real device
(`adb shell wm size`, `adb shell wm density`) before finalizing layouts.