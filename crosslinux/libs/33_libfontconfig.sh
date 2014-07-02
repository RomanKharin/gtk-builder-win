#!/bin/bash

MODVER=2.11.1

mkdir -p 33_libfontconfig
cd 33_libfontconfig
test -f fontconfig-$MODVER.tar.gz || wget http://www.freedesktop.org/software/fontconfig/release/fontconfig-$MODVER.tar.gz
gzip -d -f -c fontconfig-$MODVER.tar.gz > fontconfig-$MODVER.tar
tar -xf fontconfig-$MODVER.tar
cd fontconfig-$MODVER

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --enable-libxml2 --disable-docs --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared --enable-libxml2 --disable-docs --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_33_libfontconfig-make.log
make install 2>&1 | tee ${LOGPREFIX}_33_libfontconfig-makeinstall.log


cd ..
rm -rf fontconfig-$MODVER
rm -f fontconfig-$MODVER.tar
