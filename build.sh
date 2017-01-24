#!/usr/bin/env bash

set -ex

UPSTREAM_VERSION=1.4.0
UPSTREAM_PKG=electronic-wechat-v$UPSTREAM_VERSION.tar.gz
VERSION = $UPSTREAM_VERSION-1
TMP=$(mktemp -d /tmp/electronic-wechat-deb.XXXXXXXXXX)

if [ ! -f $UPSTREAM_PKG ]; then
    aria2c -c https://github.com/geeeeeeeeek/electronic-wechat/releases/download/v$UPSTREAM_VERSION/linux-x64.tar.gz -o $UPSTREAM_PKG
fi

mkdir -p $TMP/data/usr/lib/electronic-wechat
tar -zxvf $UPSTREAM_PKG -C $TMP/data/usr/lib/electronic-wechat/ --strip-components=1
echo "Electronic WeChat version $VERSION (amd64)" > $TMP/data/usr/lib/electronic-wechat/PKG_VERSION

cat bin/wechat.sh > $TMP/data/usr/bin/wechat

xdg-open $TMP