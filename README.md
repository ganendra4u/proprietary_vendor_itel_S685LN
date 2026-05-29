# Proprietary Vendor - Itel S25 (S685LN)

> **⚠️ Repo ini kosong dulu** — blobs akan diisi setelah UBL + root (September 2026)

## Struktur Repo

```
proprietary_vendor_itel_S685LN/
├── Android.mk
├── BoardConfigVendor.mk
├── extract-files.sh         ← jalankan setelah root untuk ekstrak blobs
├── setup-makefiles.sh       ← generate Android.mk otomatis
├── proprietary-files.txt    ← daftar blobs yang dibutuhkan
└── vendor/
    └── itel/
        └── S685LN/
            ├── Android.mk          (auto-generated)
            ├── device-vendor.mk    (auto-generated)
            ├── vendor-properties.mk(auto-generated)
            ├── lib/                (blobs 32-bit)
            ├── lib64/              (blobs 64-bit)
            ├── bin/                (executables)
            ├── etc/                (config files)
            └── firmware/           (firmware files)
```

## Cara Ekstrak Blobs

```bash
# Pastikan HP sudah root & ADB aktif
adb devices  # cek device terdeteksi

# Ekstrak semua blobs
chmod +x extract-files.sh
./extract-files.sh

# Generate makefiles
chmod +x setup-makefiles.sh
./setup-makefiles.sh
```

## Pasangan Repo

| Repo | Link |
|------|------|
| Device Tree | [android_device_itel_S685LN](https://github.com/ganendra4u/android_device_itel_S685LN) |
| Kernel | [android_kernel_itel_ums9230](https://github.com/ganendra4u/android_kernel_itel_ums9230) |
| Vendor | **Repo ini** |

## Maintainer

- **ganendra4u** - [@GitHub](https://github.com/ganendra4u)
