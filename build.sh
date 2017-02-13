#!/usr/bin/env bash

set -ex

TMP=$(mktemp -d /tmp/electronic-wechat-deb.XXXXXXXXXX)

VERSION=$UPSTREAM_VERSION-$CIRCLE_BUILD_NUM

cp -r src/dist/electronic-wechat-linux-x64 $TMP/usr/lib/electronic-wechat
echo "Electronic WeChat version $VERSION (amd64)" > $TMP/usr/lib/electronic-wechat/PKG_VERSION

# bin
mkdir -p $TMP/usr/bin
cp bin/wechat.sh $TMP/usr/bin/wechat

# share
mkdir -p $TMP/usr/share/applications
cat > $TMP/usr/share/applications/electronic-wechat.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Electronic WeChat
Comment=Electronic WeChat
Icon=electronic-wechat
Exec=wechat
Terminal=false
StartupNotify=true
EOF

declare -a sizes=("128x128" "16x16" "192x192" "20x20" "22x22" "24x24" "256x256" "32x32" "36x36" "40x40" "42x42" "48x48" "512x512" "64x64" "72x72" "8x8" "96x96")
for SIZE in "${sizes[@]}"
do
   echo "$SIZE"
   # convert using ImageMagick
   DIR=$TMP/usr/share/icons/hicolor/$SIZE/apps
   mkdir -p $DIR
   convert icon.png -resize $SIZE $DIR/electronic-wechat.png
done

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

mkdir -p dist
dpkg-deb --build $TMP dist/electronic-wechat-v$VERSION.deb
