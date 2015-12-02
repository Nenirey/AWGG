#!/bin/sh 

set -e

# if you compile first time you must change variable "lazpath" and "lcl"
# after it execute this script with parameter "all" at awgg dir
# "./build.sh all" it build awgg
#                                                 by Segator


# You can execute this script with different parameters:
# default - compiling AWGG only (using by default)

# path to lazbuild
export lazbuild=$(which lazbuild)

# Set up widgetset: gtk or gtk2 or qt
# Set up processor architecture: i386 or x86_64
if [ $2 ]
  then export lcl=$2
fi
if [ $lcl ] && [ $CPU_TARGET ]
  then export AWGG_ARCH=$(echo "--widgetset=$lcl")" "$(echo "--cpu=$CPU_TARGET")
elif [ $lcl ]
  then export AWGG_ARCH=$(echo "--widgetset=$lcl")
elif [ $CPU_TARGET ]
  then export AWGG_ARCH=$(echo "--cpu=$CPU_TARGET")
fi

build_default()
{
  $lazbuild src/awgg.lpi $AWGG_ARCH
  
  strip awgg
}

build_beta()
{

  # Build AWGG
  $lazbuild src/awgg.lpi --bm=beta $AWGG_ARCH
  
  # Build Dwarf LineInfo Extractor
  $lazbuild tools/extractdwrflnfo.lpi
  
  # Extract debug line info
  chmod a+x tools/extractdwrflnfo
  if [ -f awgg.dSYM/Contents/Resources/DWARF/awgg ]; then
    mv -f awgg.dSYM/Contents/Resources/DWARF/awgg $(pwd)/awgg.dbg
  fi
  tools/extractdwrflnfo awgg.dbg
  
  # Strip debug info
  strip awgg
}

build_all()
{
  build_default
}


case $1 in
        beta)  build_beta;;
         all)  build_all;;
           *)  build_default;;
esac
