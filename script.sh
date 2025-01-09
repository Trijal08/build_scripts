#!/bin/bash

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# Initialize the manifest
repo init --no-repo-verify --git-lfs --depth=1 -u https://github.com/SomethingOS/android_manifest.git -b vauxite
echo "====================="
echo "= Repo init success ="
echo "====================="

# Clone local manifests
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b SomethingOS-15.0-guacamoleb .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || repo sync -c --current-branch --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
echo "================"
echo "= Sync success ="
echo "================"

# Auto-sign build
if [ ! -d vendor/lineage-priv ]; then
   curl -sSf https://raw.githubusercontent.com/Trijal08/crDroid-build-signed-script-auto/main/create-signed-env.sh | bash
fi

# Export some info about us
export BUILD_USERNAME="Jayed Khan • Misty Fresh"
export BUILD_HOSTNAME="crave"
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

# Lunch and build the ROM
make installclean -j$(nproc --all)
./rom-build.sh guacamoleb -z -s vendor/lineage-priv/keys/
