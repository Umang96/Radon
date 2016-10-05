#
# Custom build script for Radon kernel
#
# Copyright 2016 Umang Leekha (Umang96@xda)
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it.
#

yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$gre ====================================\n\n Welcome to Radon building program !\n\n ====================================\n\n 1.Build Radon tomato\n\n 2.Build Radon lettuce\n"
echo -n " Enter your choice:"
read build
echo -e "$white"
KERNEL_DIR=$PWD
cd arch/arm/boot/dts/
rm .msm8916*
rm *.dtb
cd $KERNEL_DIR
Start=$(date +"%s")
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/$USER/toolchain/aarch64-linux-linaro-android-4.9/bin/aarch64-linux-android-"
export LD_LIBRARY_PATH=home/$USER/toolchain/aarch64-linux-linaro-android-4.9/lib/
STRIP="/home/$USER/toolchain/aarch64-linux-linaro-android-4.9/bin/aarch64-linux-android-strip"
make clean
if [ $build == 1 ]; then
make cyanogenmod_tomato-64_defconfig
elif [ $build == 2 ]; then
make cyanogenmod_lettuce-64_defconfig
fi
export KBUILD_BUILD_HOST="lenovo"
export KBUILD_BUILD_USER="umang"
make -j4
time=$(date +"%d-%m-%y-%T")
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt.img
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/build/modules/wlan.ko
cd $KERNEL_DIR/build/modules/
$STRIP --strip-unneeded wlan.ko
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build
rm *.zip
if [ $build == 1 ]; then
zip -r Radon-Tomato-Cm-Mm.zip *
elif [ $build == 2 ]; then
zip -r Radon-Lettuce-Cm-Mm.zip *
fi
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >>$white"
cd $KERNEL_DIR
fi
