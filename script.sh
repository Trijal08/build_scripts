#!/usr/bin/env bash

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# Initialize the manifest
repo init --no-repo-verify --git-lfs --depth=1 -u https://github.com/Trijal08/mistifest.git -b 15
echo "====================="
echo "= Repo init success ="
echo "====================="

# Clone local manifests
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b Mist_OS-15.1-shusky .repo/local_manifests
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
rm -rf vendor/lineage-priv

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
mistify husky eng
make installclean -j$(nproc --all)
mistify shiba eng
make installclean -j$(nproc --all)

# Lunch and build the ROM
mistify husky eng
mist b
mist fb
mistify shiba eng
mist b
mist fb
