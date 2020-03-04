@echo off
echo Starting assembly 
if not exist %1.asm goto error0
%PS_BIN%\a68k %1.asm -g -t -f -i%PS_INCLUDE% -d!\
if not exist %1.o goto error1
%PS_BIN%\makeprgm %1
if errorlevel 1 goto error1
echo Done!
del %1.o
goto end

:error0
echo File not found: %1.asm
goto end

:error1
echo There were errors.

:end
