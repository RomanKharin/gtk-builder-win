#!/bin/bash

MAJOR_VER=3
MINOR_VER=12
PATCH_VER=2
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 52_gtk3
cd 52_gtk3
test -f gtk+-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/gtk+/$MAJOR_VER.$MINOR_VER/gtk+-$MODVER.tar.xz
xz -d -k -f gtk+-$MODVER.tar.xz
tar -xf gtk+-$MODVER.tar
cd gtk+-$MODVER

echo Save current CFLAGS var, we will restore it later...

export CFLAGS_SAVE="$CFLAGS"

echo Default Windows version on MinGW is NT4...
echo Here we need to redefine it to XP, as new GTK code
echo uses Monitor stuff depending on XP ifndefs 

export CFLAGS="$CFLAGS -DWINVER=0x0501"

cd ..

cd gtk+-$MODVER

echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    echo Patch configure pango searching error
    
    patch -p1 < ../gtk+-3.12.2-configure_pango.patch

    ./configure --enable-broadway-backend --disable-modules --disable-glibtest --enable-static --disable-shared --prefix="$PREFIX"
else
    echo Putting some needed utilies in the right place, do no do make clean

    cp ../../../z_Install/cache/gtk-update-icon-cache ./gtk/
    cp ../../../z_Install/cache/gtk-update-icon-cache ./gtk/native/native-update-icon-cache
    cp ../../../z_Install/cache/gtk-query-immodules-3.0 ./gtk/
    cp ../../../z_Install/cache/gtk-extract-strings ./gtk/extract-strings

    ./configure --host=$CROSS_HOST --enable-win32-backend --with-included-immodules --prefix=$PREFIX

    echo Remove using gtk.def

    patch -p0 < ../gtk+-3.12.2-gxkdef-win32.patch
    
    echo Skip native Makefile coz it useless now \(native-update-icon-cache\)
    
    mv gtk/native/Makefile gtk/native/save_Makefile
    printf "all:\n\ninstall:\n" > gtk/native/Makefile
fi

cp -f config.log ${LOGPREFIX}_52_gtk3-config.log
make clean
make 2>&1 | tee ${LOGPREFIX}_52_gtk3-make.log
make install 2>&1 | tee ${LOGPREFIX}_52_gtk3-makeinstall.log

# save tools for later use
cp gtk/extract-strings $PREFIX/bin/gtk-extract-strings

export CFLAGS="$CFLAGS_SAVE"
unset CFLAGS_SAVE

cd ..
rm -rf gtk+-$MODVER
rm -f gtk+-$MODVER.tar
