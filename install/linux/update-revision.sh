#!/bin/sh

# AWGG revision number
export AWGG_REVISION=$(svnversion $1 | sed -e 's/\([0-9]*\).*/\1/')

# Update awggrevision.inc
echo "// Created by Svn2RevisionInc"      >  $2/src/awggrevision.inc
echo "const awggRevision = '$AWGG_REVISION';" >> $2/src/awggrevision.inc

# Return revision
echo $AWGG_REVISION
