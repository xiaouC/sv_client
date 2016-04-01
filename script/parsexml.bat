python.exe parsexml.py ..\mc\temp ..\mc
python.exe genindex.py
cd ..\mc\temp
for /d %%f in (*.*) do rd %%f /s /q
del . /q
cd ..
rd temp
pause