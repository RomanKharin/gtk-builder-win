#!/bin/bash

MODVER=5.0.5

mkdir -p 12_xz
cd 12_xz
test -f xz-$MODVER.tar.bz2 || wget http://tukaani.org/xz/xz-$MODVER.tar.bz2
bzip2 -d -k -f xz-$MODVER.tar.bz2
tar -xf xz-$MODVER.tar
cd xz-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_12_xz-make.log
make install 2>&1 | tee ${LOGPREFIX}_12_xz-makeinstall.log


cd ..
rm -rf xz-$MODVER
rm -f xz-$MODVER.tar
