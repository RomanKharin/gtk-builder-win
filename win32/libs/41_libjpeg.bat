MODVER=9a

mkdir -p 41_libjpeg
cd 41_libjpeg
test -f jpegsrc.v$MODVER.tar.gz || wget http://www.ijg.org/files/jpegsrc.v$MODVER.tar.gz
gzip -d -f -c jpegsrc.v$MODVER.tar.gz > jpegsrc.v$MODVER.tar
tar -xf jpegsrc.v$MODVER.tar
cd jpeg-$MODVER


echo Compile...

./configure --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/41_libjpeg-make.log
make install 2>&1 | tee ../../logs/41_libjpeg-makeinstall.log


cd ..
rm -rf jpeg-$MODVER
rm -f jpegsrc.v$MODVER.tar
