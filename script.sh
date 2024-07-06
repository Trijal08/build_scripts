
#!/bin/bash

rm -rf .repo/local_manifests/

# repo init rom
sudo apt install git-lfs git lfs install ;
repo init -u https://github.com/Evolution-XYZ/manifest -b udc --git-lfs
echo "=================="
echo "Repo init success"
echo "=================="

# Local manifests
git clone https://github.com/Gtajisam/local_manifests -b Project-Sakura .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# build
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# keys
mkdir vendor/lineage-priv
cp build-keys/* vendor/lineage-priv
echo "============="
echo "Keys copied"
echo "============="

# Export
export BUILD_USERNAME=FARHAN-MUH-TASIM
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
echo "====== Envsetup Done ======="

# Lunch
lunch lineage_Mi439_4_19-ap2a-userdebug || lunch lineage_Mi439_4_19-ap1a-userdebug
echo "============="

# Make cleaninstall
make installclean
echo "============="

# Build rom
mka bacon
