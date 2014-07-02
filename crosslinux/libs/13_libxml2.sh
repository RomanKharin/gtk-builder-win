#!/bin/bash

MODVER=2.8.0

mkdir -p 13_libxml2
cd 13_libxml2
test -f libxml2-$MODVER.tar.gz || wget http://xmlsoft.org/sources/libxml2-$MODVER.tar.gz
gzip -d -f -c libxml2-$MODVER.tar.gz > libxml2-$MODVER.tar
tar -xf libxml2-$MODVER.tar
cd libxml2-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_13_libxml2-make.log
make install 2>&1 | tee ${LOGPREFIX}_13_libxml2-makeinstall.log


cd ..
rm -rf libxml2-$MODVER
rm -f libxml2-$MODVER.tar
