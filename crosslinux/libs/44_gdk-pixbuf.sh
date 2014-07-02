#!/bin/bash

MAJOR_VER=2
MINOR_VER=30
PATCH_VER=8
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 44_gdk-pixbuf
cd 44_gdk-pixbuf
test -f gdk-pixbuf-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/gdk-pixbuf/$MAJOR_VER.$MINOR_VER/gdk-pixbuf-$MODVER.tar.xz
xz -d -k -f gdk-pixbuf-$MODVER.tar.xz
tar -xf gdk-pixbuf-$MODVER.tar
cd gdk-pixbuf-$MODVER

echo Save current linker flags for later restoration

LDFLAGS_SAVE="$LDFLAGS"

echo Add linker flag needed to compile with libtiff even if we deactive in configure

export LDFLAGS="$LDFLAGS -ltiff"

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --with-included-loaders --without-libtiff --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --with-included-loaders --prefix="$PREFIX"
fi
cp -f config.log ${LOGPREFIX}_44_gdk-pixbuf-config.log
make clean
make 2>&1 | tee ${LOGPREFIX}_44_gdk-pixbuf-make.log
make install 2>&1 | tee ${LOGPREFIX}_44_gdk-pixbuf-makeinstall.log

echo Restore original compiler flags

export LDFLAGS="LDFLAGS_SAVE"
unset LDFLAGS_SAVE

cd ..
rm -rf gdk-pixbuf-$MODVER
rm -f gdk-pixbuf-$MODVER.tar
