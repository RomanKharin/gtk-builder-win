#!/bin/bash

MODVER=1.13.1

mkdir -p 01_libiconv
cd 01_libiconv
test -f libiconv-$MODVER.tar.gz || wget http://ftp.gnu.org/gnu/libiconv/libiconv-$MODVER.tar.gz
gzip -d -f -c libiconv-$MODVER.tar.gz > libiconv-$MODVER.tar
tar -xf libiconv-$MODVER.tar
cd libiconv-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_01_libiconv-make.log
make install 2>&1 | tee ${LOGPREFIX}_01_libiconv-makeinstall.log


cd ..
rm -rf libiconv-$MODVER
rm -f libiconv-$MODVER.tar
