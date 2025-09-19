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
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b Mist_OS-16.0-avicii .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j24
echo "================"
echo "= Sync success ="
echo "================"

# Update git submodules in kernel tree
cd kernel/oneplus/avicii
git submodule update --init --recursive
cd ../../..

# Clone private signing keys
if [ ! -d vendor/lineage-priv/keys ]; then
   git clone --depth=1 https://github.com/Trijal08/mist_vendor_lineage-priv_keys.git -b master vendor/lineage-priv/keys
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

## Delete any old builds
mistify avicii userdebug
make installclean -j$(nproc --all)

## Lunch and build the ROM
mistify avicii userdebug
mist b -j$(nproc --all)
