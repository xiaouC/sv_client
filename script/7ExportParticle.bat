copy ..\..\trunk\���ӱ༭������\particleSystem\export\particle.bin ..\particles\normal.bin
copy ..\..\trunk\���ӱ༭������\particleSystem\export\textures\*.* ..\particles\textures\
copy ..\..\trunk\UI���ӱ༭������\particleSystem\export\particle.bin ..\particles\ui.bin
copy ..\..\trunk\UI���ӱ༭������\particleSystem\export\textures\*.* ..\particles\textures\
..\lol2.1.3.exe -p
del ..\particles\normal.bin
del ..\particles\ui.bin
pause