#!/bin/bash

set -e

# Following this: http://www.sj-vs.net/creating-a-simple-debian-deb-package-based-on-a-directory-structure/

VERSION="v0.8.0b2"
URL="https://github.com/ActivityWatch/activitywatch/releases/download/v0.8.0b2/activitywatch-${VERSION}-linux-x86_64.zip"

# Prerun cleanup
sudo chown -R $USER activitywatch_$VERSION
rm -rf activitywatch_$VERSION/opt

# Create directories
mkdir -p activitywatch_$VERSION/DEBIAN
mkdir -p activitywatch_$VERSION/opt

# Get and unzip binary
wget --continue -O activitywatch-linux.zip $URL
unzip activitywatch-linux.zip -d activitywatch_$VERSION/opt/

# Set file permissions
sudo chown -R root:root activitywatch_$VERSION

dpkg-deb --build activitywatch_$VERSION
