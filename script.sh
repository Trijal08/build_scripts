#!/usr/bin/env bash

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# Initialize the manifest
repo init --no-repo-verify --git-lfs --depth=1 -u https://github.com/crdroidandroid/android.git -b 15.0
echo "====================="
echo "= Repo init success ="
echo "====================="

# Clone local manifests
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b crDroid-15.1-bonito .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j66
echo "================"
echo "= Sync success ="
echo "================"

# Directory setup
rm -rf vendor/mist/overlays/SettingsHuskyOverlay
rm -rf vendor/addons/prebuilt/product/priv-app/BCR

# Auto-sign build
if [ ! -d vendor/lineage-priv ]; then
   curl -sSf https://raw.githubusercontent.com/Trijal08/crDroid-build-signed-script-auto/main/create-signed-env.sh | bash
fi

# Export some info about us
export BUILD_USERNAME="GamerBoy1234294"
export BUILD_HOSTNAME="ServerHive"
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
echo "==============="
echo "= Export Done ="
echo "==============="

# Set up build environment
source build/envsetup.sh
croot
echo "================="
echo "= Envsetup Done ="
echo "================="

# Delete any old builds
breakfast sargo userdebug
make installclean -j$(nproc --all)
breakfast bonito userdebug
make installclean -j$(nproc --all)

# Lunch and build the ROM
brunch sargo userdebug
brunch bonito userdebug
