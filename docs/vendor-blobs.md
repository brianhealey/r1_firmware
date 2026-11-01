# Special binaries & configuration — inventory and justification

Every proprietary or prebuilt artifact the build needs, how it is obtained, and
why it is acceptable. Nothing is copied from community repos; blobs are
extracted from a stock device or obtained from the vendor where possible.

## 1. Vendor blobs (proprietary HALs and firmware)

**What:** MediaTek and r1-specific proprietary libraries — graphics/GPU
(Mali-G72 for MT6765), camera, audio DSP, connectivity (WiFi/BT MT6631N),
telephony/RF (MT6177W), and the r1's custom peripherals (stepper motor for the
rotating camera, scroll wheel).

**Obtained from:** a stock r1 via a full `mtkclient` readback, then mapped into
`vendor/rabbit/r1` using `extract-files.sh` (the community tree lists
`proprietary-files.txt` as a starting inventory).

**Justification:** These HALs are closed-source and required for hardware to
function; there is no open replacement for most MediaTek/InvenSense/Awinic
firmware. Extracting them from the user's own device is the standard, legal
approach used by every custom ROM project.

## 2. Kernel

**What:** MT6765 kernel source (4.14/4.19) plus an r1-specific defconfig and
device tree.

**Obtained from:** MediaTek's published MT6765 kernel source (upstream) where
available; the r1-specific board config must be reconstructed or requested from
rabbit.

**Justification:** The kernel is GPL and open source; only the *r1 board
specifics* are missing, which is a bring-up task, not a proprietary blob.

## 3. Bootloader / preloader

**What:** The r1's preloader and bootloader binaries.

**Obtained from:** the stock device (already present; unlocked via the official
flow). Not rebuilt from scratch — the existing bootloader is reused.

**Justification:** Rebuilding/relocking a bootloader is out of scope and risky;
the device's bootloader is already unlockable and supports the needed flash
path.

## 4. vbmeta / AVB keys

**What:** Verified Boot metadata.

**Obtained from:** stock device; AVB is **disabled** (or vbmeta re-signed) for a
custom image, matching the community's proven approach.

**Justification:** Re-signing or disabling AVB is required to boot a non-stock
system image; it is a standard, documented step.

## 5. Prebuilt firmware images (reference / restore)

**What:** a full stock backup image.

**Obtained from:** the user's own device via `mtkclient` full readback.

**Justification:** kept only as a **restore-to-stock safety net**, never
redistributed. This is the single most important artifact for safe
experimentation.

## Policy

- Each blob is recorded in the repo's `vendor/rabbit/r1` tree with a
  `proprietary-files.txt` manifest.
- Blobs are **not committed as binaries** into git where avoidable; the
  extraction procedure is committed instead, and the blobs are produced on the
  build host.
- Any prebuilt image committed to the repo must carry a
  `docs/vendor-blobs.md` entry explaining its source and justification.