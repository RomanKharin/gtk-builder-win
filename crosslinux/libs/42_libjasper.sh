#!/bin/bash

MODVER=1.900.1

mkdir -p 42_libjasper
cd 42_libjasper
test -f jasper-$MODVER.zip || wget http://www.ece.uvic.ca/~frodo/jasper/software/jasper-$MODVER.zip
unzip -o jasper-$MODVER.zip
cd jasper-$MODVER


echo Compile...

echo Save current compiler flags for later restoration

CFLAGS_SAVE="$CFLAGS"

if [ "$BUILD_MODE" == "native" ]; then
    echo  Add compiler define TRUE and FALSE for building

    export CFLAGS="$CFLAGS -DHAVE_BOOLEAN -Dboolean=bool -DTRUE=1 -DFALSE=0"

    ./configure --enable-static --disable-shared  --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --enable-static --enable-shared  --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_42_libjasper-make.log
make install 2>&1 | tee ${LOGPREFIX}_42_libjasper-makeinstall.log

echo Restore original compiler flags

export CFLAGS="CFLAGS_SAVE"
unset CFLAGS_SAVE

cd ..
rm -rf jasper-$MODVER
