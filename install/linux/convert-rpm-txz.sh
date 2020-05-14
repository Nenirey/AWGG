#!/bin/bash

# This script converts *.rpm package to portable package

# Script directory
SCRIPT_DIR=$(pwd)

# Source directory
AWGG_SOURCE_DIR=$SCRIPT_DIR/../..

# The new package will be saved here
PACK_DIR=$SCRIPT_DIR/release

# Temp directory
AWGG_TEMP_DIR=/var/tmp/awgg-$(date +%y.%m.%d)

# Root directory
AWGG_ROOT_DIR=$AWGG_TEMP_DIR/awgg

# Base file name
BASE_NAME=$(basename $1 .rpm)

# Set widgetset
LCL_PLATFORM=$(echo $BASE_NAME | grep -Po '(?<=awgg-)[^-]+')

# Set version
AWGG_VER=$(echo $BASE_NAME | grep -Po "(?<=awgg-$LCL_PLATFORM-)[^-]+")

# Set processor architecture
CPU_TARGET=${BASE_NAME##*.}
if [ "$CPU_TARGET" = "i686" ]; then
  export CPU_TARGET=i386
fi

# Update widgetset
if [ "$LCL_PLATFORM" = "gtk" ]; then
  export LCL_PLATFORM=gtk2
fi

# Recreate temp directory
rm -rf $AWGG_TEMP_DIR
mkdir -p $AWGG_TEMP_DIR

pushd $DC_TEMP_DIR

$SCRIPT_DIR/rpm2cpio.sh $1 | cpio -idmv

if [ "$CPU_TARGET" = "x86_64" ]
  then
    mv usr/lib64/awgg ./
  else
    mv usr/lib/awgg   ./
fi

# Remove symlinks
rm -f awgg/language


# Move directories and files
mv usr/share/awgg/language                  $AWGG_ROOT_DIR/
mv usr/share/pixmaps/doublecmd.png               $AWGG_ROOT_DIR/

# Copy libraries
pushd $AWGG_SOURCE_DIR/install/linux
cp -a lib/$CPU_TARGET/*.so*                      $AWGG_ROOT_DIR/
cp -a lib/$CPU_TARGET/$LCL_PLATFORM/*.so*        $AWGG_ROOT_DIR/
popd

# Copy script for execute portable version
install -m 755 $DC_SOURCE_DIR/awgg.sh       $AWGG_ROOT_DIR/


# Create archive
tar -cJvf $PACK_DIR/awgg-$DC_VER.$LCL_PLATFORM.$CPU_TARGET.tar.xz awgg

popd

# Clean
rm -rf $AWGG_TEMP_DIR
