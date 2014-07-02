#!/bin/bash

MODVER=9a

mkdir -p 41_libjpeg
cd 41_libjpeg
test -f jpegsrc.v$MODVER.tar.gz || wget http://www.ijg.org/files/jpegsrc.v$MODVER.tar.gz
gzip -d -f -c jpegsrc.v$MODVER.tar.gz > jpegsrc.v$MODVER.tar
tar -xf jpegsrc.v$MODVER.tar
cd jpeg-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared  --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared  --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_41_libjpeg-make.log
make install 2>&1 | tee ${LOGPREFIX}_41_libjpeg-makeinstall.log

if [ "$BUILD_MODE" == "native" ]; then
    echo Patch an include file to not bring errors on amd64, and copy it to
    echo the install prefix after compile, as compile breaks with this patch...

    patch -p1 < ../jmorecfg-truefalse.patch
    cp -r jmorecfg.h "$PREFIX/include"
fi


cd ..
rm -rf jpeg-$MODVER
rm -f jpegsrc.v$MODVER.tar
