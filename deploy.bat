@echo off
setlocal EnableDelayedExpansion

echo ===============================
echo   STARTING DEPLOY PROCESS 🚀
echo ===============================

for /f "tokens=2 delims=: " %%a in ('findstr /b "version:" pubspec.yaml') do set VERSION=%%a

echo Current Version: %VERSION%

echo Running Flutter Clean...
call flutter clean

echo Getting Packages...
call flutter pub get

echo Building APK...
call flutter build apk --release --split-per-abi

if %errorlevel% neq 0 (
    echo ❌ Build Failed!
    pause
    exit /b
)


echo ===============================
echo   DEPLOY COMPLETED 🎉
echo ===============================
pause
