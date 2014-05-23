MAJOR_VER=1
MINOR_VER=36
PATCH_VER=3
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 36_pango
cd 36_pango
test -f pango-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/pango/$MAJOR_VER.$MINOR_VER/pango-$MODVER.tar.xz
xz -d -k -f pango-$MODVER.tar.xz
tar -xf pango-$MODVER.tar
cd pango-$MODVER

echo Save current LDFLAGS var, we will regenerate it later...
export LDFLAGS_SAVE="$LDFLAGS"

echo Avoid undefined reference to g_object_unref errors...
export LDFLAGS="$LDFLAGS -lgobject-2.0 -lgmodule-2.0"

echo Compile...

./configure --host=x86_64-w64-mingw32 --with-included-modules=yes --with-dynamic-modules=yes --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/36_pango-make.log
make install 2>&1 | tee ../../logs/36_pango-makeinstall.log


export LDFLAGS="$LDFLAGS_SAVE"
unset LDFLAGS_SAVE

cd ..
rm -rf pango-MODVER
rm -f pango-MODVER.tar
