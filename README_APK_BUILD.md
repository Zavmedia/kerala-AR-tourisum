# 🚀 Zenscape AR Tourism - APK Build Guide

## Quick APK Build Instructions

### Prerequisites
1. **Install Flutter**: Download from https://flutter.dev/docs/get-started/install/windows
2. **Extract to**: `C:\flutter`
3. **Add to PATH**: Add `C:\flutter\bin` to your Windows PATH
4. **Install Android SDK**: Through Android Studio or standalone

### Build APK (Windows)
```bash
# Double-click the build_apk.bat file, or run:
build_apk.bat
```

### Build APK (Linux/Mac)
```bash
# Make executable and run:
chmod +x build_apk.sh
./build_apk.sh
```

### Manual Build Commands
```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release --split-per-abi
```

## 📱 APK Output
After successful build, APK files will be in:
```
build/app/outputs/flutter-apk/
├── app-arm64-v8a-release.apk    # 64-bit ARM (Recommended)
├── app-armeabi-v7a-release.apk  # 32-bit ARM
└── app-x86_64-release.apk       # 64-bit x86 (Emulators)
```

## 🎯 What's Included in the APK
- ✅ **Heritage Dashboard** with AR integration
- ✅ **Business Features**: Checkout, Discover, Guide Booking, Feedback
- ✅ **Stunning Animations**: Confetti, parallax, shimmer effects
- ✅ **Offline Support**: Local database, cached content
- ✅ **Multi-language**: English, Malayalam, Hindi, Tamil
- ✅ **AR Services**: 3D model rendering, location tracking
- ✅ **Social Features**: User profiles, comments, likes
- ✅ **Gamification**: Achievements, badges, leaderboards

## 🔧 Troubleshooting
If build fails:
1. Run `flutter doctor` to check setup
2. Ensure Android SDK is installed
3. Check if all dependencies are resolved
4. Try `flutter clean` and `flutter pub get`

## 📲 Installation
1. Enable "Unknown Sources" in Android settings
2. Install `app-arm64-v8a-release.apk` on your device
3. Launch "Zenscape AR Tourism"

## 🎉 Features to Test
- **Main Dashboard**: Explore heritage sites
- **Business Features**: Tap "More" tab → Business Features
- **AR Experience**: Point camera at heritage sites
- **Offline Mode**: Test without internet connection
- **Multi-language**: Change language in settings

---
**Built with ❤️ for Kerala's Heritage Tourism**
