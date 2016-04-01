python.exe parsexml.py ..\android_mc\temp ..\android_mc
python.exe genindex.py
cd ..\android_mc\temp
for /d %%f in (*.*) do rd %%f /s /q
del . /q
cd ..
rd temp
pause