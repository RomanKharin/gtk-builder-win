#!/bin/bash

MAJOR_VER=2
MINOR_VER=12
PATCH_VER=0
VERSION=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 51_atk
cd 51_atk
test -f atk-$VERSION.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/atk/$MAJOR_VER.$MINOR_VER/atk-$VERSION.tar.xz
xz -d -k -f atk-$VERSION.tar.xz
tar -xf atk-$VERSION.tar
cd atk-$VERSION

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --enable-shared --prefix=$PREFIX
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared --prefix=$PREFIX
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_51_atk-make.log
make install 2>&1 | tee ${LOGPREFIX}_51_atk-makeinstall.log

cd ..
rm -rf atk-$VERSION
rm -f atk-$VERSION.tar
