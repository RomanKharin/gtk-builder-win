MAJOR_VER=2
MINOR_VER=40
PATCH_VER=2
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 62_librsvg
cd 62_librsvg
test -f librsvg-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/librsvg/$MAJOR_VER.$MINOR_VER/librsvg-$MODVER.tar.xz
xz -d -k -f librsvg-$MODVER.tar.xz
tar -xf librsvg-$MODVER.tar
cd librsvg-$MODVER

cp ../realpath.c .
patch -p0 < ../rsvg-base.diff

echo Compile...

./configure --host=x86_64-w64-mingw32 --disable-gtk-theme --enable-pixbuf-loader --enable-introspection=no --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/62_librsvg-make.log
make install 2>&1 | tee ../../logs/62_librsvg-makeinstall.log


cd ..
rm -rf librsvg-$MODVER
rm -f librsvg-$MODVER.tar
