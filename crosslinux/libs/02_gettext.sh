#!/bin/bash

MODVER=0.18.2.1

mkdir -p 02_gettext
cd 02_gettext
test -f gettext-$MODVER.tar.gz || wget http://ftp.gnu.org/gnu/gettext/gettext-$MODVER.tar.gz
gzip -d -f -c gettext-$MODVER.tar.gz > gettext-$MODVER.tar
tar -xf gettext-$MODVER.tar
cd gettext-$MODVER

echo Save current compiler flags for later restoration

CFLAGS_SAVE="$CFLAGS"
CPPFLAGS_SAVE="$CPPFLAGS"
LDFLAGS_SAVE="$LDFLAGS"

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --prefix="$PREFIX"
else
    echo Patching source for multiple definition of towlover and other problems
    patch -p1 < ../gettext-towlower.patch


    echo Add compiler flag needed to export needed po_lex_iconv symbol

    export CFLAGS="$CFLAGS -DHAVE_ICONV -Dcdecl=__cdecl"
    export CPPFLAGS="$CPPFLAGS -DHAVE_ICONV"

    echo Add compiler flag needed to avoid some undefined references while linking

    export CFLAGS="$CFLAGS -O2"
    export CPPFLAGS="$CPPFLAGS -O2"

    echo Add linker flag needed to avoid some undefined references while linking

    export LDFLAGS="$LDFLAGS -liconv"

   ./configure --host=$CROSS_HOST --without-libxml2-prefix --enable-static --enable-shared --prefix="$PREFIX"
fi

make clean
make 2>&1 | tee ${LOGPREFIX}_02_gettext-make.log
make install 2>&1 | tee ${LOGPREFIX}_02_gettext-makeinstall.log

echo Restore original compiler flags

export CFLAGS="$CFLAGS_SAVE"
export CPPFLAGS="$CPPFLAGS_SAVE"
export LDFLAGS="$LDFLAGS_SAVE"
unset CFLAGS_SAVE
unset CPPFLAGS_SAVE
unset LDFLAGS_SAVE

cd ..
rm -rf gettext-$MODVER
rm -f gettext-$MODVER.tar
