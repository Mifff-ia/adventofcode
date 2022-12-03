#!/bin/sh

basedir="$(dirname "$0")"
rm "$basedir/"*.hi "$basedir/"*.o
find "$basedir" -type f ! -iname "*.*" -delete
