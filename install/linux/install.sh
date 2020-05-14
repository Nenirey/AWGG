#!/bin/bash

set -e

# Set processor architecture
if [ -z $CPU_TARGET ]; then
   export CPU_TARGET=$(fpc -iTP)
fi

# Determine library directory
if [ "$CPU_TARGET" = "x86_64" ] && [ ! -f "/etc/debian_version" ]
   then
       LIB_SUFFIX=64
   else
       LIB_SUFFIX=
fi

# Parse input parameters
CKNAME=$(basename "$0")
args=$(getopt -n $CKNAME -o P:,I: -l portable-prefix:,install-prefix:,default -- "$@")
eval set -- $args
for A
do
  case "$A" in
       --)
            AWGG_INSTALL_DIR=/usr/lib$LIB_SUFFIX/awgg
            ;;
        -P|--portable-prefix)
            shift
            CK_PORTABLE=1
            AWGG_INSTALL_DIR=$(eval echo $1/awgg)
            break
            ;;
        -I|--install-prefix)
            shift
            AWGG_INSTALL_PREFIX=$(eval echo $1)
            AWGG_INSTALL_DIR=$DC_INSTALL_PREFIX/usr/lib$LIB_SUFFIX/awgg
            break
            ;;
  esac
  shift
done

mkdir -p $AWGG_INSTALL_DIR

# Copy files
cp -a awgg                    $AWGG_INSTALL_DIR/
cp -a awgg.zdli               $AWGG_INSTALL_DIR/

if [ -z $CK_PORTABLE ]
  then
    # Create directory for platform independed files
    install -d                $AWGG_INSTALL_PREFIX/usr/share/awgg
    # Copy languages
    cp -r language $AWGG_INSTALL_PREFIX/usr/share/awgg
    ln -sf ../../share/doublecmd/language $AWGG_INSTALL_DIR/language
    # Create symlink and desktop files
    install -d $AWGG_INSTALL_PREFIX/usr/bin
    install -d $AWGG_INSTALL_PREFIX/usr/share/applications
    ln -sf  ../lib$LIB_SUFFIX/awgg/awgg $AWGG_INSTALL_PREFIX/usr/bin/awgg
    install -m 644 awgg.png $AWGG_INSTALL_PREFIX/usr/share/awgg.png
    install -m 644 install/linux/awgg.desktop $AWGG_INSTALL_PREFIX/usr/share/applications/awgg.desktop
  else
    # Copy script for execute portable version
    cp -a awgg.sh $AWGG_INSTALL_DIR/
    # Copy directories
    cp -r language $DC_INSTALL_DIR/
    # Copy AWGG icon
    cp -a awgg.png     $DC_INSTALL_DIR/awgg.png
fi
