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

# Product definition for the rabbit r1.
#
# The r1 is a MediaTek MT6765 (Helio P35) device with a ~2.88" portrait
# touchscreen, a rotating camera, a scroll wheel, and a push-to-talk button.
# It ships Android 13 (AOSP) with A/B partitions and system-as-root.

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony.mk)
$(call inherit-product, device/rabbit/r1/device.mk)

PRODUCT_NAME := r1
PRODUCT_DEVICE := r1
PRODUCT_BRAND := rabbit
PRODUCT_MODEL := r1
PRODUCT_MANUFACTURER := rabbit

# Small-screen device: portrait, single-column, no telephony UI assumptions
# beyond the base telephony stack (the r1 has a cellular modem).
PRODUCT_CHARACTERISTICS := device

# Display resolution/density are TBD until read from a physical device
# (`adb shell wm size` / `adb shell wm density`). The values below are
# placeholders and MUST be corrected before a real build. See docs/hardware.md.
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := hdpi

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=240 \
    persist.sys.sf.native_mode=1