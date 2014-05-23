@echo off

copy ..\Other\pexports-0.46-mingw32-bin.tar.xz cache

cd cache
..\Tools\xz -d *.xz
for %%i in (*.tar) do ..\Tools\tar -xf %%i -C C:\\msys\\1.0\mingw
del /q *.tar
cd ..
