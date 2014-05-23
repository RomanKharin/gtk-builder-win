MODVER=2.8.0

mkdir -p 3_libxml2
cd 3_libxml2
test -f libxml2-$MODVER.tar.gz || wget http://xmlsoft.org/sources/libxml2-$MODVER.tar.gz
gzip -d -f -c libxml2-$MODVER.tar.gz > libxml2-$MODVER.tar
tar -xf libxml2-$MODVER.tar
cd libxml2-$MODVER


echo Compile...

./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/3_libxml2-make.log
make install 2>&1 | tee ../../logs/3_libxml2-makeinstall.log


cd ..
rm -rf libxml2-$MODVER
rm -f libxml2-$MODVER.tar
