#!/usr/bin/env bash

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# Initialize the manifest
repo init --no-repo-verify --git-lfs --depth=1 -u https://github.com/Project-Mist-OS/manifest.git -b 15
echo "====================="
echo "= Repo init success ="
echo "====================="

# Clone local manifests
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b Mist_OS-15.1-bonito .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j66
echo "================"
echo "= Sync success ="
echo "================"

# Directory setup
rm -rf vendor/addons/prebuilt/product/priv-app/BCR
cd kernel/google/b4s4; git submodule init; git submodule update; cd ../../..

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

# Delete any old builds
mistify sargo user
make installclean -j$(nproc --all)
mistify bonito user
make installclean -j$(nproc --all)

# Lunch and build the ROM
mistify sargo user
mist sb
mist fbs
mistify bonito user
mist sb
mist fbs
