MODVER=0.8.90

mkdir -p 71_icon-naming-utils
cd 71_icon-naming-utils
test -f icon-naming-utils-$MODVER.tar.bz2 || wget http://tango.freedesktop.org/releases/icon-naming-utils-$MODVER.tar.bz2
bzip2 -d -f -c icon-naming-utils-$MODVER.tar.bz2 > icon-naming-utils-$MODVER.tar
tar -xf icon-naming-utils-$MODVER.tar
cd icon-naming-utils-$MODVER


echo Compile...

./configure --prefix=$PREFIX
make 2>&1 | tee ../../logs/71_icon-naming-utils-make.log
make install 2>&1 | tee ../../logs/71_icon-naming-utils-makeinstall.log


cd ..
rm -rf icon-naming-utils-$MODVER
rm -f icon-naming-utils-$MODVER.tar
