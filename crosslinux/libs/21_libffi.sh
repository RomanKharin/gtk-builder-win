#!/bin/bash

MODVER=3.1

mkdir -p 21_libffi
cd 21_libffi
test -f libffi-$MODVER.tar.gz || wget ftp://sourceware.org/pub/libffi/libffi-$MODVER.tar.gz
gzip -d -f -c libffi-$MODVER.tar.gz > libffi-$MODVER.tar
tar -xf libffi-$MODVER.tar
cd libffi-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_21_libffi-make.log
make install 2>&1 | tee ${LOGPREFIX}_21_libffi-makeinstall.log


cd ..
rm -rf libffi-$MODVER
rm -r libffi-$MODVER.tar
