#!/bin/sh

# AWGG revision number
export AWGG_REVISION=4937

# Update awggrevision.inc
echo "// Created by Svn2RevisionInc"      >  ../src/awggrevision.inc
echo "const awggRevision = '$AWGG_REVISION';" >> ../src/awggrevision.inc

# Return revision
echo $AWGG_REVISION
