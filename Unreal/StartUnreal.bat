
@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Android-Toolchain laden
call "%~dp0AndroidPaths.bat"

REM Unreal Engine
set "UE_ROOT=C:\Program Files\Epic Games\UE_5.8"
set "UE_EDITOR=%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor.exe"

if not exist "%UE_EDITOR%" (
    echo FEHLER: UnrealEditor.exe wurde nicht gefunden:
    echo "%UE_EDITOR%"
    pause
    exit /b 1
)

REM .uproject-Dateien im aktuellen Projektordner suchen
set "COUNT=0"

for %%F in ("%~dp0*.uproject") do (
    if exist "%%~fF" (
        set /a COUNT+=1
        set "PROJECT_!COUNT!=%%~fF"
        echo !COUNT!^) %%~nxF
    )
)

if "!COUNT!"=="0" (
    echo FEHLER: Keine .uproject-Datei gefunden in:
    echo "%~dp0"
    pause
    exit /b 1
)

REM Bei genau einem Projekt direkt starten
if "!COUNT!"=="1" (
    set "UPROJECT=!PROJECT_1!"
    goto :Launch
)

REM Bei mehreren Projekten Auswahl anzeigen
echo.
set /p "CHOICE=Bitte Projektnummer eingeben: "

if not defined CHOICE goto :InvalidChoice
for /f "delims=0123456789" %%A in ("!CHOICE!") do goto :InvalidChoice

if !CHOICE! LSS 1 goto :InvalidChoice
if !CHOICE! GTR !COUNT! goto :InvalidChoice

set "UPROJECT=!PROJECT_%CHOICE%!"

:Launch
echo.
echo Starte Projekt:
echo "!UPROJECT!"
echo.

start "" "%UE_EDITOR%" "%UPROJECT%"
exit /b 0

:InvalidChoice
echo Ungueltige Auswahl.
pause
exit /b 1
