#!/usr/bin/env bash

case $1 in
    # --version
    -V|--version)
    cat /usr/lib/electronic-wechat/PKG_VERSION
    ;;

    # Default
    *)
    /usr/lib/electronic-wechat/electronic-wechat
    ;;
esac