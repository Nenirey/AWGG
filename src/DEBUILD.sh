#!/bin/sh

set -v
set -e
cd "/datos/reinier/AWGG/src3"
mkdir -p /tmp/awgg-0.3.8.2702
cp *.lpi /tmp/awgg-0.3.8.2702/
cp *.lpr /tmp/awgg-0.3.8.2702/
cp *.pas /tmp/awgg-0.3.8.2702/
cp *.lfm /tmp/awgg-0.3.8.2702/
cp *.ico /tmp/awgg-0.3.8.2702/
cp version /tmp/awgg-0.3.8.2702/
cp languages -r /tmp/awgg-0.3.8.2702/



cd /tmp/awgg-0.3.8.2702
rm -rf DEBUILD
rm -f DEBUILD.sh

cd ..
tar czf awgg_0.3.8.2702.orig.tar.gz awgg-0.3.8.2702
mv awgg-0.3.8.2702 "/datos/reinier/AWGG/src3/DEBUILD"
mv awgg_0.3.8.2702.orig.tar.gz "/datos/reinier/AWGG/src3/DEBUILD"

cd "/datos/reinier/AWGG/src3/DEBUILD/awgg-0.3.8.2702"
mkdir -p debian/source
echo "1.0" > debian/source/format
echo "8" > debian/compat
mv ../control debian/
mv ../rules debian/
chmod +x debian/rules
mv ../changelog debian/
mv ../copyright debian/
debuild -us -uc -d -b
cd ..
xterm -e "debsign *.changes"
