cd ../fla
for %%i in (*.fla) do winrar x -y %%i %%~ni\
cd ../script
python parsefla.py
python genindex.py
cd ../fla
for /d %%f in (*.*) do rd %%f /s /q
pause