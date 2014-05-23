@echo off

copy ..\Other\intltool_0.40.4-1_win32.zip cache

cd cache
..\Tools\unzip *.zip -d c:\msys\1.0\mingw
del /q *.zip
cd ..