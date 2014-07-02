#!/bin/bash

MAJOR_VER=1
MINOR_VER=36
PATCH_VER=5
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 36_pango
cd 36_pango
test -f pango-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/pango/$MAJOR_VER.$MINOR_VER/pango-$MODVER.tar.xz
xz -d -k -f pango-$MODVER.tar.xz
tar -xf pango-$MODVER.tar
cd pango-$MODVER

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --with-included-modules=yes --with-dynamic-modules=yes --enable-static --disable-shared --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --with-included-modules=yes --with-dynamic-modules=yes --enable-static --enable-shared --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_36_pango-make.log
make install 2>&1 | tee ${LOGPREFIX}_36_pango-makeinstall.log

echo Copy the .def files where they belong

cp pango/pango.def "$PREFIX/lib/pango-1.0.def"
cp pango/pangocairo.def "$PREFIX/lib/pangocairo-1.0.def"
cp pango/pangowin32.def "$PREFIX/lib/pangowin32-1.0.def"


cd ..
rm -rf pango-MODVER
rm -f pango-MODVER.tar
