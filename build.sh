#! /bin/sh

set -e

case "$1" in
amd64 | "")
    echo "Making amd64-v3 optimized build of Eden"
    BUILD_PRESET=v3
    SUFFIX=amd64
    ;;
steamdeck | zen2)
    echo "Making Steam Deck (Zen 2) optimized build of Eden"
    BUILD_PRESET=zen2
    SYSTEM_PROFILE=steamdeck
    SUFFIX=steamdeck
    ;;
rog-ally | allyx | zen4)
    echo "Making ROG Ally X (Zen 4) optimized build of Eden"
    BUILD_PRESET=zen4
    SYSTEM_PROFILE=steamdeck
    SUFFIX=rog-ally
    ;;
legacy)
    echo "Making amd64 generic build of Eden"
    BUILD_PRESET=generic
    SUFFIX=legacy
    ;;
aarch64)
    echo "Making armv8-a build of Eden"
    BUILD_PRESET=generic
    SUFFIX=armv8
    ;;
armv9)
    echo "Making armv9-a build of Eden"
    BUILD_PRESET=armv9
    SUFFIX=armv9
    ;;
native)
    echo "Making native build of Eden"
    BUILD_PRESET=native
    SUFFIX=native
    ;;
*)
    echo "Invalid target $1 specified, must be one of native, amd64, steamdeck, zen2, allyx, rog-ally, zen4, legacy, aarch64, armv9"
    exit 1
    ;;
esac

export BUILD_PRESET SYSTEM_PROFILE

flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user --noninteractive org.flatpak.Builder
flatpak run org.flatpak.Builder --ccache --disable-rofiles-fuse --force-clean --install-deps-from=flathub --user build dev.eden_emu.eden.yml
rm -rf export
flatpak build-export export build
exec flatpak build-bundle export "Eden-Linux-${SUFFIX}.flatpak" dev.eden_emu.eden --runtime-repo=https://flathub.org/repo/flathub.flatpakrepo
