#!/bin/bash

TOOLCHAIN="~/projects/tools/arm-eabi-4.6/bin/arm-eabi-"
KERNEL_DIR="."
MODULES_DIR="./out/system/lib/modules"
export PATH=~/projects/tools/arm-eabi-4.6/bin/:$PATH
export ARCH=arm
export CROSS_COMPILE=arm-eabi-

echo TOOLCHAIN: $TOOLCHAIN
echo KERNEL_DIR: $KERNEL_DIR
echo MODULES_DIR: $MODULES_DIR

cd kernel

mkdir -p $MODULES_DIR

echo "Cleaning modules"
rm ${MODULES_DIR}/*

./build.sh s7511 mrproper

if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
then
  echo "Copying modules"

  for line in $(find . -name *.ko | grep -v system/lib); do 
     echo "$line"
     cp "$line" $MODULES_DIR/
  done

  # cd $MODULES_DIR
  # echo "Stripping modules for size"
  # $(TOOLCHAIN)strip --strip-unneeded *.ko
  # cd $KERNEL_DIR
  # cd ..
  ../mediatek/build/tools/mkimage ./arch/arm/boot/zImage KERNEL > ./zImagePatched
else
  echo "Compilation failed! Fix the errors!"
fi
