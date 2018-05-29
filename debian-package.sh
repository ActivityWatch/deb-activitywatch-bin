#!/bin/bash

set -e

# Following this: http://www.sj-vs.net/creating-a-simple-debian-deb-package-based-on-a-directory-structure/

VERSION_NUM="0.8.0b2"
VERSION="v$VERSION_NUM"
URL="https://github.com/ActivityWatch/activitywatch/releases/download/${VERSION}/activitywatch-${VERSION}-linux-x86_64.zip"
PKGDIR="activitywatch_$VERSION_NUM"

# Prerun cleanup
if [ -d "$PKGDIR" ]; then
    sudo chown -R $USER $PKGDIR
    rm -rf $PKGDIR
fi

# Create directories
mkdir -p $PKGDIR/DEBIAN
mkdir -p $PKGDIR/opt

# Move template files into DEBIAN
cp activitywatch_template/DEBIAN/* $PKGDIR/DEBIAN
sudo sed -i "s/Version: .*/Version: $VERSION_NUM/g" $PKGDIR/DEBIAN/control

# Get and unzip binary
wget --continue -O activitywatch-$VERSION-linux.zip $URL
unzip activitywatch-$VERSION-linux.zip -d $PKGDIR/opt/

# Set file permissions
sudo chown -R root:root $PKGDIR

dpkg-deb --build $PKGDIR
