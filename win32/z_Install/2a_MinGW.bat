@echo off

copy ..\MinGW\Base\binutils\binutils-2.22\*.lzma cache
copy ..\MinGW\Base\gcc\Version4\gcc-4.6.2-1\*.lzma cache
copy ..\MinGW\Base\gettext\gettext-0.18.1.1-2\*.lzma cache
copy ..\MinGW\Base\gmp\gmp-5.0.1-1\*.lzma cache
copy ..\MinGW\Base\libiconv\libiconv-1.14-2\*.lzma cache
copy ..\MinGW\Base\mingw-rt\mingwrt-3.20-2\*.lzma cache
copy ..\MinGW\Base\mpc\mpc-0.8.1-1\*.lzma cache
copy ..\MinGW\Base\mpfr\mpfr-2.4.1-1\*.lzma cache
copy ..\MinGW\Base\pthreads-w32\pthreads-w32-2.9.0-pre-20110507-2\*.lzma cache
copy ..\MinGW\Base\w32api\w32api-3.15\*.lzma cache

copy ..\MinGW\Extension\expat\expat-2.0.1-1\*.gz cache

cd cache
..\Tools\xz -d *.lzma
..\Tools\gzip -d *.gz
for %%i in (*.tar) do ..\Tools\tar -xf %%i -C C:\\msys\\1.0\\mingw
del /q *.tar
cd ..