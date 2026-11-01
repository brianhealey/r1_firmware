# Hardware — rabbit r1

Confirmed facts and open questions, with sources. Facts marked **TBD** are not
yet confirmed and must be verified on a real device before being relied on.

## Confirmed

| Component | Value | Source |
|---|---|---|
| SoC | MediaTek **MT6765V** (Helio P35), octa-core applications + baseband | [iFixit Chip ID](https://www.ifixit.com/Teardown/Rabbit+R1+Chip+ID/172517) |
| Memory | Samsung **KMDV6001DA-B620** uMCP — 64 GB NAND + 6 GB LPDDR4X | iFixit Chip ID (chip datasheet) |
| PMIC | MediaTek MT6357CRV, MT6371P | iFixit Chip ID |
| Audio amp | Awinic AW87390FCR | iFixit Chip ID |
| WiFi / BT | MediaTek MT6631N | iFixit Chip ID |
| RF | MediaTek MT6177W + OnMicro OM8443-26 / OM8816-52 PAs | iFixit Chip ID |
| Sensors | TDK InvenSense accelerometer + gyroscope | iFixit Chip ID |
| Camera motor | Ruimeng MS35774 stepper-motor driver (rotating camera) | iFixit Chip ID |
| Display | 2.88" touchscreen | rabbit / [iFixit](https://www.ifixit.com/Device/Rabbit_R1) |
| Storage (retail) | 128 GB | rabbit / iFixit device page |
| RAM (retail) | 4 GB | rabbit / Wikipedia |
| Bootloader | **Unlockable** — rabbit officially supports unlock + a flashing tool | [jesselyu (rabbit)](https://x.com/jesselyu/status/1902821356498305427) |
| Recovery path | MediaTek preloader (`mtkclient`), fastboot, stock-backup restore | [r1_escape](https://github.com/RabbitHoleEscapeR1/r1_escape) |
| OS | Android 13 (AOSP) with a Flutter "Rabbit OS" app | community analysis (May 2024) |
| Partition scheme | A/B (`AB_OTA_UPDATER`), system-as-root, recovery-as-boot, AVB | [device_rabbit_r1 BoardConfig](https://github.com/RabbitHoleEscapeR1/device_rabbit_r1/blob/main/BoardConfig.mk) |

A/B partitions observed in the community device tree: `boot`, `dtbo`,
`product`, `system`, `vbmeta`, `vbmeta_system`, `vbmeta_vendor`, `vendor`.

## Open questions (TBD)

1. **Exact display resolution and density.** The 2.88" size is confirmed, but a
   definitive pixel resolution was not found in public sources. Confirm on
   device: `adb shell wm size` and `adb shell wm density`. (Commonly reported
   as 480×640 portrait, but this is **unverified** and must not be assumed.)
2. **RAM/storage discrepancy.** The iFixit chip ID (KMDV6001DA-B620) is a
   64 GB NAND + 6 GB LPDDR4X uMCP, while retail specs list 4 GB RAM / 128 GB
   storage. Either the retail spec rounds differently or a different uMCP
   variant is fitted. Confirm on device: `adb shell cat /proc/meminfo` and
   `adb shell df -h /data`.
3. **Exact Android build fingerprint** (`ro.build.fingerprint`,
   `ro.build.version.release`) — confirm on device to pin the stock baseline.
4. **Unlock flow specifics** — whether unlock requires a rabbit-hosted token or
   works offline via the `r1_escape` flow.

## Bootloader / recovery facts

- The bootloader **can be unlocked**; rabbit ships an official flashing tool to
  restore rabbitOS afterward.
- The community `r1_escape` flow: enable "OEM Unlocking" → unlock bootloader
  (wipes userdata) → disable AVB (flash `vbmeta.img`) → flash an AOSP-13
  userdebug GSI.
- Brick recovery uses `mtkclient` (bkerler/mtkclient) to write a full stock
  backup over the MediaTek preloader USB VCOM interface.