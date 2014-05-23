MODVER=0.28

mkdir -p 13_pkg-config
cd 13_pkg-config
test -f pkg-config-$MODVER.tar.gz || wget http://pkgconfig.freedesktop.org/releases/pkg-config-$MODVER.tar.gz
gzip -d -f -c pkg-config-$MODVER.tar.gz > pkg-config-$MODVER.tar
tar -xf pkg-config-$MODVER.tar
cd pkg-config-$MODVER


echo To detect the formerly installed GLib...

export GLIB_CFLAGS="-I$PREFIX/include/glib-2.0 -I$PREFIX/lib/glib-2.0/include"
export GLIB_LIBS=-lglib-2.0

echo Compile...

./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/13_pkg-config-make.log
make install 2>&1 | tee ../../logs/13_pkg-config-makeinstall.log


unset GLIB_CFLAGS
unset GLIB_LIBS
cd ..
rm -rf pkg-config-$MODVER
rm -f pkg-config-$MODVER.tar
