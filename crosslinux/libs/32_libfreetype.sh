#!/bin/bash

MODVER=2.5.3

mkdir -p 32_libfreetype
cd 32_libfreetype
test -f freetype-$MODVER.tar.bz2 || wget http://download.savannah.gnu.org/releases/freetype/freetype-$MODVER.tar.bz2
bzip2 -d -k -f freetype-$MODVER.tar.bz2
tar -xf freetype-$MODVER.tar
cd freetype-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared  --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared  --prefix="$PREFIX" LIBPNG_CFLAGS="-I$PREFIX/include" LIBPNG_LDFLAGS="-lpng"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_32_libfreetype-make.log
make install 2>&1 | tee ${LOGPREFIX}_32_libfreetype-makeinstall.log


cd ..
rm -rf freetype-$MODVER
rm -f freetype-$MODVER.tar
