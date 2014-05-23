@echo off

mkdir cache
copy ..\MSYS\Extension\crypt\crypt-1.1_1-3\*.lzma cache
copy ..\MSYS\Extension\perl\perl-5.8.8-1\*.lzma cache
copy ..\MSYS\Extension\expat\expat-2.0.1-1\*.lzma cache

cd cache
..\Tools\xz -d *.lzma
for %%i in (*.tar) do ..\Tools\tar -xf %%i -C C:\\msys\\1.0
del /q *.tar
cd ..
