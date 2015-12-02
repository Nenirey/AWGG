#!/bin/sh
# Clean up all temporary files
find . -iname '*.compiled' -delete
find . -iname '*.ppu' -delete
find . -iname '*.o' -delete

rm -f src/awgg.res doublecmd
rm -f tools/extractdwrflnfo
rm -rf src/lib
rm -rf src/backup

# Remove debug files
rm -f  awgg.zdli awgg.dbg
rm -rf awgg.dSYM
rm -f awgg
