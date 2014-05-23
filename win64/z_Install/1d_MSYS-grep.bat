@echo off

copy ..\MSYS\Base\gettext\gettext-0.18.1.1-1\*.lzma cache
copy ..\MSYS\Base\libiconv\libiconv-1.14-1\*.lzma cache
copy ..\MSYS\Base\grep\grep-2.5.4-2\*.lzma cache

cd cache
..\Tools\xz -d *.lzma
for %%i in (*.tar) do ..\Tools\tar -xf %%i -C C:\\msys\\1.0
del /q *.tar
cd ..