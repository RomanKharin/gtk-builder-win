#!/bin/bash

MAJOR_VER=0
MINOR_VER=6
PATCH_VER=8
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 61_libcroco
cd 61_libcroco
test -f libcroco-$MODVER.tar.xz || wget http://ftp.gnome.org/pub/GNOME/sources/libcroco/$MAJOR_VER.$MINOR_VER/libcroco-$MODVER.tar.xz
xz -d -k -f libcroco-$MODVER.tar.xz
tar -xf libcroco-$MODVER.tar
cd libcroco-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --prefix=$PREFIX
else
    ./configure --host=$CROSS_HOST  --prefix=$PREFIX
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_61_libcroco-make.log
make install 2>&1 | tee ${LOGPREFIX}_61_libcroco-makeinstall.log

cd ..
rm -rf libcroco-$MODVER
rm -f libcroco-$MODVER.tar
