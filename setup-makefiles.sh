#!/usr/bin/env bash
#
# setup-makefiles.sh - Itel S25 (S685LN)
# Generate Android.mk dan .bp otomatis berdasarkan blobs yang ada
# Jalankan SETELAH extract-files.sh
#

set -e

DEVICE="S685LN"
VENDOR="itel"
VENDOR_DIR="vendor/$VENDOR/$DEVICE"

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Generating makefiles...${NC}"

# =============================================
# Generate vendor/itel/S685LN/Android.mk
# =============================================
mkdir -p "$VENDOR_DIR"

cat > "$VENDOR_DIR/Android.mk" << 'EOF'
LOCAL_PATH := $(call my-dir)

# Prebuilt shared libraries
include $(CLEAR_VARS)

# Auto-generated: tambah module untuk tiap .so di sini
# Contoh:
# LOCAL_MODULE := libsprdoem
# LOCAL_SRC_FILES := lib64/libsprdoem.so
# LOCAL_MODULE_TAGS := optional
# LOCAL_MODULE_CLASS := SHARED_LIBRARIES
# LOCAL_MODULE_SUFFIX := .so
# LOCAL_MULTILIB := 64
# include $(BUILD_PREBUILT)

EOF

echo -e "${GREEN}[OK] $VENDOR_DIR/Android.mk${NC}"

# =============================================
# Generate vendor/itel/S685LN/device-vendor.mk
# =============================================
cat > "$VENDOR_DIR/device-vendor.mk" << 'EOF'
# Vendor blobs - Itel S25 (S685LN)

# RIL
PRODUCT_PACKAGES += \
    librilcore \
    libimpl-ril \
    libril-sprd

# Audio
PRODUCT_PACKAGES += \
    libaudio_v2 \
    libaudiohal

# Graphics
PRODUCT_PACKAGES += \
    gralloc.ums9230 \
    hwcomposer.ums9230 \
    libmali

# Camera
PRODUCT_PACKAGES += \
    camera.ums9230

# GPS
PRODUCT_PACKAGES += \
    gps.ums9230

# Sensors
PRODUCT_PACKAGES += \
    sensors.ums9230

# Power
PRODUCT_PACKAGES += \
    power.ums9230

# Fingerprint
PRODUCT_PACKAGES += \
    fingerprint.ums9230

# Keymaster
PRODUCT_PACKAGES += \
    libsprdkeymaster4 \
    libsprdgatekeeper

# Vendor properties
-include vendor/itel/S685LN/vendor-properties.mk
EOF

echo -e "${GREEN}[OK] $VENDOR_DIR/device-vendor.mk${NC}"

# =============================================
# Generate vendor-properties.mk
# =============================================
cat > "$VENDOR_DIR/vendor-properties.mk" << 'EOF'
# Vendor properties - Itel S25 (S685LN)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.product.device=S685LN \
    ro.vendor.product.manufacturer=ITEL \
    ro.vendor.product.model=itel\ S25 \
    ro.vendor.product.brand=Itel \
    ro.product.board=ITEL-S685LN \
    ro.board.platform=ums9230 \
    ro.hardware=ums9230_S685LNV

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.default_network=9 \
    ro.ril.telephony.mqanelements=6 \
    persist.radio.multisim.config=dsds \
    ro.telephony.sim.count=2

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.vc_call_vol_steps=7 \
    af.fast_track_multiplier=1

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=403 \
    ro.opengles.version=196610

# Wi-Fi
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15
EOF

echo -e "${GREEN}[OK] $VENDOR_DIR/vendor-properties.mk${NC}"

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN} Setup makefiles selesai!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Selanjutnya: push repo ke GitHub"
