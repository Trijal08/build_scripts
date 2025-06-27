#!/usr/bin/env -S bash -e

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
git clone --depth=1 https://github.com/Trijal08/local_manifests.git -b Mist_OS-15.2-waffle .repo/local_manifests
echo "================================="
echo "= Local manifests clone success ="
echo "================================="

# Sync repositories (now let that sync in)
/opt/crave/resync.sh || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j24
echo "================"
echo "= Sync success ="
echo "================"

# Kernel setup
cd kernel/oneplus/sm8650
git submodule init; git submodule update
cd ../../..

# Commits
cd vendor/lineage/
git fetch https://github.com/LineageOS/android_vendor_lineage.git refs/changes/56/417156/3 && git cherry-pick -X theirs FETCH_HEAD || exit 1
cd ../../
#cd hardware/qcom-caf/sm8650/display/
#git fetch https://github.com/OnePlus-12-Development/android_hardware_qcom_display.git 1e1fecc0044c8990cb1076d0a87adc8207f2acd1; git cherry-pick FETCH_HEAD || exit 1
#cd ../../../../
#rm -rf hardware/qcom-caf/wlan/
#git clone https://github.com/yaap/hardware_qcom-caf_wlan.git -b fifteen hardware/qcom-caf/wlan
#cd hardware/qcom-caf/wlan/
#git revert 715598c4ae72b83dd0094eff2d374c602a4d6fc5
#cd ../../../

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
mistify waffle user
make installclean -j$(nproc --all)

# Lunch and build the ROM
mistify waffle user
mist sb
