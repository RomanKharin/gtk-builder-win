#!/bin/sh

# Change these reflecting your local host system

export DISTRO=Ubuntu
export ARCH=i686

# Change theese reflecting what crosscompiler target named 
#   (i686-pc-mingw32, i686-w64-mingw32, etc)

export CROSS_HOST=i686-pc-mingw32

# Change theese reflecting where final binaries should land

export NATIVEPREFIX="/srv/builds/gtk3.12_native"
export WIN32PREFIX="/srv/builds/gtk3.12_win32"

