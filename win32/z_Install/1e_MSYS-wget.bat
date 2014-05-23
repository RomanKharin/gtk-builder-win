@echo off

copy ..\MSYS\Extension\openssl\libopenssl-1.0.0-1\*.lzma cache
copy ..\MSYS\Extension\wget\wget-1.12-1\*.lzma cache

cd cache
..\Tools\xz -d *.lzma
for %%i in (*.tar) do ..\Tools\tar -xf %%i -C C:\\msys\\1.0
del /q *.tar
cd ..