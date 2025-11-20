# 스마트 지팡이 앱 - 설치 및 설정 가이드

## Google Maps API 키 설정

Google Maps를 사용하려면 API 키가 필요합니다.

### 1. Google Cloud Console에서 API 키 받기

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 새 프로젝트 생성 또는 기존 프로젝트 선택
3. "API 및 서비스" > "라이브러리" 이동
4. "Maps SDK for Android" 및 "Maps SDK for iOS" 검색 후 활성화
5. "사용자 인증 정보" > "사용자 인증 정보 만들기" > "API 키" 선택
6. API 키 복사

### 2. Android 설정

`android/app/src/main/AndroidManifest.xml` 파일 열기:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="여기에_실제_API_키_입력"/>
```

`YOUR_GOOGLE_MAPS_API_KEY_HERE`를 실제 API 키로 교체하세요.

### 3. iOS 설정

#### 3.1 `ios/Runner/AppDelegate.swift` 파일 수정:

```swift
import UIKit
import Flutter
import GoogleMaps  // 이 줄 추가

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("여기에_실제_API_키_입력")  // 이 줄 추가
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### 3.2 `ios/Podfile` 수정 (필요시):

```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '12.0'  # 최소 버전 확인
```

그 후 터미널에서:
```bash
cd ios
pod install
cd ..
```

## 의존성 설치

```bash
flutter pub get
```

## 앱 실행

### Android
```bash
flutter run
```

### iOS (Mac만 가능)
```bash
flutter run
```

### 특정 디바이스 선택
```bash
flutter devices  # 사용 가능한 디바이스 목록 확인
flutter run -d device_id  # 특정 디바이스에서 실행
```

## 빌드

### Android APK
```bash
flutter build apk --release
```

생성된 APK 위치: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Google Play 배포용)
```bash
flutter build appbundle --release
```

### iOS (Mac만 가능)
```bash
flutter build ios --release
```

## 문제 해결

### 1. 위치 권한이 작동하지 않는 경우

#### Android
`android/app/src/main/AndroidManifest.xml`에 다음 권한이 있는지 확인:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS
`ios/Runner/Info.plist`에 다음 설명이 있는지 확인:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>지팡이의 위치를 확인하기 위해 위치 권한이 필요합니다.</string>
```

### 2. Google Maps가 표시되지 않는 경우

1. API 키가 올바르게 설정되었는지 확인
2. Google Cloud Console에서 해당 API가 활성화되었는지 확인
3. API 키에 제한이 설정되어 있다면 앱의 패키지명/번들ID가 허용되어 있는지 확인

### 3. 연락처 권한 오류

#### Android
```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

#### iOS
```xml
<key>NSContactsUsageDescription</key>
<string>긴급 연락처를 추가하기 위해 연락처 접근 권한이 필요합니다.</string>
```

### 4. 의존성 충돌

```bash
flutter clean
flutter pub get
```

### 5. iOS Pod 오류

```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

## 개발 팁

### Hot Reload
코드 변경 후 `r` 키를 눌러 Hot Reload 사용

### Hot Restart
`R` 키를 눌러 앱 전체 재시작

### 디버그 모드에서 성능 오버레이 표시
```bash
flutter run --profile
```

### 로그 확인
```bash
flutter logs
```

## 다음 단계

1. Google Maps API 키 설정 완료
2. 실제 디바이스에서 테스트
3. 블루투스 지팡이 연동 구현 (추후)
4. 서버 API 연동 (추후)

## 지원

문제가 발생하면 다음을 확인하세요:
- Flutter 버전: `flutter --version`
- 디바이스 연결: `flutter devices`
- 프로젝트 상태: `flutter doctor`
