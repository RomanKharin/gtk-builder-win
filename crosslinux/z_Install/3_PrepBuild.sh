#!/bin/sh

# Source variables here, please modify this script only
source ./vars.sh

mkdir -p cache/

# Create both native & win32 target directory trees

mkdir -p "$NATIVEPREFIX"
mkdir -p "$NATIVEPREFIX/bin"
mkdir -p "$NATIVEPREFIX/etc"
mkdir -p "$NATIVEPREFIX/include"
mkdir -p "$NATIVEPREFIX/lib"
mkdir -p "$NATIVEPREFIX/lib/pkgconfig"
mkdir -p "$NATIVEPREFIX/share"

mkdir -p "$WIN32PREFIX"
mkdir -p "$WIN32PREFIX/bin"
mkdir -p "$WIN32PREFIX/etc"
mkdir -p "$WIN32PREFIX/include"
mkdir -p "$WIN32PREFIX/lib"
mkdir -p "$WIN32PREFIX/lib/pkgconfig"
mkdir -p "$WIN32PREFIX/share"

