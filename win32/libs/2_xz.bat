MODVER=5.0.5

mkdir -p 2_xz
cd 2_xz
test -f xz-$MODVER.tar.bz2 || wget http://tukaani.org/xz/xz-$MODVER.tar.bz2
bzip2 -d -k -f xz-$MODVER.tar.bz2
tar -xf xz-$MODVER.tar
cd xz-$MODVER


echo Compile...

./configure --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/2_xz-make.log
make install 2>&1 | tee ../../logs/2_xz-makeinstall.log


cd ..
rm -rf xz-$MODVER
rm -f xz-$MODVER.tar
