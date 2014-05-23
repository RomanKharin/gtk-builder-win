MODVER=2.24.23

mkdir -p 52_gtk2
cd 52_gtk2
test -f gtk+-$MODVER.tar.xz || wget http://ftp.acc.umu.se/pub/gnome/sources/gtk+/2.24/gtk+-$MODVER.tar.xz
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

echo work around bug 712404
rm gtk/gtk.def

echo patch makefile for make install failure
rm modules/input/Makefile
cp ../modules-input-makefile modules/input/Makefile

echo Compile...

./configure --host=x86_64-w64-mingw32 --with-gdktarget=win32 --with-included-immodules --disable-cups --disable-papi --prefix=$PREFIX
make clean
make 2>&1 | tee ../../logs/52_gtk2-make.log
make install 2>&1 | tee ../../logs/52_gtk2-makeinstall.log


export CFLAGS="$CFLAGS_SAVE"
unset CFLAGS_SAVE
cd ..
rm -rf gtk+-$MODVER
rm -f gtk+-$MODVER.tar
