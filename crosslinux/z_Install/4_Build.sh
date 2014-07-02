#!/bin/sh


# 1) native build, required for some tools needed during win32 build later
export BUILD_MODE=native

# Source variables here, please modify this script only
source ./vars.sh

# PRENATIVE
export LOGPREFIX=../../logs/n
export PREFIX="$NATIVEPREFIX"
export PATH="$PATH:$PREFIX/bin"
export CFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export PKG_CONFIG=/usr/bin/pkg-config
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig"
export XDG_DATA_DIRS="$PREFIX/share"

if [ "$ARCH" == "amd64" ]; then
	export LDFLAGS="$LDFLAGS -L$PREFIX/lib64"
fi
# PRENATIVEEND

# Compile native stack
cd ../libs/
mkdir -p logs
./BUILD_ALL_NATIVE.sh
cd ../z_Install/

# POSTNATIVE
# copy some of the necessary native tools to "cache" dir
cp "$PREFIX/bin/glib-genmarshal" cache/
cp "$PREFIX/bin/glib-compile-schemas" cache/
cp "$PREFIX/bin/glib-compile-resources" cache/
cp "$PREFIX/bin/gdk-pixbuf-query-loaders" cache/
cp "$PREFIX/bin/gtk-update-icon-cache" cache/
cp "$PREFIX/bin/gtk-query-immodules-3.0" cache/
cp "$PREFIX/bin/gtk-extract-strings" cache/
# POSTNATIVEEND

# add "cache" dir to PATH
export PATH="$PATH:$PWD/cache"

# 2) win32 build
export BUILD_MODE=win32

# Source variables here, please modify this script only
source ./vars.sh

# PREWIN32
export LOGPREFIX=../../logs/w
export PREFIX="$WIN32PREFIX"
export PATH="$PATH:$PREFIX/bin"
export CFLAGS="-I$PREFIX/include"
export CPPFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export PKG_CONFIG=/usr/bin/pkg-config
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig"
export XDG_DATA_DIRS="$PREFIX/share"
# PREWIN32END

# Compile win32 stack
cd ../libs/
./BUILD_ALL_WIN32.sh
cd ../z_Install/

