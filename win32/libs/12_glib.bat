MAJOR_VER=2
MINOR_VER=40
PATCH_VER=0
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 12_glib
cd 12_glib
test -f glib-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/glib/$MAJOR_VER.$MINOR_VER/glib-$MODVER.tar.xz
xz -d -k -f glib-$MODVER.tar.xz
tar -xf glib-$MODVER.tar
cd glib-$MODVER


echo revert rand_s change that is not supported in mingw
patch -p1 -R < ../revert_rand_s.patch

echo To avoid using pkg-config...

export LIBFFI_CFLAGS=-I"$PREFIX/lib/libffi-3.0.12/include"
export LIBFFI_LIBS=-lffi

echo save current CFLAGS var, we will regenerate it later...
export CFLAGS_SAVE="$CFLAGS"

echo for configure check problems...

export CFLAGS="$CFLAGS -march=i486"

echo for compilation problems...

export CFLAGS="$CFLAGS -mms-bitfields -mthreads"

echo Compile...

./configure --enable-shared --with-pcre=internal --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/12_glib-make.log
make install 2>&1 | tee ../../logs/12_glib-makeinstall.log


export CFLAGS="$CFLAGS_SAVE"
unset CFLAGS_SAVE
unset LIBFFI_CFLAGS
unset LIBFFI_LIBS
cd ..
rm -rf glib-$MODVER
rm -f glib-$MODVER.tar
