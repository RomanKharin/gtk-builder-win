#!/bin/bash

MODVER=0.12

mkdir -p 72_hicolor-icon-theme
cd 72_hicolor-icon-theme
test -f hicolor-icon-theme-$MODVER.tar.gz || wget http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-$MODVER.tar.gz
gzip -d -f -c hicolor-icon-theme-$MODVER.tar.gz > hicolor-icon-theme-$MODVER.tar
tar -xf hicolor-icon-theme-$MODVER.tar
cd hicolor-icon-theme-$MODVER


echo Compile...

if [ "$BUILD_MODE" == "native" ]; then
    ./configure --prefix="$PREFIX"
else
    ./configure --host=$CROSS_HOST --prefix="$PREFIX"
fi

make 2>&1 | tee ${LOGPREFIX}_72_hicolor-icon-theme-make.log
echo "#Ok" >> ${LOGPREFIX}_72_hicolor-icon-theme-make.log
make install 2>&1 | tee ${LOGPREFIX}_72_hicolor-icon-theme-makeinstall.log


cd ..
rm -rf hicolor-icon-theme-$MODVER
rm -f hicolor-icon-theme-$MODVER.tar
