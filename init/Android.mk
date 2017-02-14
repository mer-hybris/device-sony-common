# Copyright 2014 The Android Open Source Project
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

# Abort if the device is not handled by init_sony
ifeq (,$(findstring DEV_BLOCK_FOTA_NUM,$(BOARD_SONY_INIT_FLAGS)))
$(error device-sony-common-init: DEV_BLOCK_FOTA_NUM missing in "$(TARGET_DEVICE)", platform "$(PRODUCT_PLATFORM)", with '$(BOARD_SONY_INIT_FLAGS)')
endif

# Debug current init_sony settings
$(info device-sony-common-init: init_sony for "$(TARGET_DEVICE)", platform "$(PRODUCT_PLATFORM)", with '$(BOARD_SONY_INIT_FLAGS)')

# Init overrides for init_sony
root_init      := $(TARGET_ROOT_OUT)/init
root_init_sony := $(TARGET_ROOT_OUT)/sbin/droid-hal-init_sony

# If /sbin/droid-hal-init_sony is not a symlink then
# make /sbin/init_sony be a symlink to it. Currently it is not
# executed by anything, as it's in early stages to be integrated
# with Sailfish OS
$(root_init_sony): $(root_init) $(PRODUCT_OUT)/utilities/toybox $(PRODUCT_OUT)/utilities/keycheck $(PRODUCT_OUT)/utilities/init_sony
	cp $(PRODUCT_OUT)/utilities/toybox $(TARGET_ROOT_OUT)/sbin/toybox_init
	cp $(PRODUCT_OUT)/utilities/keycheck $(TARGET_ROOT_OUT)/sbin/keycheck
	cp $(PRODUCT_OUT)/utilities/init_sony $(TARGET_ROOT_OUT)/sbin/init_sony
	$(hide) if [ ! -L $(root_init_sony) ]; then \
	  echo "init_sony $(root_init_sony) isn't a symlink"; \
	  ln -s init_sony $(root_init_sony); \
	else \
	  echo "init_sony $(root_init_sony) is already a symlink"; \
	fi

ALL_DEFAULT_INSTALLED_MODULES += $(root_init_sony)
