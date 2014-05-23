MAJOR_VER=0
MINOR_VER=6
PATCH_VER=8
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 51_gtk3
cd 51_gtk3
test -f libcroco-$MODVER.tar.xz || wget http://ftp.gnome.org/pub/GNOME/sources/libcroco/$MAJOR_VER.$MINOR_VER/libcroco-$MODVER.tar.xz
xz -d -k -f libcroco-$MODVER.tar.xz
tar -xf libcroco-$MODVER.tar
cd libcroco-$MODVER


echo Compile...

./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/61_libcroco-make.log
make install 2>&1 | tee ../../logs/61_libcroco-makeinstall.log


cd ..
rm -rf libcroco-$MODVER
rm -f libcroco-$MODVER.tar
