MODVER=2.10.2

mkdir -p 33_libfontconfig
cd 33_libfontconfig
test -f fontconfig-$MODVER.tar.gz || wget http://www.freedesktop.org/software/fontconfig/release/fontconfig-$MODVER.tar.gz
gzip -d -f -c fontconfig-$MODVER.tar.gz > fontconfig-$MODVER.tar
tar -xf fontconfig-$MODVER.tar
cd fontconfig-$MODVER


echo To fix ftheader.h location detection by make...

ln -s $PREFIX/include/freetype2/freetype $PREFIX/include/freetype

echo Compile...

./configure --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/33_libfontconfig-make.log
make install 2>&1 | tee ../../logs/33_libfontconfig-makeinstall.log

echo Doc installation partially fails at the end
echo so we install the .pc file manually

cp fontconfig.pc $PREFIX/lib/pkgconfig


cd ..
rm -rf fontconfig-$MODVER
rm -f fontconfig-$MODVER.tar
