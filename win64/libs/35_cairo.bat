MODVER=1.12.16

mkdir -p 35_cairo
cd 35_cairo
test -f cairo-$MODVER.tar.xz || wget http://cairographics.org/releases/cairo-$MODVER.tar.xz
xz -d -k -f cairo-$MODVER.tar.xz
tar -xf cairo-$MODVER.tar
cd cairo-$MODVER

./configure --host=x86_64-w64-mingw32 --enable-win32=yes --enable-win32-font=yes --enable-png=yes --enable-ft=yes --enable-fc=yes --prefix=$PREFIX

echo Correct libtool for the undefined symbols problem,
echo which prevents shared DLL creation

mv libtool libtool.old
cp ../libtool libtool

echo Compile...

make clean
make 2>&1 | tee ../../logs/35_cairo-make.log
make install 2>&1 | tee ../../logs/35_cairo-makeinstall.log

echo Copy cairo.def to its final location...

cp src/cairo.def $PREFIX/lib


cd ..
rm -rf cairo-$MODVER
rm -f cairo-$MODVER.tar
