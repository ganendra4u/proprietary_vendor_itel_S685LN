#!/usr/bin/env bash
#
# extract-files.sh - Itel S25 (S685LN)
# Ekstrak proprietary blobs dari device yang sudah di-root
#
# CARA PAKAI:
#   1. Pastikan HP terhubung via ADB, USB debugging aktif, sudah ROOT
#   2. cd ke folder ini
#   3. ./extract-files.sh
#   4. Atau: ./extract-files.sh [path/ke/system] untuk ekstrak dari folder ROM
#

set -e

DEVICE="S685LN"
VENDOR="itel"
BLOB_LIST="proprietary-files.txt"

# Warna output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}================================${NC}"
echo -e "${GREEN} Itel S25 (S685LN) Blob Extractor${NC}"
echo -e "${GREEN}================================${NC}"

# =============================================
# Cek ADB
# =============================================
if ! command -v adb &> /dev/null; then
    echo -e "${RED}[ERROR] ADB tidak ditemukan! Install dulu.${NC}"
    exit 1
fi

# Cek device terhubung
DEVICE_COUNT=$(adb devices | grep -v "List" | grep -c "device" || true)
if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo -e "${RED}[ERROR] Tidak ada device terdeteksi. Sambungkan HP!${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] Device terdeteksi${NC}"

# =============================================
# Cek Root
# =============================================
ROOT_CHECK=$(adb shell su -c "id" 2>/dev/null | grep "uid=0" || true)
if [ -z "$ROOT_CHECK" ]; then
    echo -e "${RED}[ERROR] Device tidak ter-root atau root tidak aktif!${NC}"
    echo -e "${YELLOW}Pastikan Magisk sudah terinstall dan izin root sudah diberikan ke ADB.${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] Root terdeteksi${NC}"

# =============================================
# Setup output folder
# =============================================
OUTPUT_DIR="vendor/$VENDOR/$DEVICE"
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}[OK] Output folder: $OUTPUT_DIR${NC}"

# =============================================
# Fungsi pull file dari device
# =============================================
pull_file() {
    local src="$1"
    local dst="$OUTPUT_DIR/$1"
    local dir=$(dirname "$dst")

    mkdir -p "$dir"

    # Copy ke sdcard dulu (workaround permission)
    adb shell su -c "cp /$src /sdcard/tmp_blob" 2>/dev/null || {
        echo -e "${YELLOW}[SKIP] /$src tidak ditemukan${NC}"
        return
    }

    adb pull /sdcard/tmp_blob "$dst" 2>/dev/null && \
        echo -e "${GREEN}[OK] $src${NC}" || \
        echo -e "${YELLOW}[FAIL] $src${NC}"

    adb shell rm -f /sdcard/tmp_blob 2>/dev/null
}

# =============================================
# Buat temp folder di sdcard
# =============================================
adb shell mkdir -p /sdcard/ 2>/dev/null

# =============================================
# Loop ekstrak semua blobs
# =============================================
echo ""
echo -e "${GREEN}Mulai ekstrak blobs...${NC}"
echo ""

TOTAL=0
SUCCESS=0
SKIP=0

while IFS= read -r line; do
    # Skip komentar dan baris kosong
    [[ "$line" =~ ^# ]] && continue
    [[ -z "$line" ]] && continue

    # Handle format "src|dst"
    if [[ "$line" == *"|"* ]]; then
        SRC="${line%%|*}"
        DST="${line##*|}"
    else
        SRC="$line"
        DST="$line"
    fi

    TOTAL=$((TOTAL + 1))
    pull_file "$SRC"

done < "$BLOB_LIST"

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN} Selesai!${NC}"
echo -e "${GREEN} Total: $TOTAL blobs diproses${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo -e "${YELLOW}Langkah selanjutnya:${NC}"
echo "1. Jalankan: ./setup-makefiles.sh"
echo "2. Push repo ini ke GitHub"
echo "3. Lanjut build di VPS"
