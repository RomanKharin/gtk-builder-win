#!/bin/bash

MODVER=4.0.3

mkdir -p 43_libtiff
cd 43_libtiff
test -f tiff-$MODVER.tar.gz || wget http://download.osgeo.org/libtiff/tiff-$MODVER.tar.gz
gzip -d -f -c tiff-$MODVER.tar.gz > tiff-$MODVER.tar
tar -xf tiff-$MODVER.tar
cd tiff-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared  --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared  --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_43_libtiff-make.log
make install 2>&1 | tee ${LOGPREFIX}_43_libtiff-makeinstall.log


cd ..
rm -rf tiff-$MODVER
rm -f tiff-$MODVER.tar
