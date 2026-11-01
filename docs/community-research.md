# Community research — reference only

Prior art surveyed for **reference and learning only**. Nothing here is copied
into this project. Each entry is marked with what it teaches us.

## Unlock / flashing

- **[RabbitHoleEscapeR1/r1_escape](https://github.com/RabbitHoleEscapeR1/r1_escape)**
  (437★) — scripts to unlock the bootloader, disable AVB, and flash an AOSP-13
  userdebug GSI. *Teaches:* the exact unlock flow, that AVB must be disabled,
  and the MediaTek preloader/fastboot handoff.
- **[bkerler/mtkclient](https://github.com/bkerler/mtkclient/)** — MediaTek
  bootrom/preloader tool. *Teaches:* the low-level read/write path and the
  stock-backup restore flow (critical for a safe restore path).

## Device tree / vendor (incomplete, reference only)

- **[RabbitHoleEscapeR1/device_rabbit_r1](https://github.com/RabbitHoleEscapeR1/device_rabbit_r1)**
  — "GSI tree for the Rabbit R1". A GSI-oriented device tree (BoardConfig,
  overlays, keylayout, step-motor controls, `extract-files.sh`). *Teaches:*
  the A/B + system-as-root layout, the sepolicy/board config shape, and which
  proprietary files the community identified. **Not a complete board bring-up.**
- **[RabbitHoleEscapeR1/vendor_rabbit_r1](https://github.com/RabbitHoleEscapeR1/vendor_rabbit_r1)**
  — vendor tree skeleton. *Teaches:* the vendor partition structure.
- **[RabbitHoleEscapeR1/frameworks_base](https://github.com/RabbitHoleEscapeR1/frameworks_base)**
  — a fork carrying r1-specific framework changes. *Teaches:* which framework
  surfaces needed device-specific patching.
- **[RabbitHoleEscapeR1/scatter_gen](https://github.com/RabbitHoleEscapeR1/scatter_gen)**
  — generates an MTK scatter file from `mtkclient printgpt` output. *Teaches:*
  the GPT/partition map for flashing.

## Forums / threads

- **[XDA — How to Unlock Rabbit R1 Bootloader](https://xdaforums.com/t/how-to-unlock-rabbit-r1-bootloader-tutorial.4676024/)**
  — community tutorial and troubleshooting. *Teaches:* common unlock pitfalls
  and the restore-then-retry workflow.
- **[TurboTheTurtle/rabbit-r1-firmware](https://github.com/TurboTheTurtle/rabbit-r1-firmware)**
  — flashing guides and scripts. *Teaches:* consolidated flashing references.
- **r/Rabbitr1** threads (e.g. "Trying to flash CipherOS, stuck on fastboot")
  — real-world flashing issues. *Teaches:* fastboot handoff can stall; the
  preloader path is more reliable.

## Lessons

1. Unlock + flash is **solved** and low-risk *if* a full stock backup is kept.
2. AVB must be disabled (or vbmeta re-signed) for a custom system image.
3. The community work is **GSI-oriented** — it reuses the stock vendor/kernel
   and swaps the system image. A true from-scratch build (own kernel + device
   tree) is a larger, mostly-unexplored effort.
4. No public rabbit-provided kernel source or device tree exists; the community
   tree is a partial reverse-engineering effort.