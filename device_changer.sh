#!/system/bin/sh
# Device & Chipset Changer + Remover by @Barzsss (FINAL REAL VERSION)

BUILD_PROP="/system/build.prop"

clear
echo "========================================="
echo "   █▀▀ █▄░█ █▀▄ █▄█ █▀▀ █▀█ █▀█ █▀▀"
echo "   ██▄ █░▀█ █▄▀ ░█░ ██▄ █▀▄ █▄█ ██▄"
echo "========================================="
echo " 📱 Device & Chipset Changer + Remover"
echo "        Created by @Barzsss"
echo

if [ ! -f /sdcard/build.prop.bak ]; then
    echo "📦 Membuat backup build.prop asli ke /sdcard/build.prop.bak..."
    cp $BUILD_PROP /sdcard/build.prop.bak
fi

echo
echo "✅ Pilih mode:"
OPTIONS=("Ubah Device & Chipset" "Remover (Kembalikan ke semula)")
select MODE in "${OPTIONS[@]}"; do
    [ -n "$MODE" ] && break
done

if [ "$MODE" = "Remover (Kembalikan ke semula)" ]; then
    echo "♻️  Memulihkan build.prop asli..."
    mount -o remount,rw /system
    cp /sdcard/build.prop.bak $BUILD_PROP
    chmod 644 $BUILD_PROP
    mount -o remount,ro /system
    echo "✅ Selesai! build.prop sudah kembali ke semula."
    exit 0
fi

echo
echo "✅ Pilih Brand:"
mapfile -t BRANDS < ./extra/brand_list.txt
select BRAND in "${BRANDS[@]}"; do
    [ -n "$BRAND" ] && break
done

echo
echo "✅ Pilih Device dari $BRAND:"
grep "^$BRAND:" ./extra/device_list.txt | cut -d: -f2- | tr ':' '\n'
mapfile -t DEVICES < <(grep "^$BRAND:" ./extra/device_list.txt | cut -d: -f2- | tr ':' '\n')
select NEW_MODEL in "${DEVICES[@]}"; do
    [ -n "$NEW_MODEL" ] && break
done

echo
echo "✅ Pilih Chipset:"
mapfile -t CHIPS < ./extra/chipset_list.txt
select NEW_CHIP in "${CHIPS[@]}"; do
    [ -n "$NEW_CHIP" ] && break
done

echo
echo "⚙️  Mengganti brand: $BRAND, model: $NEW_MODEL, chipset: $NEW_CHIP"
mount -o remount,rw /system
sed -i "s/^ro.product.brand=.*/ro.product.brand=$BRAND/" $BUILD_PROP
sed -i "s/^ro.product.model=.*/ro.product.model=$NEW_MODEL/" $BUILD_PROP

if grep -q "^ro.board.platform=" $BUILD_PROP; then
    sed -i "s/^ro.board.platform=.*/ro.board.platform=$NEW_CHIP/" $BUILD_PROP
else
    echo "ro.board.platform=$NEW_CHIP" >> $BUILD_PROP
fi

mount -o remount,ro /system
echo
echo "✅ Selesai! Brand: $BRAND | Device: $NEW_MODEL | Chipset: $NEW_CHIP"
echo "🔁 Silakan reboot untuk melihat perubahan."
