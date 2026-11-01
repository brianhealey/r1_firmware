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

# Device configuration for the rabbit r1.
#
# Bring-up skeleton. MediaTek common configuration and the MT6765 kernel are
# not yet wired in (see PLAN.md W3 and docs/vendor-blobs.md).

LOCAL_PATH := $(call my-dir)

# Vendor blobs (proprietary HALs/firmware). Populated by vendor/rabbit/r1,
# which is a placeholder until blobs are extracted or sourced (see
# docs/vendor-blobs.md). The include is conditional so the tree still parses
# before the vendor tree exists.
$(call inherit-product-if-exists, vendor/rabbit/r1/r1-vendor.mk)

# MediaTek common device config (TBD — depends on the MT6765 kernel/HAL
# bring-up; not present in the skeleton).
# $(call inherit-product, device/mediatek/common/device.mk)

# Framework overlays for the small screen (see overlay/).
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Keylayout for the r1's physical controls (scroll wheel, push-to-talk).
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/keylayout,system/usr/keylayout)

# Permissions for prebuilt privileged apps (e.g. IMS service).
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/permissions,system/etc/permissions)

# Device-specific apps (skeleton; implementations land with W3/W5).
# StepMotorControls drives the rotating-camera stepper motor.
# KeyHandler maps the physical keys.
PRODUCT_PACKAGES += \
    StepMotorControls \
    KeyHandler

# SELinux policy (empty in the skeleton; populated during bring-up).
BOARD_SEPOLICY_DIRS += $(LOCAL_PATH)/sepolicy

# The r1 has a cellular modem (MT6177W RF) but no phone dialer UI; keep the
# telephony stack but do not ship a phone app.
PRODUCT_PACKAGES += \
    telephony-common \
    ims