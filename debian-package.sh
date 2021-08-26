#!/bin/bash

set -e

# Following this: http://www.sj-vs.net/creating-a-simple-debian-deb-package-based-on-a-directory-structure/

[ -z $1 ] && VERSION_NUM="0.9.2" || VERSION_NUM=$1
VERSION="v$VERSION_NUM"
URL="https://github.com/ActivityWatch/activitywatch/releases/download/${VERSION}/activitywatch-${VERSION}-linux-x86_64.zip"
PKGDIR="activitywatch_$VERSION_NUM"

#install tools needed for packaging
# sudo apt-get install sed jdupes wget

# Prerun cleanup
if [ -d "$PKGDIR" ]; then
    chown -R $USER $PKGDIR
    rm -rf $PKGDIR
fi

# Create directories
mkdir -p $PKGDIR/DEBIAN
mkdir -p $PKGDIR/opt
mkdir -p $PKGDIR/etc/xdg/autostart

# Move template files into DEBIAN
cp activitywatch_template/DEBIAN/* $PKGDIR/DEBIAN
sed -i "s/Version: .*/Version: $VERSION_NUM/g" $PKGDIR/DEBIAN/control

# Get and unzip binary
wget --continue -O activitywatch-$VERSION-linux.zip $URL
unzip -q activitywatch-$VERSION-linux.zip -d $PKGDIR/opt/

# Hard link duplicated libraries
jdupes -L -r -S -Xsize-:1K $PKGDIR/opt/

#setup autostart file
sed -i 's!Exec=aw-qt!Exec=/opt/activitywatch/aw-qt!' $PKGDIR/opt/activitywatch/aw-qt.desktop
cp $PKGDIR/opt/activitywatch/aw-qt.desktop $PKGDIR/etc/xdg/autostart

dpkg-deb --build $PKGDIR
