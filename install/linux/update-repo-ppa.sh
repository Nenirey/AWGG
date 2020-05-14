#!/bin/bash

# This script updates AWGG Personal Package Archive (PPA) repository

# Set AWGG version
AWGG_VER=0.5.0
# Set Ubuntu series
DISTRO=( trusty vivid wily )

# Temp directory
AWGG_TEMP_DIR=/var/tmp/awgg-$(date +%y.%m.%d)
# Directory for DC source code
AWGG_SOURCE_DIR=$AWGG_TEMP_DIR/awgg-$AWGG_VER
# Directory for DC help
AWGG_HELP_DIR=$AWGG_TEMP_DIR/awgg-help-$AWGG_VER

# Recreate temp directory
rm -rf $AWGG_TEMP_DIR
mkdir -p $AWGG_TEMP_DIR

update_awgg()
{
  # Export from SVN
  svn export ../../ $AWGG_SOURCE_DIR

  # Save revision number
  AWGG_REVISION=`$(pwd)/update-revision.sh ../../ $AWGG_SOURCE_DIR`

  # Remove help files
  rm -rf $AWGG_SOURCE_DIR/doc/en
  rm -rf $AWGG_SOURCE_DIR/doc/ru
  rm -rf $AWGG_SOURCE_DIR/doc/uk

  # Create awgg-x.x.x.orig.tar.gz
  pushd $AWGG_SOURCE_DIR/..
  tar -cvzf $AWGG_TEMP_DIR/awgg_$AWGG_VER.orig.tar.gz awgg-$AWGG_VER
  popd

  # Prepare debian directory
  mkdir -p $AWGG_SOURCE_DIR/debian
  cp -r $AWGG_SOURCE_DIR/install/linux/deb/awgg/* $AWGG_SOURCE_DIR/debian

  # Create source package for each distro
  for DIST in "${DISTRO[@]}"
  do
    # Update changelog file
    pushd $AWGG_SOURCE_DIR/debian
    dch -D $DIST -v $AWGG_VER-0+svn$AWGG_REVISION~$DIST "Non-maintainer upload (revision $AWGG_REVISION)"
    popd

    # Create archive with source code
    pushd $AWGG_SOURCE_DIR
    if [ $DIST = ${DISTRO[0]} ]
      then
          debuild -S -sa
      else
          debuild -S -sd
    fi
    popd
  done
}

update_awgg_svn()
{
  # Export from SVN
  svn export ../../ $AWGG_SOURCE_DIR

  # Save revision number
  AWGG_REVISION=`$(pwd)/update-revision.sh ../../ $AWGG_SOURCE_DIR`

  # Prepare debian directory
  mkdir -p $AWGG_SOURCE_DIR/debian
  cp -r $AWGG_SOURCE_DIR/install/linux/deb/awgg/* $AWGG_SOURCE_DIR/debian
  echo '1.0' > $AWGG_SOURCE_DIR/debian/source/format

  # Create source package for each distro
  for DIST in "${DISTRO[@]}"
  do
    # Update changelog file
    pushd $AWGG_SOURCE_DIR/debian
    dch -D $DIST -v $AWGG_VER-0+svn$AWGG_REVISION~$DIST "Non-maintainer upload (revision $AWGG_REVISION)"
    popd

    # Create archive with source code
    pushd $AWGG_SOURCE_DIR
    debuild -S -sa
    popd
  done

  # Upload archives to PPA
  cd $AWGG_TEMP_DIR
  dput -U ppa:nenirey/awgg-svn $(ls -xrt --file-type *.changes)

  # Clean
  rm -rf $AWGG_TEMP_DIR

  # Exit
  exit 0
}

update_awgg_help()
{
  # Export from SVN
  svn export ../../doc $AWGG_HELP_DIR

  # Remove text files
  rm -f $AWGG_HELP_DIR/*.txt

  # Create awgg-help-x.x.x.orig.tar.gz
  pushd $AWGG_HELP_DIR/..
  tar -cvzf $AWGG_TEMP_DIR/awgg-help_$AWGG_VER.orig.tar.gz awgg-help-$AWGG_VER
  popd

  # Prepare debian directory
  svn export deb/awgg-help $AWGG_HELP_DIR/debian

  # Create source package for each distro
  for DIST in "${DISTRO[@]}"
  do
    # Update changelog file
    pushd $AWGG_HELP_DIR/debian
    dch -m -D $DIST -v $AWGG_VER-$AWGG_REVISION~$DIST "Update to revision $AWGG_REVISION"
    popd

    # Create archive with source code
    pushd $AWGG_HELP_DIR
    if [ $DIST = ${DISTRO[0]} ]
      then
          debuild -S -sa
      else
          debuild -S -sd
    fi
    popd
  done
}

update_all()
{
  update_awgg
  update_awgg_help
}

case $1 in
  awgg-help)  update_awgg_help;;
   awgg-svn)  update_awgg_svn;;
       awgg)  update_awgg;;
               *)  update_all;;
esac

# Upload archives to PPA
cd $AWGG_TEMP_DIR
dput -U ppa:nenirey/awgg $(ls -xrt --file-type *.changes)

# Clean
rm -rf $AWGG_TEMP_DIR
