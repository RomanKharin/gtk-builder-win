#!/bin/bash

MODVER=1.2.8
VERSQUASHED=`echo $MODVER | sed -e 's/\.//g'`

mkdir -p 11_zlib
cd 11_zlib
test -f zlib$VERSQUASHED.zip || wget http://sourceforge.net/projects/libpng/files/zlib/$MODVER/zlib$VERSQUASHED.zip
unzip -o zlib$VERSQUASHED.zip
cd zlib-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --static --prefix="$PREFIX"
    make clean
    make 2>&1 | tee ${LOGPREFIX}_11_zlib-make.log
    make install 2>&1 | tee ${LOGPREFIX}_11_zlib-makeinstall.log
    cd ..
else
    echo Patching the Makefile with the correct options

    patch -p1 < ../zlib$VERSQUASHED-Makefile.patch

    make -fwin32/Makefile.gcc 2>&1 | tee  ${LOGPREFIX}_11_zlib-make.log

    echo Install final files -including custom .pc- to their destination

    cp zlib1.dll "$PREFIX/bin"
    cp zconf.h "$PREFIX/include"
    cp zlib.h "$PREFIX/include"
    cp libz.a "$PREFIX/lib"
    cp libz.dll.a "$PREFIX/lib"
    cd ..
    cp zlib.pc "$PREFIX/lib/pkgconfig"
fi

rm -rf zlib-$MODVER

