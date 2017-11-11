md src\assets
robocopy assets src\assets /e
md src\lib
robocopy lib src\lib /e
lovec src
rd src\assets /s /q
rd src\lib /s /q
