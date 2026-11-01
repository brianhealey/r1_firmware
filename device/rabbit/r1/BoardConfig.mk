# Copyright (C) 2026 The r1_firmware Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Board configuration for the rabbit r1.
#
# SoC: MediaTek MT6765V (Helio P35) — 8x Cortex-A53.
# Values marked TBD are placeholders to be confirmed from the device
# (partition table via `mtkclient printgpt`, kernel offsets from the stock
# boot image) before a real build. See PLAN.md and docs/hardware.md.

# --- Architecture -----------------------------------------------------------
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# --- Platform ---------------------------------------------------------------
TARGET_BOARD_PLATFORM := mt6765
TARGET_BOOTLOADER_BOARD_NAME := r1

# --- Kernel (TBD — MT6765 kernel source is not yet wired in) -----------------
# The stock kernel is 4.19 (MTK). These offsets are PLACEHOLDERS and must be
# read from the stock boot image header (mkbootimg/unpack_bootimg).
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x11b00000
BOARD_TAGS_OFFSET := 0x07880000

# --- Partition layout: A/B + system-as-root + recovery-as-boot ---------------
# Matches the stock layout observed in the community tree and PLAN.md.
AB_OTA_UPDATER := true
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

# --- Verified boot ----------------------------------------------------------
BOARD_AVB_ENABLE := true
BOARD_AVB_ROLLBACK_INDEX := 0

# --- Bootloader -------------------------------------------------------------
# Reuse the stock (unlocked) bootloader and preloader; do not rebuild.
TARGET_NO_BOOTLOADER := true

# --- Partition sizes (TBD — confirm from `mtkclient printgpt`) ---------------
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824

# --- Vendor image -----------------------------------------------------------
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# --- Prebuilt kernel/dtbo (TBD — produced by the MT6765 kernel bring-up) -----
# TARGET_PREBUILT_KERNEL := device/rabbit/r1/prebuilt/kernel
# BOARD_PREBUILT_DTBOIMAGE := device/rabbit/r1/prebuilt/dtbo.img

# --- SELinux ----------------------------------------------------------------
BOARD_SEPOLICY_DIRS += device/rabbit/r1/sepolicy