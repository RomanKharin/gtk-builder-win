MAJOR_VER=2
MINOR_VER=30
PATCH_VER=7
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 44_gdk-pixbuf
cd 44_gdk-pixbuf
test -f gdk-pixbuf-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/gdk-pixbuf/$MAJOR_VER.$MINOR_VER/gdk-pixbuf-$MODVER.tar.xz
xz -d -k -f gdk-pixbuf-$MODVER.tar.xz
tar -xf gdk-pixbuf-$MODVER.tar
cd gdk-pixbuf-$MODVER

echo Compile...

./configure --host=x86_64-w64-mingw32 --with-included-loaders --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/44_gdk-pixbuf-make.log
make install 2>&1 | tee ../../logs/44_gdk-pixbuf-makeinstall.log


cd ..
rm -rf gdk-pixbuf-$MODVER
rm -f gdk-pixbuf-$MODVER.tar
