md src\assets
robocopy assets src\assets /e /NFL /NDL /NJH /NJS /nc /ns /np
md src\lib
robocopy lib src\lib /e /NFL /NDL /NJH /NJS /nc /ns /np
lovec src
rd src\assets /s /q
rd src\lib /s /q
