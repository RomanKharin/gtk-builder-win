MAJOR_VER=3
MINOR_VER=12
PATCH_VER=0
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 73_gnome-icon-theme-symbolic
cd 74_gnome-icon-theme-symbolic
test -f gnome-icon-theme-symbolic-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/gnome-icon-theme-symbolic/$MAJOR_VER.$MINOR_VER/gnome-icon-theme-symbolic-$MODVER.tar.xz
xz -d -k -f gnome-icon-theme-symbolic-$MODVER.tar.xz
tar -xf gnome-icon-theme-symbolic-$MODVER.tar
cd gnome-icon-theme-symbolic-$MODVER

echo Compile...

./configure --host=x86_64-w64-mingw32 --prefix=$PREFIX
make 2>&1 | tee ../../logs/74_gnome-icon-theme-symbolic-make.log
make install 2>&1 | tee ../../logs/74_gnome-icon-theme-symbolic-makeinstall.log


cd ..
rm -rf gnome-icon-theme-symbolic-$MODVER
rm -f gnome-icon-theme-symbolic-$MODVER.tar
