MODVER=3.0.12

mkdir -p 11_libffi
cd 11_libffi
test -f libffi-$MODVER.tar.gz || wget ftp://sourceware.org/pub/libffi/libffi-$MODVER.tar.gz
gzip -d -f -c libffi-$MODVER.tar.gz > libffi-$MODVER.tar
tar -xf libffi-$MODVER.tar
cd libffi-$MODVER


./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX

echo Correct libtool for the undefined symbols problem,
echo which prevents shared DLL creation

mv x86_64-w64-mingw32/libtool x86_64-w64-mingw32/libtool.old
cp ../libtool x86_64-w64-mingw32/libtool

echo Compile...

make clean
make 2>&1 | tee ../../logs/11_libffi-make.log
make install 2>&1 | tee ../../logs/11_libffi-makeinstall.log


cd ..
rm -rf libffi-$MODVER
rm -r libffi-$MODVER.tar
