#!/bin/bash

MODVER=0.9.16

mkdir -p 35x_harfbuzz
cd 35x_harfbuzz
test -f harfbuzz-$MODVER.tar.bz2 || wget http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-$MODVER.tar.bz2
bzip2 -d -k -f harfbuzz-$MODVER.tar.bz2
tar -xf harfbuzz-$MODVER.tar
cd harfbuzz-$MODVER


#echo Applying patch to use installed version of autotools...

#cd ..
#patch -p0 < configureac.patch
#cd harfbuzz-0.9.16

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --prefix="$PREFIX"
else
    echo "Only native building supported"
    exit 2
fi

make 2>&1 | tee ${LOGPREFIX}_35x_harfbuzz-make.log
make install 2>&1 | tee ${LOGPREFIX}_35x_harfbuzz-makeinstall.log


cd ..
rm -rf harfbuzz-$MODVER
rm -rf harfbuzz-$MODVER.tar
