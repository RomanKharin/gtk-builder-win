MODVER=3.0.12

mkdir -p 11_libffi
cd 11_libffi
test -f libffi-$MODVER.tar.gz || wget ftp://sourceware.org/pub/libffi/libffi-$MODVER.tar.gz
gzip -d -f -c libffi-$MODVER.tar.gz > libffi-$MODVER.tar
tar -xf libffi-$MODVER.tar
cd libffi-$MODVER


echo Compile...

./configure --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/11_libffi-make.log
make install 2>&1 | tee ../../logs/11_libffi-makeinstall.log


cd ..
rm -rf libffi-$MODVER
rm -r libffi-$MODVER.tar
