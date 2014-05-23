MAJOR_VER=3
MINOR_VER=12
PATCH_VER=0
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 73_gnome-icon-theme
cd 73_gnome-icon-theme
test -f gnome-icon-theme-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/gnome-icon-theme/$MAJOR_VER.$MINOR_VER/gnome-icon-theme-$MODVER.tar.xz
xz -d -k -f gnome-icon-theme-$MODVER.tar.xz
tar -xf gnome-icon-theme-$MODVER.tar
cd gnome-icon-theme-$MODVER

echo Compile...

./configure --prefix=$PREFIX
make 2>&1 | tee ../../logs/73_gnome-icon-theme-make.log
make install 2>&1 | tee ../../logs/73_gnome-icon-theme-makeinstall.log


cd ..
rm -rf gnome-icon-theme-$MODVER
rm -f gnome-icon-theme-$MODVER.tar
