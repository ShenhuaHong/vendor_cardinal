PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    ro.setupwizard.rotation_locked=true

# Mark as eligible for Google Assistant
PRODUCT_PROPERTY_OVERRIDES += ro.opa.eligible_device=true

# Show SELinux preference in Settings->System->About phone
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
# RecueParty? No thanks.
PRODUCT_PROPERTY_OVERRIDES += persist.sys.enable_rescue=false
endif

# Include low res bootanimation if display is equal or less then 720p
TARGET_BOOTANIMATION_400 := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -le 720 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Include High res bootanimation if display is greater then 1080p
TARGET_BOOTANIMATION_1200 := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -gt 1080 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Bootanimation
ifeq ($(TARGET_BOOTANIMATION_400),true)
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/media/bootanimation-400.zip:system/media/bootanimation.zip
else
ifeq ($(TARGET_BOOTANIMATION_1200),true)
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/media/bootanimation-1200.zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip
endif
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/cardinal/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/cardinal/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/cardinal/prebuilt/common/bin/whitelist:system/addon.d/whitelist

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Changelog
ifeq ($(CARDINAL_RELEASE),true)
PRODUCT_COPY_FILES +=  \
    vendor/cardinal/prebuilt/common/etc/Changelog.txt:system/etc/Changelog.txt
else
GENERATE_CHANGELOG := true
endif

# Google Dialer fix
PRODUCT_COPY_FILES +=  \
    vendor/cardinal/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/cardinal/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/cardinal/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Init file
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/etc/init.local.rc:root/init.cardinal.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/cardinal/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/cardinal/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Misc packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    LatinIME \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
	libbthost_if \
	WallpaperPicker

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom off-mode charger
ifneq ($(WITH_CUSTOM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    custom_charger_res_images \
    font_log.png \
    libhealthd.custom
endif

# Telephony packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Stk \
    
# Mms depends on SoundRecorder for recorded audio messages
PRODUCT_PACKAGES += \
    SoundRecorder

# CARDINAL INCLUDES
PRODUCT_PACKAGES += \
    Calendar \
    Camera2 \
    Launcher3 \
    messaging \
    LighteningBrowser \
    ExactCalculator \
    Turbo

# Themes
PRODUCT_PACKAGES += \
    PixelTheme \
    Stock

# Build OTA and Margarita on official builds
ifeq ($(CARDINAL_RELEASE),true)
PRODUCT_PACKAGES += \
    CardinalOTA \
    Margarita
endif

# World APN list
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Selective SPN list for operator number who has the problem.
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/etc/selective-spn-conf.xml:system/etc/selective-spn-conf.xml

# Overlays & Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += \
	vendor/cardinal/overlay/common \
	vendor/cardinal/overlay/dictionaries

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/cardinal/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/cardinal/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/cardinal/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so
endif

# Enable Secure ADB authentication for user builds
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=1
else
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=0
endif

# Build official builds with private keys
ifeq ($(CARDINAL_RELEASE),true)
include vendor/cardinal-priv/keys.mk
endif

# Cardinal-AOSP versioning system
AOSP_VERSION_CODENAME := OREO
CARDINAL_VERSION_CODENAME := 5.2-BETA
ifndef CARDINAL_BUILD_TYPE
ifeq ($(CARDINAL_RELEASE),true)
    CARDINAL_BUILD_TYPE := OFFICIAL
    CARDINAL_POSTFIX := -$(shell date +"%Y%m%d")
else
    CARDINAL_BUILD_TYPE := UNOFFICIAL
endif
endif

# Use CARDINAL_BUILD_EXTRA as postfix if defined  (non-release/unofficial builds)
ifdef CARDINAL_BUILD_EXTRA
    CARDINAL_POSTFIX := -$(CARDINAL_BUILD_EXTRA)
endif

# Append time if postfix not defined (non-release/unofficial builds)
ifndef CARDINAL_POSTFIX
    CARDINAL_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

# Output zip naming
CARDINAL_VERSION := Cardinal-AOSP-$(CARDINAL_VERSION_CODENAME)-$(AOSP_VERSION_CODENAME)-$(CARDINAL_BUILD_TYPE)$(CARDINAL_POSTFIX)
ifeq ($(CARDINAL_RELEASE),true)
CARDINAL_MOD_VERSION := Cardinal-AOSP-$(CARDINAL_VERSION_CODENAME)-$(AOSP_VERSION_CODENAME)-$(CARDINAL_BUILD)-$(CARDINAL_BUILD_TYPE)$(CARDINAL_POSTFIX)
else
CARDINAL_MOD_VERSION := Cardinal-AOSP-$(CARDINAL_VERSION_CODENAME)-$(AOSP_VERSION_CODENAME)-$(CARDINAL_BUILD)$(CARDINAL_POSTFIX)
endif

# Cardinal sprcific build properties
PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    cardinal.ota.version=$(CARDINAL_MOD_VERSION) \
    ro.cardinal.version=$(CARDINAL_VERSION_CODENAME) \
    ro.modversion=$(CARDINAL_MOD_VERSION) \
    ro.cardinal.buildtype=$(CARDINAL_BUILD_TYPE)

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif


# include sounds from pixel
$(call inherit-product-if-exists, vendor/cardinal/google/sounds/PixelSounds.mk)

# Easy way to extend to add more packages
$(call inherit-product-if-exists, vendor/extra/product.mk)
