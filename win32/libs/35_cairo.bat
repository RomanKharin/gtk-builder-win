MODVER=1.12.16

mkdir -p 35_cairo
cd 35_cairo
test -f cairo-$MODVER.tar.xz || wget http://cairographics.org/releases/cairo-$MODVER.tar.xz
xz -d -k -f cairo-$MODVER.tar.xz
tar -xf cairo-$MODVER.tar
cd cairo-$MODVER


echo Compile...

./configure --enable-win32=yes --enable-win32-font=yes --enable-png=yes --enable-ft=yes --enable-fc=yes --prefix=$PREFIX
# this avoid an error building see: http://lists.cairographics.org/archives/cairo/2012-October/023675.html
echo "#define _SSIZE_T_DEFINED 1" >> config.h
make clean
make 2>&1 | tee ../../logs/35_cairo-make.log
make install 2>&1 | tee ../../logs/35_cairo-makeinstall.log

echo Copy cairo.def to its final location...

cp src/cairo.def $PREFIX/lib


cd ..
rm -rf cairo-$MODVER
rm -f cairo-$MODVER.tar
