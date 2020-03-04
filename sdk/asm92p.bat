@echo off

if not exist %1.asm goto asmnotfound

REM Building asm
a68k %1.asm -g -t -IC:\ti-92\include
if not exist %1.o goto error1
makeprgm %1
del %1.o
if errorlevel 1 goto error1
goto end

:asmnotfound
REM Building S
if not exist %1.s goto error0
precomp %1.s /o%1.tmp /iC:\ti-92\include
a68k %1.tmp -g -t -IC:\ti-92\include
del %1.tmp
if not exist %1.o goto error1
makeprgm %1
del %1.o
if errorlevel 1 goto error1
goto end

:error0
echo File not found: %1
goto end

:error1
echo There were some errors.

:end
