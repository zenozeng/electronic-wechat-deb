#!/usr/bin/env bash

set -ex

UPSTREAM_VERSION=1.4.0
UPSTREAM_PKG=electronic-wechat-v$UPSTREAM_VERSION.tar.gz
VERSION=$UPSTREAM_VERSION-5
TMP=$(mktemp -d /tmp/electronic-wechat-deb.XXXXXXXXXX)

if [ ! -f $UPSTREAM_PKG ]; then
    aria2c -c https://github.com/geeeeeeeeek/electronic-wechat/releases/download/v$UPSTREAM_VERSION/linux-x64.tar.gz -o $UPSTREAM_PKG
fi

# lib
mkdir -p $TMP/usr/lib/electronic-wechat
tar -zxvf $UPSTREAM_PKG -C $TMP/usr/lib/electronic-wechat/ --strip-components=1
echo "Electronic WeChat version $VERSION (amd64)" > $TMP/usr/lib/electronic-wechat/PKG_VERSION


# bin
mkdir -p $TMP/usr/bin
cp bin/wechat.sh $TMP/usr/bin/wechat

# share
mkdir -p $TMP/usr/share/applications
cat > $TMP/usr/share/applications/electronic-wechat.desktop <<EOF
[Desktop Entry]
Name=electronic-wechat
Comment=Electronic WeChat
Exec="/usr/bin/electronic-wechat"
Terminal=false
Type=Application
Icon=electronic-wechat
EOF


# control
mkdir -p $TMP/DEBIAN

cat > $TMP/DEBIAN/control <<EOF
Package: electronic-wechat
Version: $VERSION
License: MIT
Section: default
Priority: extra
Architecture: amd64
Installed-Size: 46118611
Depends: gconf2, gconf-service, libnotify4, libappindicator1, libxtst6, libnss3
Maintainer: Zeno Zeng <zenoofzeng@gmail.com>
Homepage: https://github.com/geeeeeeeeek/electronic-wechat
Description: A better WeChat on macOS and Linux. Built with Electron.
EOF



dpkg-deb --build $TMP electronic-wechat-v$VERSION.deb