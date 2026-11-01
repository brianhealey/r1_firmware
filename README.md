# r1_firmware

From-scratch firmware for the **rabbit r1** device, based on the latest Android
release that is realistically buildable for its hardware.

This is a brand-new project. The repository currently holds the **phase-1
research and plan**; it does not yet contain a bootable image. No bootable
firmware is claimed until one is actually built, flashed, and tested on a
device.

## Status

- [x] Phase 1 — hardware research, Android base selection, community survey,
      vendor-blob inventory, and roadmap ([`PLAN.md`](PLAN.md)).
- [~] Phase 2 — build skeleton: device tree (`device/rabbit/r1`), vendor
      placeholder (`vendor/rabbit/r1`), local manifest (AOSP
      `android-13.0.0_r84`), and a provisioned build VM on `bigpc` with the
      source sync in progress. See
      [`docs/phase2-build-host.md`](docs/phase2-build-host.md). Kernel and
      MediaTek common config still TBD.
- [ ] Phase 3 — vendor blob extraction and integration.
- [ ] Phase 4 — small-screen UI/launcher design.
- [ ] Phase 5 — build, flash, and on-device test.

## Hardware at a glance

| Component | Confirmed value | Source |
|---|---|---|
| SoC | MediaTek **MT6765V** (Helio P35), octa-core | iFixit teardown |
| Memory | Samsung KMDV6001DA-B620 uMCP (64 GB NAND + 6 GB LPDDR4X) | iFixit teardown |
| Display | 2.88" touchscreen (resolution TBD — see [hardware](docs/hardware.md)) | rabbit / iFixit |
| Bootloader | **Unlockable** (official rabbit support + community `r1_escape`) | rabbit / community |
| Recovery | MediaTek preloader (`mtkclient`), fastboot, stock-backup restore | community |

Full detail, with sources and open questions: [`docs/hardware.md`](docs/hardware.md).

## Documents

- [`PLAN.md`](PLAN.md) — architecture, workstreams, dependencies, build/flash
  path, and the small-screen design approach.
- [`docs/hardware.md`](docs/hardware.md) — confirmed hardware facts and open questions.
- [`docs/android-base.md`](docs/android-base.md) — Android release selection and rationale.
- [`docs/community-research.md`](docs/community-research.md) — reference-only survey of prior art.
- [`docs/vendor-blobs.md`](docs/vendor-blobs.md) — every special binary/config, its source, and its justification.
- [`docs/phase2-build-host.md`](docs/phase2-build-host.md) — the provisioned AOSP build VM and sync state.
- [`docs/mtkclient-setup.md`](docs/mtkclient-setup.md) — mtkclient install (macOS) and the r1 vendor-extraction procedure (documented, not yet executed).

## License

See [`LICENSE`](LICENSE).