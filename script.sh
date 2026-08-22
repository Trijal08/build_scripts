#!/usr/bin/env -S bash -e

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# Initialize the manifest
repo init --no-repo-verify --git-lfs --depth=1 -u https://github.com/Mist-OS-Staging/manifest.git -b 17
echo "====================="
echo "= Repo init success ="
echo "====================="

# Clone local manifests
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b Mist_OS-17.0-pantah .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
echo "================"
echo "= Sync success ="
echo "================"

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

## Delete any old builds
# Pixel 7
mistify panther userdebug
make installclean -j$(nproc --all)
# Pixel 7 Pro
mistify cheetah userdebug
make installclean -j$(nproc --all)

## Lunch and build the ROM
# Pixel 7
mistify panther userdebug
mist b -j$(nproc --all)
# Pixel 7 Pro
mistify cheetah userdebug
mist b -j$(nproc --all)
