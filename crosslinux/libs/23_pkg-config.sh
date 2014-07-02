#!/bin/bash

MODVER=0.28

mkdir -p 23_pkg-config
cd 23_pkg-config
test -f pkg-config-$MODVER.tar.gz || wget http://pkgconfig.freedesktop.org/releases/pkg-config-$MODVER.tar.gz
gzip -d -f -c pkg-config-$MODVER.tar.gz > pkg-config-$MODVER.tar
tar -xf pkg-config-$MODVER.tar
cd pkg-config-$MODVER

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared  --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared  --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_23_pkg-config-make.log
make install 2>&1 | tee ${LOGPREFIX}_23_pkg-config-makeinstall.log


cd ..
rm -rf pkg-config-$MODVER
rm -f pkg-config-$MODVER.tar
