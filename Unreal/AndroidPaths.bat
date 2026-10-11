
@echo off

REM Gemeinsamer Toolchain-Ordner
for %%I in ("%~dp0..\Toolchain") do set "TOOLCHAIN_ROOT=%%~fI"

REM Android SDK
set "ANDROID_HOME=%TOOLCHAIN_ROOT%\AndroidSDK"
set "ANDROID_SDK_ROOT=%ANDROID_HOME%"

REM NDK liegt innerhalb des SDK
set "ANDROID_NDK_ROOT=%ANDROID_HOME%\ndk\27.2.12479018"
set "NDKROOT=%ANDROID_NDK_ROOT%"
set "NDK_ROOT=%ANDROID_NDK_ROOT%"

REM JDK
set "JAVA_HOME=%TOOLCHAIN_ROOT%\JDK"

REM Werkzeuge auffindbar machen
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\platform-tools;%PATH%"
