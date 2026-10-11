
@echo off
setlocal EnableExtensions EnableDelayedExpansion

for %%I in ("%~dp0.") do set "PROJECT_ROOT=%%~fI"
call "%PROJECT_ROOT%\AndroidPaths.bat"

REM Unreal Engine
set "UE_ROOT=C:\Program Files\Epic Games\UE_5.8"
set "RUNUAT=%UE_ROOT%\Engine\Build\BatchFiles\RunUAT.bat"
set "UE_CMD=%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe"

if not exist "%RUNUAT%" (
    echo FEHLER: RunUAT.bat nicht gefunden:
    echo "%RUNUAT%"
    pause
    exit /b 1
)

if not exist "%UE_CMD%" (
    echo FEHLER: UnrealEditor-Cmd.exe nicht gefunden:
    echo "%UE_CMD%"
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
    goto :Build
)

echo.
set /p "CHOICE=Projektnummer eingeben: "

if not defined CHOICE goto :InvalidChoice
for /f "delims=0123456789" %%A in ("!CHOICE!") do goto :InvalidChoice
if !CHOICE! LSS 1 goto :InvalidChoice
if !CHOICE! GTR !COUNT! goto :InvalidChoice

set "UPROJECT=!PROJECT_%CHOICE%!"

:Build
for %%I in ("!UPROJECT!") do set "PROJECT_FOLDER=%%~dpI"
set "ARCHIVE_DIR=!PROJECT_FOLDER!Build\Android"

if not exist "!ARCHIVE_DIR!" mkdir "!ARCHIVE_DIR!"

echo.
echo Projekt: "!UPROJECT!"
echo Ausgabe: "!ARCHIVE_DIR!"
echo.

call "%RUNUAT%" BuildCookRun ^
  -project="!UPROJECT!" ^
  -noP4 ^
  -installed ^
  -ue4exe="%UE_CMD%" ^
  -platform=Android ^
  -clientconfig=Development ^
  -nocompileeditor ^
  -skipbuildeditor ^
  -cook ^
  -build ^
  -stage ^
  -pak ^
  -package ^
  -archive ^
  -archivedirectory="!ARCHIVE_DIR!"

if errorlevel 1 (
    echo.
    echo BUILD FEHLGESCHLAGEN
    pause
    exit /b 1
)

echo.
echo BUILD ERFOLGREICH
echo Ausgabe: "!ARCHIVE_DIR!"
pause
exit /b 0

:InvalidChoice
echo Ungueltige Auswahl.
pause
exit /b 1
