@echo off
echo ========================================
echo    Zenscape AR Tourism - APK Builder
echo ========================================
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found in PATH!
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install/windows
    echo And add C:\flutter\bin to your PATH
    pause
    exit /b 1
)

echo.
echo Flutter found! Starting APK build...
echo.

echo Step 1: Cleaning previous builds...
flutter clean

echo.
echo Step 2: Getting dependencies...
flutter pub get

echo.
echo Step 3: Building release APK...
flutter build apk --release --split-per-abi

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo    APK BUILD SUCCESSFUL! 🎉
    echo ========================================
    echo.
    echo APK files created in: build\app\outputs\flutter-apk\
    echo.
    echo Available APKs:
    echo - app-arm64-v8a-release.apk (64-bit ARM)
    echo - app-armeabi-v7a-release.apk (32-bit ARM)
    echo - app-x86_64-release.apk (64-bit x86)
    echo.
    echo Install the ARM64 version on most modern Android devices.
    echo.
    echo Opening APK folder...
    start build\app\outputs\flutter-apk\
) else (
    echo.
    echo ========================================
    echo    APK BUILD FAILED! ❌
    echo ========================================
    echo.
    echo Please check the error messages above.
    echo Common solutions:
    echo 1. Run 'flutter doctor' to check setup
    echo 2. Ensure Android SDK is installed
    echo 3. Check if all dependencies are resolved
)

echo.
pause
