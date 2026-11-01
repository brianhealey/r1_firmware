# Android base selection

## What the r1 ships

The r1 runs **Android 13 (AOSP)** with a Flutter-based "Rabbit OS" app on top.
The community's `r1_escape` flashes an **AOSP-13 userdebug GSI**.

## What "latest Android" realistically means for MT6765

The MT6765 (Helio P35) is a 2018-era SoC. Its mainline kernel support is
**4.14 / 4.19**. This caps how far a *from-scratch* build can go:

| Option | Android | Kernel | Realism |
|---|---|---|---|
| AOSP `android-13.0.0` | 13 | 4.19 (MTK) | **Recommended** — matches stock, best driver/HAL compatibility |
| LineageOS 20 | 13 | 4.19 | Good — last LOS branch with broad MT6765 device support |
| LineageOS 21 | 14 | 4.19 | Partial — many MT6765 devices dropped |
| Newer GSI (14/15) | 14/15 | stock 4.19 | Boots only reusing stock vendor/kernel — **not** from-scratch |

**Recommendation:** start from **AOSP `android-13.0.0`** (or LineageOS 20 for
its device bring-up tooling and MT6765 device references). Android 13 is both
"the latest stable AOSP release the hardware can realistically run from
scratch" and the version the stock vendor blobs were built against, which
maximizes HAL compatibility.

## Manifest starting point

- AOSP: `https://android.googlesource.com/platform/manifest` — branch
  `android-13.0.0_r<latest>`.
- LineageOS 20: `https://github.com/LineageOS/android` — branch `lineage-20.0`.

The device tree (`device/rabbit/r1`), kernel, and vendor trees are layered on
top via a local manifest (`local_manifests/`).

## Why not a newer Android

A newer major version would require either (a) forward-porting the MT6765
kernel and HALs — a large, uncertain effort with no public r1 kernel source —
or (b) a GSI that reuses the stock vendor/kernel, which contradicts the
"from scratch" goal. Android 13 is therefore the honest ceiling for a
from-scratch build today.