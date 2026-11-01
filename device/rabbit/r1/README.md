# device/rabbit/r1

Device tree for the rabbit r1 — **bring-up skeleton**, not yet buildable.

## Status

This tree is the W3 (device tree & kernel) starting point. It declares the
product (`r1`), the board (MediaTek MT6765 / Helio P35), the A/B +
system-as-root + recovery-as-boot layout, and the small-screen overlay
scaffolding. It is **not** a complete board bring-up:

- The MT6765 kernel source and defconfig are **not** wired in yet.
- The MediaTek common HAL/sepolicy config is **not** present yet.
- Partition sizes and kernel offsets are **placeholders** pending device
  measurement (`mtkclient printgpt`, stock boot-image header).
- Display resolution/density are **TBD** pending `adb shell wm size` /
  `wm density` on a physical r1.

## Layout

| Path | Purpose |
|---|---|
| `AndroidProducts.mk` | Declares the `r1` product and lunch choices |
| `r1.mk` | Product definition (brand/model, AAPT config, density) |
| `device.mk` | Device config: overlays, keylayout, packages, sepolicy |
| `BoardConfig.mk` | Board config: arch, platform, A/B, AVB, partition sizes |
| `keylayout/` | Key layout for the physical controls (scroll wheel, PTT) |
| `overlay/` | Framework overlays for the small screen |
| `configs/permissions/` | Priv-app permission allowlists |
| `proprietary-files.txt` | Inventory of vendor blobs to extract/source |
| `extract-files.sh` | Pulls blobs from a connected stock device |
| `setup-makefiles.sh` | Generates `Android.mk` from `proprietary-files.txt` |

## Reference (not copied)

The community GSI tree
[`RabbitHoleEscapeR1/device_rabbit_r1`](https://github.com/RabbitHoleEscapeR1/device_rabbit_r1)
was used **for reference only** to confirm the A/B + system-as-root layout,
the MediaTek platform naming, and the shape of the `proprietary-files.txt`
inventory. No file here is copied from it; this is an original skeleton.