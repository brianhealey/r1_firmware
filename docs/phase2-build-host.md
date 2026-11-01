# Phase 2 — build host (provisioned)

The AOSP build host is a VM on the Proxmox node `bigpc` (10.100.10.34).

## VM

| Field | Value |
|---|---|
| VMID / name | `10500` / `r1-aosp-build` |
| OS | Ubuntu 22.04.5 LTS (jammy cloud image) |
| vCPU | 12 (host CPU type) |
| RAM | 32 GB |
| OS disk | 40 GB qcow2 on `fast-nvr` (NVMe) |
| Data disk | 400 GB qcow2 on `nvr-bulk` (HDD), mounted at `/aosp` |
| Network | `vmbr0`, DHCP — currently `10.100.10.113` |

## bigpc resource check (at provisioning time)

- **RAM:** 125 GB total, ~112 GB available → 32 GB VM leaves ~80 GB for the
  K3s cluster. No over-commit.
- **Disk:** the fast NVMe storage (`fast-nvr`, 931 GB) was ~90% used (it hosts
  the K3s container overlay), so only the OS disk (40 GB) was placed there.
  The 400 GB AOSP disk went on `nvr-bulk` (12.7 TB HDD, ~7 TB free) — real
  free space, not over-committed. Both are on `fast-nvr`/`nvr-bulk` per the
  "OS on fastnvr or nvr" constraint.
- **CPU:** 32 cores, load average ~1.8 at provisioning → 12 vCPU is safe.

## Access

From `bigpc` (as root):

```sh
ssh -i /root/.ssh/r1_build ubuntu@10.100.10.113
```

The `ubuntu` user has passwordless sudo. The dedicated key is
`/root/.ssh/r1_build` on bigpc.

## AOSP tree

- Checkout: `/aosp/android13`
- Manifest: `https://android.googlesource.com/platform/manifest`,
  pinned to **`android-13.0.0_r84`** (the latest Android 13 release tag).
- Build deps installed: OpenJDK 11, `repo`, and the AOSP 13 toolchain
  packages.

## Sync state

`repo sync -c -j8` was started in the background (log at
`/aosp/repo-sync.log`, PID in `/aosp/repo-sync.pid`). This is a ~150 GB
download and takes hours; it is **in progress**, not complete.

To check:

```sh
ssh -i /root/.ssh/r1_build ubuntu@10.100.10.113 'tail -20 /aosp/repo-sync.log; du -sh /aosp/android13'
```

## Next steps (once sync completes)

1. Copy `device/rabbit/r1` and `vendor/rabbit/r1` into the tree (or split them
   into dedicated repos and add to `local_manifests/r1.xml`).
2. Wire in the MT6765 kernel and MediaTek common config (W3).
3. Source/extract vendor blobs (see `docs/vendor-blobs.md`).
4. `lunch r1-userdebug && m` — first build attempt.