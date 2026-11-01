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

# Product makefiles for the rabbit r1.
#
# NOTE: this is a bring-up skeleton. The product is not yet buildable;
# it is the starting point for W3 (device tree & kernel) in PLAN.md.

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/r1.mk

COMMON_LUNCH_CHOICES := \
    r1-userdebug \
    r1-user \
    r1-eng