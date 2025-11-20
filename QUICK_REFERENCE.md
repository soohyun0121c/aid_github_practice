# 빠른 참조 가이드

## 🚀 빠른 시작

```bash
# 의존성 설치
flutter pub get

# 앱 실행 (디버그 모드)
flutter run

# 앱 실행 (릴리스 모드)
flutter run --release
```

## 📱 주요 명령어

```bash
# 연결된 디바이스 확인
flutter devices

# 특정 디바이스에서 실행
flutter run -d <device_id>

# 핫 리로드 (앱 실행 중 'r' 키)
# 핫 리스타트 (앱 실행 중 'R' 키)

# 빌드
flutter build apk          # Android APK
flutter build appbundle    # Android App Bundle
flutter build ios          # iOS (Mac만 가능)

# 캐시 정리
flutter clean

# 프로젝트 상태 확인
flutter doctor
```

## 🔧 자주 묻는 질문

### Q: 지팡이 연결 상태를 변경하려면?
**A:** 홈 화면 또는 설정 화면에서 새로고침/연결 버튼 클릭

### Q: 긴급 연락처를 추가하려면?
**A:** SOS 페이지 > 긴급 연락처 탭 > 우측 상단 '추가' 버튼

### Q: 지팡이 위치를 확인하려면?
**A:** 하단 탭에서 '위치' 선택

### Q: 음성 안내 설정을 변경하려면?
**A:** 설정 페이지 > 음성 안내 섹션

### Q: Google Maps가 표시되지 않으면?
**A:** 
1. API 키가 올바르게 설정되었는지 확인
2. `SETUP_GUIDE.md` 문서의 "Google Maps API 키 설정" 섹션 참조

## 🎨 UI 컴포넌트 위치

| 기능 | 위치 |
|------|------|
| 지팡이 연결 상태 | 홈 화면 상단 카드 |
| 배터리 상태 | 홈 화면 하단 카드 |
| SOS 테스트 | 홈 화면 빠른 액션 |
| 지팡이 위치 | 위치 탭 |
| 긴급 연락처 관리 | SOS 탭 > 긴급 연락처 |
| 도움 요청 설정 | SOS 탭 > 주변 도움 요청 |
| 버튼 동작 설정 | 설정 탭 > 버튼 설정 |
| 음성 안내 | 설정 탭 > 음성 안내 |
| 진동 패턴 | 설정 탭 > 진동 패턴 |

## 💾 데이터 흐름

```
사용자 액션
    ↓
UI (Screens)
    ↓
Provider (CaneProvider)
    ↓
상태 업데이트
    ↓
UI 자동 갱신 (Consumer/Provider.of)
```

## 🔑 중요 파일

| 파일 | 역할 |
|------|------|
| `lib/main.dart` | 앱 진입점, 네비게이션 |
| `lib/providers/cane_provider.dart` | 전역 상태 관리 |
| `lib/screens/home_screen.dart` | 홈 화면 UI |
| `lib/screens/location_screen.dart` | 위치 페이지 UI |
| `lib/screens/sos_screen.dart` | SOS 페이지 UI (2탭) |
| `lib/screens/settings_screen.dart` | 설정 페이지 UI |
| `android/app/src/main/AndroidManifest.xml` | Android 권한 & API 키 |
| `ios/Runner/Info.plist` | iOS 권한 |

## 🛠️ 커스터마이징

### 앱 이름 변경
- `android/app/src/main/AndroidManifest.xml`: `android:label`
- `ios/Runner/Info.plist`: `CFBundleDisplayName`
- `lib/main.dart`: `title` 속성

### 앱 아이콘 변경
1. 아이콘 파일 준비 (1024x1024 PNG)
2. [App Icon Generator](https://appicon.co/) 사용
3. 생성된 파일을 각 플랫폼 폴더에 복사

### 테마 색상 변경
`lib/main.dart`에서:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // 원하는 색상으로 변경
),
```

## 📊 성능 최적화

```bash
# 프로파일 모드로 실행
flutter run --profile

# 릴리스 빌드 크기 분석
flutter build apk --analyze-size
```

## 🐛 디버깅

```bash
# 로그 확인
flutter logs

# Dart DevTools 실행
flutter pub global activate devtools
flutter pub global run devtools
```

## 📞 지원

문제가 발생하면 다음 문서를 참조하세요:
- `SETUP_GUIDE.md` - 설치 및 설정
- `README_APP.md` - 기능 상세 설명
- `IMPLEMENTATION.md` - 구현 완료 사항

또는 Flutter 공식 문서:
- https://flutter.dev/docs
- https://pub.dev (패키지 검색)
