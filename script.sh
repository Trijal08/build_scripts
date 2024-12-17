#!/bin/bash

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# Initialize the manifest
repo init --no-repo-verify --git-lfs --depth=1 -u https://github.com/Project-Flare/manifest.git -b 15 -g default,-mips,-darwin,-notdefault
echo "====================="
echo "= Repo init success ="
echo "====================="

# Clone local manifests
git clone https://github.com/Trijal08/local_manifests -b Mist_OS-15-k6.1-shusky --depth=1 .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || curl -sSf https://raw.githubusercontent.com/Trijal08/build_scripts/refs/heads/sync_script/resync.sh | bash
echo "================"
echo "= Sync success ="
echo "================"

# Directory setup
mkdir device/google/shusky-kernels/5.15
ln -sf ../6.1/trunk-12394889 device/google/shusky-kernels/5.15/24Q3-12357444

# Auto-sign build
rm -rf vendor/lineage-priv/keys
wget https://raw.githubusercontent.com/Trijal08/crDroid-build-signed-script-auto/main/create-signed-env.sh
chmod a+x create-signed-env.sh
./create-signed-env.sh

# Export some info about us
export BUILD_USERNAME="GamerBoy1234294 • Misty Fresh"
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
#make installclean -j$(nproc --all)
#mistify husky
#mist b
#mistify shiba
#mist b
