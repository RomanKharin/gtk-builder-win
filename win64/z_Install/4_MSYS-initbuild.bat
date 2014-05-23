
rem Customize THAT !!!
set PREFIX=opt

echo export PREFIX="/%PREFIX%" >> c:\msys\1.0\etc\profile

mkdir c:\msys\1.0\%PREFIX%
mkdir c:\msys\1.0\%PREFIX%\bin
mkdir c:\msys\1.0\%PREFIX%\etc
mkdir c:\msys\1.0\%PREFIX%\include
mkdir c:\msys\1.0\%PREFIX%\lib
mkdir c:\msys\1.0\%PREFIX%\lib\pkgconfig
mkdir c:\msys\1.0\%PREFIX%\share


echo export PATH="$PATH:/%PREFIX%/bin" >> c:\msys\1.0\etc\profile
echo export CFLAGS="-I/%PREFIX%/include" >> c:\msys\1.0\etc\profile
echo export CPPFLAGS="-I/%PREFIX%/include" >> c:\msys\1.0\etc\profile
echo export LDFLAGS="-L/%PREFIX%/lib" >> c:\msys\1.0\etc\profile
echo export PKG_CONFIG_PATH="/%PREFIX%/lib/pkgconfig" >> c:\msys\1.0\etc\profile
echo export XDG_DATA_DIRS="/%PREFIX%/share" >> c:\msys\1.0\etc\profile


copy Tools\UNZIP.EXE c:\msys\1.0\bin