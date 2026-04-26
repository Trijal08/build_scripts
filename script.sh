#!/usr/bin/env -S bash -e

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# Initialize the manifest
repo init --no-repo-verify --git-lfs --depth=1 -u https://github.com/Project-Mist-OS/manifest.git -b 16
echo "====================="
echo "= Repo init success ="
echo "====================="

# Clone local manifests
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b Mist_OS-16.2-lemonade .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
echo "================"
echo "= Sync success ="
echo "================"

# Sync kernel submodules
cd kernel/oneplus/sm8350
git submodule update --init --recursive
cd ../../..

# Export some info about us
export BUILD_USERNAME="GamerBoy1234294"
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

## Delete any old builds
mistify lemonade userdebug
make installclean -j$(nproc --all)

## Lunch and build the ROM
mistify lemonade userdebug
mist b -j$(nproc --all)
