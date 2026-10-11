@echo off
setlocal

REM Android-Pfade laden
call "%~dp0AndroidPaths.bat"

REM Projektverzeichnis ist der übergeordnete Ordner von Unreal\
set "PROJECT_ROOT=%~dp0"
for %%I in ("%PROJECT_ROOT%") do set "PROJECT_ROOT=%%~fI"

REM Unreal-Projekt automatisch finden
set "UPROJECT="

for %%F in ("%PROJECT_ROOT%\*.uproject") do (
    if exist "%%~fF" set "UPROJECT=%%~fF"
)

if not defined UPROJECT (
    echo FEHLER: Keine .uproject-Datei gefunden in:
    echo %PROJECT_ROOT%
    pause
    exit /b 1
)

set "UE_ROOT=C:\Program Files\Epic Games\UE_5.8"
set "RUNUAT=%UE_ROOT%\Engine\Build\BatchFiles\RunUAT.bat"

if not exist "%RUNUAT%" (
    echo FEHLER: RunUAT.bat nicht gefunden:
    echo %RUNUAT%
    pause
    exit /b 1
)

echo Projekt: %UPROJECT%
echo Engine:  %UE_ROOT%


call "%RUNUAT%" BuildCookRun ^
  -project="%UPROJECT%" ^
  -noP4 ^
  -installed ^
  -ue4exe="%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe" ^
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
  -archivedirectory="%PROJECT_ROOT%\Build\Android"

if errorlevel 1 (
    echo BUILD FEHLGESCHLAGEN
    pause
    exit /b 1
)

echo BUILD ERFOLGREICH
pause
exit /b 0