@echo off

copy ..\Other\XML-Simple-2.18.tar.gz cache

cd cache
..\Tools\gzip -d *.gz
for %%i in (*.tar) do ..\Tools\tar -xf %%i
mkdir c:\msys\1.0\lib\perl5\5.8\XML
xcopy /E /Y XML-Simple-2.18\lib\XML c:\msys\1.0\lib\perl5\5.8\XML
rmdir /s /q XML-Simple-2.18
del /q *.tar
cd ..