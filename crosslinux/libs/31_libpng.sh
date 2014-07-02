#!/bin/bash

MODVER=1.6.12

mkdir -p 31_libpng
cd 31_libpng
test -f libpng-$MODVER.tar.xz || wget http://sourceforge.net/projects/libpng/files/libpng16/$MODVER/libpng-$MODVER.tar.xz
xz -d -k -f libpng-$MODVER.tar.xz
tar -xf libpng-$MODVER.tar
cd libpng-$MODVER

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared  --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared  --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_31_libpng-make.log
make install 2>&1 | tee ${LOGPREFIX}_31_libpng-makeinstall.log


cd ..
rm -rf libpng-$MODVER
rm -f libpng-$MODVER.tar
