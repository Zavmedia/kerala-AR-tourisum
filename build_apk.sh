#!/bin/bash

echo "========================================"
echo "   Zenscape AR Tourism - APK Builder"
echo "========================================"
echo

echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter not found in PATH!"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    echo "And add Flutter bin directory to your PATH"
    exit 1
fi

flutter --version
echo

echo "Flutter found! Starting APK build..."
echo

echo "Step 1: Cleaning previous builds..."
flutter clean

echo
echo "Step 2: Getting dependencies..."
flutter pub get

echo
echo "Step 3: Building release APK..."
flutter build apk --release --split-per-abi

if [ $? -eq 0 ]; then
    echo
    echo "========================================"
    echo "   APK BUILD SUCCESSFUL! 🎉"
    echo "========================================"
    echo
    echo "APK files created in: build/app/outputs/flutter-apk/"
    echo
    echo "Available APKs:"
    echo "- app-arm64-v8a-release.apk (64-bit ARM)"
    echo "- app-armeabi-v7a-release.apk (32-bit ARM)"
    echo "- app-x86_64-release.apk (64-bit x86)"
    echo
    echo "Install the ARM64 version on most modern Android devices."
    echo
    echo "Opening APK folder..."
    if command -v xdg-open &> /dev/null; then
        xdg-open build/app/outputs/flutter-apk/
    elif command -v open &> /dev/null; then
        open build/app/outputs/flutter-apk/
    fi
else
    echo
    echo "========================================"
    echo "   APK BUILD FAILED! ❌"
    echo "========================================"
    echo
    echo "Please check the error messages above."
    echo "Common solutions:"
    echo "1. Run 'flutter doctor' to check setup"
    echo "2. Ensure Android SDK is installed"
    echo "3. Check if all dependencies are resolved"
fi

echo
read -p "Press Enter to continue..."
