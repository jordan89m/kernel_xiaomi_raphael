#!/bin/bash
rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
DEFCONFIG="raphael_defconfig"

# Kernel Details
VER="R.1"

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR=/datadrive/AnyKernel3
ZIP_MOVE=/datadrive/AK-releases

# Functions
function clean_all {
		rm -rf $REPACK_DIR/Image*
		cd $KERNEL_DIR
		echo
		make clean && make mrproper
}

function make_kernel {
		echo
		make $DEFCONFIG
		make -j12
}


function make_boot {
		cp out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR
}


function make_zip {
		cd $REPACK_DIR
		zip -r9 `echo $ZIP_NAME`.zip *
		mv  `echo $ZIP_NAME`*.zip $ZIP_MOVE
		cd $KERNEL_DIR
}


DATE_START=$(date +"%s")


echo -e "${green}"
echo "-----------------"
echo "Making Kernel:"
echo "-----------------"
echo -e "${restore}"


# Vars
BASE_AK_VER="SOVIET-NETHUNTER-K20P-"
DATE=`date +"%Y%m%d-%H%M"`
AK_VER="$BASE_AK_VER$VER"
ZIP_NAME="$AK_VER"-"$DATE"
#export LOCALVERSION=~`echo $AK_VER`
#export LOCALVERSION=~`echo $AK_VER`
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=NATO66613
export KBUILD_BUILD_HOST=KREMLIN

echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build?" dchoice
do
case "$dchoice" in
	y|Y )
		make_kernel
		make_boot
                make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done


echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
