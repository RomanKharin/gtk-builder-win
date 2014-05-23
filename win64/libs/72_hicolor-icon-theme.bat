MODVER=0.12

mkdir -p 72_hicolor-icon-theme
cd 72_hicolor-icon-theme
test -f hicolor-icon-theme-$MODVER.tar.gz || wget http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-$MODVER.tar.gz
gzip -d -f -c hicolor-icon-theme-$MODVER.tar.gz > hicolor-icon-theme-$MODVER.tar
tar -xf hicolor-icon-theme-$MODVER.tar
cd hicolor-icon-theme-$MODVER


echo Compile...

./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX
make 2>&1 | tee ../../logs/72_hicolor-icon-theme-make.log
make install 2>&1 | tee ../../logs/72_hicolor-icon-theme-makeinstall.log


cd ..
rm -rf hicolor-icon-theme-$MODVER
rm -f hicolor-icon-theme-$MODVER.tar
