#!/bin/bash
# Packs the already built Avel plugins into one installer: dist/Avel-Bundle-macOS.pkg
#   tools/make_pkg_mac.sh <art-dir>
# <art-dir>/<Target>/VST3/<Product>.vst3 and <art-dir>/<Target>/AU/<Product>.component
#
# Optional signing (set as GitHub secrets, see README): if DEVELOPER_ID_APP and
# DEVELOPER_ID_INSTALLER are set, plugins and the installer are signed with them;
# otherwise plugins get an ad-hoc signature and the installer stays unsigned.
set -euo pipefail
cd "$(dirname "$0")/.."

ART="$(cd "$1" && pwd)"
WORK=build/pkg
rm -rf "$WORK"
mkdir -p "$WORK/pkgs" dist

python3 tools/gen.py mac "$ART" "$WORK"

sign_bundle()
{
    if [ -n "${DEVELOPER_ID_APP:-}" ]; then
        codesign --force --deep --timestamp --options runtime --sign "$DEVELOPER_ID_APP" "$1"
    else
        codesign --force --deep --sign - "$1"
    fi
}

# Bundles must not be "relocatable", otherwise macOS Installer may write the update
# into some other copy of the plugin it finds on disk instead of /Library.
make_component_plist()
{
    local root="$1" plist="$2"
    pkgbuild --analyze --root "$root" "$plist" >/dev/null
    local i=0
    while /usr/libexec/PlistBuddy -c "Print :$i" "$plist" >/dev/null 2>&1; do
        /usr/libexec/PlistBuddy -c "Delete :$i:BundleIsRelocatable" "$plist" >/dev/null 2>&1 || true
        /usr/libexec/PlistBuddy -c "Add :$i:BundleIsRelocatable bool false" "$plist"
        /usr/libexec/PlistBuddy -c "Delete :$i:BundleOverwriteAction" "$plist" >/dev/null 2>&1 || true
        /usr/libexec/PlistBuddy -c "Add :$i:BundleOverwriteAction string upgrade" "$plist"
        i=$((i + 1))
    done
}

# one component package per plugin and format
make_component()
{
    local id="$1" fmt="$2" version="$3" src="$4" dest="$5"
    local root="$WORK/root-$id-$fmt" scripts="$WORK/scripts-$id-$fmt"
    local name; name="$(basename "$src")"
    mkdir -p "$root$dest" "$scripts"
    cp -R "$src" "$root$dest/"
    xattr -cr "$root" 2>/dev/null || true
    sign_bundle "$root$dest/$name"

    # replace an older copy cleanly; make hosts notice a new Audio Unit without a reboot
    printf '#!/bin/bash\nrm -rf "%s/%s"\nexit 0\n' "$dest" "$name" > "$scripts/preinstall"
    printf '#!/bin/bash\nkillall -9 AudioComponentRegistrar >/dev/null 2>&1 || true\nexit 0\n' > "$scripts/postinstall"
    chmod +x "$scripts/preinstall" "$scripts/postinstall"

    make_component_plist "$root" "$WORK/$id-$fmt.plist"
    pkgbuild --root "$root" --component-plist "$WORK/$id-$fmt.plist" \
             --identifier "com.avel.$id.$fmt" --version "$version" --install-location / \
             --scripts "$scripts" "$WORK/pkgs/$id-$fmt.pkg"
}

while IFS=$'\t' read -r id target product version; do
    [ -n "$id" ] || continue
    vst3="$ART/$target/VST3/$product.vst3"
    au="$ART/$target/AU/$product.component"
    [ -d "$vst3" ] && [ -d "$au" ] || { echo "::error::Нет собранного $product в $ART/$target"; exit 1; }
    echo "==> $product $version"
    make_component "$id" vst3 "$version" "$vst3" /Library/Audio/Plug-Ins/VST3
    make_component "$id" au   "$version" "$au"   /Library/Audio/Plug-Ins/Components
done < "$WORK/plugins.tsv"

OUT=dist/Avel-Bundle-macOS.pkg
rm -f "$OUT"
productbuild --distribution "$WORK/distribution.xml" --package-path "$WORK/pkgs" \
             --resources packaging/macos/resources "$WORK/unsigned.pkg"

if [ -n "${DEVELOPER_ID_INSTALLER:-}" ]; then
    productsign --timestamp --sign "$DEVELOPER_ID_INSTALLER" "$WORK/unsigned.pkg" "$OUT"
else
    mv "$WORK/unsigned.pkg" "$OUT"
fi

echo "Готово: $PWD/$OUT"
