@echo off

..\Other\python-2.5.4.msi

copy /y c:\msys\1.0\etc\profile c:\msys\1.0\etc\profile.old
echo export PATH="$PATH:/c/Python25" >> c:\msys\1.0\etc\profile
copy c:\Python25\python.exe c:\Python25\python25