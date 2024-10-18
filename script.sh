#!/bin/bash

# Remove existing local_manifests
rm -rf .repo/local_manifests/

# Initialize git lfs
git lfs install

# repo init manifest
repo init -u https://github.com/Evolution-X/manifest.git -b vic --git-lfs --depth=1
echo "====================="
echo "= Repo init success ="
echo "====================="

# Local manifests
git clone https://github.com/Trijal08/local_manifests -b EvoX-15-shusky --depth=1 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync
/opt/crave/resync.sh || repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
echo "================"
echo "= Sync success ="
echo "================"

# Using RisingOS GMS, need mods
rm -rf vendor/gapps
git clone https://gitlab.com/RisingTechOSS/android_vendor_gms.git -b fourteen vendor/gapps
sed -i 's/vendor\/gms/vendor\/gapps/g' vendor/gapps/*.*
sed -i 's/vendor\/gms/vendor\/gapps/g' vendor/gapps/common/*.*
sed -i 's/vendor\/gms/vendor\/gapps/g' vendor/gapps/products/*.*
echo "============================="
echo "= GMS/GApps setup succeeded ="
echo "============================="

# Private keys
git clone https://github.com/Trijal08/vendor_lineage-priv_keys.git vendor/lineage-priv/keys

# Export
export BUILD_USERNAME="GamerBoy1234294 • OrionStarsInTheSky"
export BUILD_HOSTNAME="crave"
export BUILD_BROKEN_MISSING_REQUIRED_MODULES=true
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
source vendor/gapps/*.sh*
rm -rf vendor/gms
echo "====== Envsetup Done ======="

# Lunch
breakfast husky
breakfast shiba
make installclean -j$(nproc --all)
echo "============="

# Build ROM
croot
brunch husky
brunch shiba
