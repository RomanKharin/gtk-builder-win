#!/bin/bash

MAJOR_VER=2
MINOR_VER=40
PATCH_VER=0
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 22_glib
cd 22_glib
test -f glib-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/glib/$MAJOR_VER.$MINOR_VER/glib-$MODVER.tar.xz
xz -d -k -f glib-$MODVER.tar.xz
tar -xf glib-$MODVER.tar
cd glib-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --enable-static --disable-shared --with-libiconv=gnu --prefix="$PREFIX"
    make clean
    make 2>&1 | tee ${LOGPREFIX}_22_glib-make.log
    echo Patch glib.pc for gdk successfull building
    patch -p0 < ../glib-pc.patch
    make install 2>&1 | tee ${LOGPREFIX}_22_glib-makeinstall.log

    echo Installing additional headers required by GTK+ later...

    cp gio/gunixfdlist.h "$PREFIX/include/glib-2.0/gio"
    cp gio/gdesktopappinfo.h "$PREFIX/include/glib-2.0/gio"
    cp gio/gunixsocketaddress.h "$PREFIX/include/glib-2.0/gio"
else
    echo revert rand_s change that is not supported in mingw
    patch -p1 -R < ../revert_rand_s.patch

    echo To avoid using pkg-config...

    export LIBFFI_CFLAGS=-I"$PREFIX/lib/libffi-3.1/include"
    export LIBFFI_LIBS=-lffi

    echo save current CFLAGS var, we will regenerate it later...
    export CFLAGS_SAVE="$CFLAGS"

    echo for configure check problems...

    export CFLAGS="$CFLAGS -march=i486"

    echo for compilation problems...

    export CFLAGS="$CFLAGS -mms-bitfields -mthreads"

    echo Compile...

    ./configure --host=$CROSS_HOST --enable-shared --with-pcre=internal --prefix=$PREFIX
    make clean
    make 2>&1 | tee ${LOGPREFIX}_22_glib-make.log
    make install 2>&1 | tee ${LOGPREFIX}_22_glib-makeinstall.log


    export CFLAGS="$CFLAGS_SAVE"
    unset CFLAGS_SAVE
    unset LIBFFI_CFLAGS
    unset LIBFFI_LIBS
fi





cd ..
rm -rf glib-$MODVER
rm -f glib-$MODVER.tar
