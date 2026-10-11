
@echo off
setlocal EnableExtensions EnableDelayedExpansion

for %%I in ("%~dp0.") do set "PROJECT_ROOT=%%~fI"
call "%PROJECT_ROOT%\AndroidPaths.bat"

REM Unreal Engine - aktuell fest installierter Pfad
set "UE_ROOT=C:\Program Files\Epic Games\UE_5.8"
set "UE_EDITOR=%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor.exe"

if not exist "%UE_EDITOR%" (
    echo FEHLER: UnrealEditor.exe nicht gefunden:
    echo "%UE_EDITOR%"
    pause
    exit /b 1
)

set "COUNT=0"

REM Projekte in direkten Unterordnern suchen
for /d %%D in ("%PROJECT_ROOT%\*") do (
    if /i not "%%~nxD"=="Toolchain" (
        for %%F in ("%%~fD\*.uproject") do (
            if exist "%%~fF" (
                set /a COUNT+=1
                set "PROJECT_!COUNT!=%%~fF"
                echo !COUNT!^) %%~nxD\%%~nxF
            )
        )
    )
)

if "!COUNT!"=="0" (
    echo Keine .uproject-Datei in direkten Unterordnern gefunden.
    echo ProjektRoot: "%PROJECT_ROOT%"
    pause
    exit /b 1
)

if "!COUNT!"=="1" (
    set "UPROJECT=!PROJECT_1!"
    goto :Launch
)

echo.
set /p "CHOICE=Projektnummer eingeben: "

if not defined CHOICE goto :InvalidChoice
for /f "delims=0123456789" %%A in ("!CHOICE!") do goto :InvalidChoice
if !CHOICE! LSS 1 goto :InvalidChoice
if !CHOICE! GTR !COUNT! goto :InvalidChoice

set "UPROJECT=!PROJECT_%CHOICE%!"

:Launch
echo.
echo Starte: "!UPROJECT!"
start "" "%UE_EDITOR%" "%UPROJECT%"
exit /b 0

:InvalidChoice
echo Ungueltige Auswahl.
pause
exit /b 1
