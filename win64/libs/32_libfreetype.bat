MODVER=2.4.11

mkdir -p 32_libfreetype
cd 32_libfreetype
test -f freetype-$MODVER.tar.bz2 || wget http://download.savannah.gnu.org/releases/freetype/freetype-$MODVER.tar.bz2
bzip2 -d -k -f freetype-$MODVER.tar.bz2
tar -xf freetype-$MODVER.tar
cd freetype-$MODVER


echo Compile...

./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/32_libfreetype-make.log
make install 2>&1 | tee ../../logs/32_libfreetype-makeinstall.log


cd ..
rm -rf freetype-$MODVER
rm -f freetype-$MODVER.tar
