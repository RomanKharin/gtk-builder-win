#!/bin/bash

MODVER=1.12.16

mkdir -p 35_cairo
cd 35_cairo
test -f cairo-$MODVER.tar.xz || wget http://cairographics.org/releases/cairo-$MODVER.tar.xz
xz -d -k -f cairo-$MODVER.tar.xz
tar -xf cairo-$MODVER.tar
cd cairo-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-png=yes --enable-ft=yes --enable-fc=yes --enable-static --disable-shared --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-win32=yes --enable-win32-font=yes --enable-png=yes --enable-ft=yes --enable-fc=yes --enable-xlib=no --enable-static --enable-shared --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_35_cairo-make.log
make install 2>&1 | tee ${LOGPREFIX}_35_cairo-makeinstall.log


cd ..
rm -rf cairo-$MODVER
rm -f cairo-$MODVER.tar
