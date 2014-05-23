MAJOR_VER=3
MINOR_VER=12
PATCH_VER=2
MODVER=$MAJOR_VER.$MINOR_VER.$PATCH_VER

mkdir -p 51_gtk3
cd 51_gtk3
test -f gtk+-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/gtk+/$MAJOR_VER.$MINOR_VER/gtk+-$MODVER.tar.xz
xz -d -k -f gtk+-$MODVER.tar.xz
tar -xf gtk+-$MODVER.tar
cd gtk+-$MODVER

echo Save current CFLAGS var, we will restore it later...

export CFLAGS_SAVE="$CFLAGS"

echo Default Windows version on MinGW is NT4...
echo Here we need to redefine it to XP, as new GTK code
echo uses Monitor stuff depending on XP ifndefs 

export CFLAGS="$CFLAGS -DWINVER=0x0501"

cd ..

cd gtk+-$MODVER

echo Compile...

./configure --enable-win32-backend --with-included-immodules --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/51_gtk3-make.log
make install 2>&1 | tee ../../logs/51_gtk3-makeinstall.log


export CFLAGS="$CFLAGS_SAVE"
unset CFLAGS_SAVE
cd ..
rm -rf gtk+-$MODVER
rm -f gtk+-$MODVER.tar
