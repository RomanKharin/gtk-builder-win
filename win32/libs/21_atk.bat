MAJOR_VER=2
MINOR_VER=12
PATCH_VER=0
VERSION=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 21_atk
cd 21_atk
test -f atk-$VERSION.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/atk/$MAJOR_VER.$MINOR_VER/atk-$VERSION.tar.xz
xz -d -k -f atk-$VERSION.tar.xz
tar -xf atk-$VERSION.tar
cd atk-$VERSION


echo Compile...

./configure --enable-static --enable-shared --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/21_atk-make.log
make install 2>&1 | tee ../../logs/21_atk-makeinstall.log


cd ..
rm -rf atk-$VERSION
rm -f atk-$VERSION.tar
