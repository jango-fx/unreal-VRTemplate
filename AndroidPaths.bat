
@echo off
REM Gemeinsame Android-Toolchain fuer alle Projekte

for %%I in ("%~dp0.") do set "PROJECT_ROOT=%%~fI"
set "TOOLCHAIN_ROOT=%PROJECT_ROOT%\Toolchain"

REM Android SDK
set "ANDROID_HOME=%TOOLCHAIN_ROOT%\AndroidSDK"
set "ANDROID_SDK_ROOT=%ANDROID_HOME%"

REM Android NDK
set "ANDROID_NDK_ROOT=%ANDROID_HOME%\ndk\27.2.12479018"
set "NDKROOT=%ANDROID_NDK_ROOT%"
set "NDK_ROOT=%ANDROID_NDK_ROOT%"

REM Java Development Kit
set "JAVA_HOME=%TOOLCHAIN_ROOT%\JDK"

REM Werkzeuge zum PATH hinzufuegen
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%PATH%"
