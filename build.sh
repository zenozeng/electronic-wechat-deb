#!/usr/bin/env bash

set -ex

UPSTREAM_VERSION=1.4.0
UPSTREAM_PKG=electronic-wechat-v$UPSTREAM_VERSION.tar.gz
TMP=$(mktemp -d /tmp/electronic-wechat-deb.XXXXXXXXXX)

if [ ! -f $UPSTREAM_PKG ]; then
    aria2c -c https://github.com/geeeeeeeeek/electronic-wechat/releases/download/v$UPSTREAM_VERSION/linux-x64.tar.gz -o $UPSTREAM_PKG
fi
