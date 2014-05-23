MODVER=0.26.0

mkdir -p 34_pixman
cd 34_pixman
test -f pixman-$MODVER.tar.gz || wget http://cairographics.org/releases/pixman-$MODVER.tar.gz
gzip -d -f -c pixman-$MODVER.tar.gz > pixman-$MODVER.tar
tar -xf pixman-$MODVER.tar
cd pixman-$MODVER


echo Compile...

./configure --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/34_pixman-make.log
make install 2>&1 | tee ../../logs/34_pixman-makeinstall.log


cd ..
rm -rf pixman-$MODVER
rm -f pixman-$MODVER.tar
