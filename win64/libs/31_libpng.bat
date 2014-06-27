MODVER=1.6.12

mkdir -p 31_libpng
cd 31_libpng
test -f libpng-$MODVER.tar.xz || wget http://sourceforge.net/projects/libpng/files/libpng16/$MODVER/libpng-$MODVER.tar.xz
xz -d -k -f libpng-$MODVER.tar.xz
tar -xf libpng-$MODVER.tar
cd libpng-$MODVER


echo Compile...

./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/31_libpng-make.log
make install 2>&1 | tee ../../logs/31_libpng-makeinstall.log


cd ..
rm -rf libpng-$MODVER
rm -f libpng-$MODVER.tar
