@echo off

copy "..\MinGW64\Toolchains targetting Win64\Personal Builds\rubenvb\gcc-4.6-release\*.7z" cache
copy "..\MinGW64\External binary packages (Win64 hosted)\gettext\*.zip" cache
copy "..\MinGW64\External binary packages (Win64 hosted)\libiconv\*.zip" cache


cd cache

..\Tools\7z x -o"C:\msys\1.0" *.7z
rmdir /q /s C:\msys\1.0\mingw
ren C:\msys\1.0\mingw64 mingw
move /y C:\msys\1.0\mingw\x86_64-w64-mingw32\bin\*.* C:\msys\1.0\mingw\bin
move /y C:\msys\1.0\mingw\x86_64-w64-mingw32\lib\*.dll C:\msys\1.0\mingw\bin
copy C:\msys\1.0\mingw\bin\x86_64-w64-mingw32-strings.exe C:\msys\1.0\mingw\bin\strings.exe
copy C:\msys\1.0\mingw\bin\x86_64-w64-mingw32-windres.exe C:\msys\1.0\mingw\bin\windres.exe
rmdir C:\msys\1.0\mingw\x86_64-w64-mingw32\bin

..\Tools\unzip -o *.zip
xcopy /e /r /h /c /y mingw64\bin\*.* C:\msys\1.0\mingw\bin
xcopy /e /r /h /c /y mingw64\share\*.* C:\msys\1.0\mingw\share
xcopy /e /r /h /c /y mingw64\include\*.* C:\msys\1.0\mingw\x86_64-w64-mingw32\include
xcopy /e /r /h /c /y mingw64\lib\*.* C:\msys\1.0\mingw\x86_64-w64-mingw32\lib
del /q C:\msys\1.0\mingw\x86_64-w64-mingw32\lib\libiconv.la

rmdir /q /s mingw64
del /q *.7z
del /q *.zip
cd ..