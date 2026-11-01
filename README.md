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
- [ ] Phase 2 — build skeleton (manifest, device tree, kernel).
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

## License

See [`LICENSE`](LICENSE).