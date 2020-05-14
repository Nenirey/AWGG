#!/bin/bash

# This script updates AWGG Open Build Service (OBS) repository

# Set AWGG version
AWGG_VER=0.5.0

# Temp directory
AWGG_TEMP_DIR=/var/tmp/awgg-$(date +%y.%m.%d)
# Directory for DC source code
AWGG_SOURCE_DIR=$AWGG_TEMP_DIR/awgg-$AWGG_VER
# Directory for DC help
AWGG_HELP_DIR=$AWGG_TEMP_DIR/awgg-help-$AWGG_VER
# Directory for the openSUSE Build Service (OBS)
AWGG_OBS_DIR=$HOME/.obs
# OBS project home directory
AWGG_OBS_WEB_DIR=home:Segator
# OBS project directory
AWGG_OBS_PRJ_DIR=$AWGG_OBS_DIR/$AWGG_OBS_WEB_DIR

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

  # Prepare awgg-*.spec file
  cp -a rpm/awgg-*.spec $AWGG_TEMP_DIR

  # Create archive with source code
  pushd $AWGG_TEMP_DIR
  tar -cvzf awgg-$AWGG_VER.tar.gz awgg-$AWGG_VER

  if [ ! -d "$AWGG_OBS_DIR" ]
    then
      mkdir -p $AWGG_OBS_DIR
      cd $AWGG_OBS_DIR
      osc checkout $AWGG_OBS_WEB_DIR
    else
      pushd $AWGG_OBS_PRJ_DIR/awgg-gtk
      osc up
      popd
      pushd $AWGG_OBS_PRJ_DIR/awgg-qt
      osc up
      popd      
  fi

  # Upload GTK2 archive to OBS
  rm -f $AWGG_OBS_PRJ_DIR/awgg-gtk/awgg-gtk.spec
  rm -f $AWGG_OBS_PRJ_DIR/awgg-gtk/awgg-$AWGG_VER.tar.gz
  mv awgg-gtk.spec $AWGG_OBS_PRJ_DIR/awgg-gtk/
  cp -a awgg-$AWGG_VER.tar.gz $AWGG_OBS_PRJ_DIR/awgg-gtk/
  pushd $AWGG_OBS_PRJ_DIR/awgg-gtk
  osc commit awgg-gtk.spec awgg-$AWGG_VER.tar.gz -m "Update to revision $AWGG_REVISION"
  popd
  
  # Upload Qt4 archive to OBS
  rm -f $AWGG_OBS_PRJ_DIR/awgg-qt/awgg-qt.spec
  rm -f $AWGG_OBS_PRJ_DIR/awgg-qt/awgg-$AWGG_VER.tar.gz
  mv awgg-qt.spec $AWGG_OBS_PRJ_DIR/awgg-qt/
  cp -a awgg-$AWGG_VER.tar.gz $AWGG_OBS_PRJ_DIR/awgg-qt/
  pushd $AWGG_OBS_PRJ_DIR/awgg-qt
  osc commit awgg-qt.spec awgg-$AWGG_VER.tar.gz -m "Update to revision $AWGG_REVISION"
  popd

  popd
}

update_awgg_svn()
{
  trap "stty echo; echo; exit" INT TERM EXIT
  read -s -p "Enter password: " PASSWORD; echo
  echo "Update AWGG (Qt)"
  curl -u Segator:$PASSWORD -X POST https://api.opensuse.org/source/home:Segator:awgg-svn/awgg-qt?cmd=runservice
  echo "Update AWGG (Gtk)"
  curl -u Segator:$PASSWORD -X POST https://api.opensuse.org/source/home:Segator:awgg-svn/awgg-gtk?cmd=runservice
  echo "Update AWGG (Debian)"
  curl -u Segator:$PASSWORD -X POST https://api.opensuse.org/source/home:Segator:awgg-svn/awgg-deb?cmd=runservice
  exit 0
}

update_awgg_help()
{
  # Export from SVN
  svn export ../../doc $AWGG_HELP_DIR

  # Remove text files
  rm -f $AWGG_HELP_DIR/*.txt

  # Prepare awgg-help.spec file
  cp -a rpm/awgg-help.spec $AWGG_TEMP_DIR

  # Create archive with source code
  pushd $AWGG_TEMP_DIR
  tar -cvzf awgg-help-$AWGG_VER.tar.gz awgg-help-$AWGG_VER

  if [ ! -d "$AWGG_OBS_DIR" ]
    then
      mkdir -p $AWGG_OBS_DIR
      cd $AWGG_OBS_DIR
      osc checkout $AWGG_OBS_WEB_DIR
    else
      pushd $AWGG_OBS_PRJ_DIR/awgg-help
      osc up
      popd
  fi

  # Upload archive to OBS
  rm -f $AWGG_OBS_PRJ_DIR/awgg-help/awgg-help.spec
  rm -f $AWGG_OBS_PRJ_DIR/awgg-help/awgg-help-$AWGG_VER.tar.gz
  mv awgg-help.spec $AWGG_OBS_PRJ_DIR/awgg-help/
  mv awgg-help-$AWGG_VER.tar.gz $AWGG_OBS_PRJ_DIR/awgg-help/
  cd $AWGG_OBS_PRJ_DIR/awgg-help
  osc commit awgg-help.spec awgg-help-$AWGG_VER.tar.gz -m "Update to revision $AWGG_REVISION"
  popd
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

# Clean
rm -rf $AWGG_TEMP_DIR
