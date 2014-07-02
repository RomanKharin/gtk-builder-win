#!/bin/bash

MAJOR_VER=2
MINOR_VER=40
PATCH_VER=2
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 62_librsvg
cd 62_librsvg
test -f librsvg-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/librsvg/$MAJOR_VER.$MINOR_VER/librsvg-$MODVER.tar.xz
xz -d -k -f librsvg-$MODVER.tar.xz
tar -xf librsvg-$MODVER.tar
cd librsvg-$MODVER

echo Warning, the main script should have taken care of putting required native
echo utils like gdk-pixbuf-query-loaders in an accessible path. Otherwise, it will fail.

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --disable-gtk-theme --enable-pixbuf-loader --enable-introspection=no  --prefix=$PREFIX
else
    cp ../realpath.c .
    patch -p0 < ../rsvg-base.diff
    ./configure --host=$CROSS_HOST --disable-gtk-theme --enable-pixbuf-loader --enable-introspection=no  --prefix=$PREFIX
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_62_librsvg-make.log
make install 2>&1 | tee ${LOGPREFIX}_62_librsvg-makeinstall.log


cd ..
rm -rf librsvg-$MODVER
rm -f librsvg-$MODVER.tar
