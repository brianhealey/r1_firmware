# Special binaries & configuration — inventory, sourcing, and justification

Every proprietary or prebuilt artifact the build needs, how it is obtained, and
why it is acceptable. Nothing is copied from community repos; blobs are either
sourced from a LineageOS-style vendor tree (with attribution) or extracted from
a stock device.

## Sourcing policy (updated)

Two routes are acceptable, in priority order:

1. **LineageOS-style vendor tree** — the community
   [`RabbitHoleEscapeR1/vendor_rabbit_r1`](https://github.com/RabbitHoleEscapeR1/vendor_rabbit_r1)
   tree carries a **subset** of the r1's vendor blobs (MediaTek
   telephony/IMS/vcodec JARs and `.so`s, the `kpoc_charger` and `vtservice`
   binaries, the IMS service APK). These are the blobs the community needed to
   run a GSI on top of the stock vendor partition. They are **reference-only**
   and cover the telephony/IMS surface, **not** the full vendor set.
2. **Physical extraction** — the **complete** vendor set (GPU/Mali-G72,
   camera, audio DSP, WiFi/BT MT6631N firmware, TDK InvenSense sensors, and
   the r1-specific peripherals) must be pulled from a stock r1. This is the
   only route to a full from-scratch build.

The full vendor set is therefore still **gated on the user's physical r1**.
The LineageOS blobs unblock the telephony/IMS subset now; they do not replace
device extraction for the rest.

## 1. Vendor blobs (proprietary HALs and firmware)

**What:** MediaTek and r1-specific proprietary libraries — graphics/GPU
(Mali-G72 for MT6765), camera, audio DSP, connectivity (WiFi/BT MT6631N),
telephony/RF (MT6177W), and the r1's custom peripherals (stepper motor for the
rotating camera, scroll wheel).

**Obtained from:** the LineageOS-style `vendor_rabbit_r1` tree (telephony/IMS
subset) and/or a stock r1 via a full `mtkclient` readback (full set). The
blobs are mapped into `vendor/rabbit/r1` using `extract-files.sh`, driven by
`device/rabbit/r1/proprietary-files.txt`.

**Justification:** These HALs are closed-source and required for hardware to
function; there is no open replacement for most MediaTek/InvenSense/Awinic
firmware. Extracting them from the user's own device (or a LineageOS tree
that redistributes them) is the standard, legal approach used by every custom
ROM project.

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

---

## Physical extraction procedure (mtkclient / r1_escape flow)

> **GATING STEP — requires the user's physical r1 plugged into the build host
> (or any Linux host) over USB.** Do not attempt this without the device.

The r1 boots with a MediaTek preloader. `mtkclient` speaks the MediaTek
bootrom/preloader protocol over USB to read/write partitions, which is both
the extraction and the brick-recovery path.

### Prerequisites

- A Linux host with `python3`, `pip`, and `libusb`.
- [`bkerler/mtkclient`](https://github.com/bkerler/mtkclient) installed.
- The r1 powered off, with its USB cable connected to the host.

### Step 1 — Install mtkclient

```sh
git clone https://github.com/bkerler/mtkclient.git
cd mtkclient
pip3 install -r requirements.txt
```

### Step 2 — Enter BROM/preloader mode

Power the r1 **off**, hold the correct key combination (per the r1_escape
flow: typically the push-to-talk button while connecting USB), and connect the
USB cable. `mtkclient` should detect the device:

```sh
python3 mtk r bootrom   # or: python3 mtk r preloader
```

Confirm detection with `lsusb` (a MediaTek `0e8d:2000` preloader or
`0e8d:0003` bootrom device appears).

### Step 3 — Full readback (the safety net)

```sh
python3 mtk rl out/ --skip preloader
```

This dumps every partition into `out/`. **Keep this dump** — it is the
restore-to-stock safety net and the source of the vendor blobs.

### Step 4 — Map the GPT

```sh
python3 mtk printgpt
```

Record the partition table (this also feeds `scatter_gen` for a scatter file,
used by the flashing tool).

### Step 5 — Extract the vendor partition

From the readback, locate the `vendor` (and `system_ext`) partition image,
then unpack it:

```sh
# e.g. out/vendor_a.img (A/B — use the active slot)
mkdir -p vendor-root && cd vendor-root
# unpack the ext4/sparse image (simg2img if sparse, then mount or 7z)
simg2img ../out/vendor_a.img vendor.raw 2>/dev/null || cp ../out/vendor_a.img vendor.raw
mkdir mnt && sudo mount -o loop,ro vendor.raw mnt
```

Then run the device-tree extractor against the mounted root:

```sh
cd <r1_firmware>/device/rabbit/r1
./extract-files.sh /path/to/vendor-root/mnt
./setup-makefiles.sh
```

### Step 6 — Enumerate the full blob set

The current `proprietary-files.txt` is an **incomplete** inventory. On the
mounted vendor image, enumerate the remaining HALs (GPU, camera, audio, WiFi,
sensors) and append them to `proprietary-files.txt`, then re-run
`extract-files.sh` and `setup-makefiles.sh`.

### Restore-to-stock

To return the device to stock at any point, write the readback back:

```sh
python3 mtk wl out/
```

---

## Policy

- Each blob is recorded in `vendor/rabbit/r1` with a
  `proprietary-files.txt` manifest (in `device/rabbit/r1`).
- Blobs are **not committed as binaries** into git; the extraction procedure
  and inventory are committed instead, and the blobs are produced on the build
  host.
- Any prebuilt image committed to the repo must carry a
  `docs/vendor-blobs.md` entry explaining its source and justification.