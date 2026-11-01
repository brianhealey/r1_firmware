# vendor/rabbit/r1

Vendor tree **placeholder** for the rabbit r1.

## Status

This directory is a placeholder. It does **not** yet contain the proprietary
blobs — those are produced on the build host by one of two routes (see
[`docs/vendor-blobs.md`](../../../docs/vendor-blobs.md)):

1. **LineageOS-style vendor tree** — the community
   [`RabbitHoleEscapeR1/vendor_rabbit_r1`](https://github.com/RabbitHoleEscapeR1/vendor_rabbit_r1)
   tree carries the MediaTek telephony/IMS/vcodec subset (reference only).
2. **Physical extraction** — the full vendor set (GPU, camera, audio DSP,
   WiFi/BT firmware, sensors) must be pulled from a stock r1 via `mtkclient`.

Blobs are **not committed as binaries** to this repo; the procedure and
inventory are committed instead (see `device/rabbit/r1/proprietary-files.txt`
and `device/rabbit/r1/extract-files.sh`).

## Layout (once populated)

```
vendor/rabbit/r1/
├── Android.mk              # maps proprietary-files.txt into the vendor image
├── BoardConfigVendor.mk    # vendor image config
├── r1-vendor.mk            # product fragment inherited by device.mk
└── proprietary/            # extracted blobs (gitignored)
    ├── bin/  lib/  lib64/  framework/  priv-app/  etc/  system_ext/
```