md builds
md builds\win32
md builds\win64
xcopy love\win32\*.dll builds\win32
xcopy love\win64\*.dll builds\win64
del builds\win32\atman.exe builds\win64\atman.exe builds\universal\atman.love
md src\assets
robocopy assets src\assets /e /NFL /NDL /NJH /NJS /nc /ns /np
md src\lib
robocopy lib src\lib /e /NFL /NDL /NJH /NJS /nc /ns /np
7z a -tzip ".\builds\universal\atman.love" ".\src\*"
copy /b love\win32\love.exe+builds\universal\atman.love builds\win32\atman.exe
copy /b love\win64\love.exe+builds\universal\atman.love builds\win64\atman.exe
rd src\assets /s /q
rd src\lib /s /q
