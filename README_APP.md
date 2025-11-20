# 스마트 지팡이 앱

시각장애인을 위한 스마트 지팡이 관리 및 긴급 알림 앱

## 주요 기능

### 1. 홈 화면
- **지팡이 연결 상태**: 실시간 지팡이 연결 상태 확인
- **배터리 상태**: 지팡이 배터리 잔량 표시
- **빠른 액션**: SOS 테스트 및 위치 확인 바로가기
- **마지막 SOS 기록**: 최근 긴급 알림 내역 표시

### 2. 위치 페이지
- **Google Maps 통합**: 지팡이 실시간 위치 표시
- **거리 측정**: 사용자와 지팡이 간 거리 계산
- **지도 내비게이션**: 
  - 내 위치로 이동
  - 지팡이 위치로 이동
  - 외부 지도 앱 연동 (길찾기)
- **위치 공유**: 카카오톡 등으로 위치 공유 (추후 구현)

### 3. SOS / 도움 요청 페이지

#### 긴급 연락처 탭
- 긴급 연락처 추가/수정/삭제
- 긴급 메시지 템플릿 설정
- 전송 정보 설정 (위치, 배터리, 개인정보 등)
- SOS 테스트 미리보기

#### 주변 도움 요청 탭
- 개인정보 공개 범위 설정
- 주변 도움 요청 메시지 커스터마이징
- 공개 범위 설정 (앱 사용자/자원봉사자/전체)
- 메시지 미리보기

### 4. 지팡이 설정 페이지

#### 버튼 동작 설정
- SOS 버튼 짧게 누르기: 주변 도움 요청
- SOS 버튼 길게 누르기: 긴급 연락처에 SOS 전송
- 모드 버튼: 보행 모드 전환

#### 음성 안내 설정
- 음성 안내 ON/OFF
- 음성 속도 조절 (0.5x ~ 2.0x)
- 음성 볼륨 조절
- 목소리 종류 선택
- 테스트 재생

#### 진동 피드백 설정
- 장애물 감지 진동 패턴
- 계단/내리막 진동 패턴
- 버스 도착 알림 진동 패턴
- 진동 테스트

#### 기타 설정
- 앱 알림 허용
- 펌웨어 업데이트
- 설정 초기화

## 기술 스택

- **Framework**: Flutter 3.9.2
- **State Management**: Provider
- **지도**: Google Maps Flutter
- **위치 서비스**: Geolocator, Geocoding
- **권한 관리**: Permission Handler
- **로컬 저장소**: Shared Preferences
- **날짜 포맷**: Intl

## 시작하기

### 사전 요구사항

- Flutter SDK 3.9.2 이상
- Dart SDK 3.9.2 이상
- Android Studio / Xcode (플랫폼별)
- Google Maps API 키

### 설치 방법

1. 저장소 클론 또는 다운로드

2. 의존성 설치
```bash
flutter pub get
```

3. Google Maps API 키 설정

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

#### iOS (`ios/Runner/AppDelegate.swift`)
```swift
GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

4. 앱 실행
```bash
flutter run
```

## 권한 설정

### Android (`android/app/src/main/AndroidManifest.xml`)
다음 권한들이 이미 설정되어 있어야 합니다:
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `INTERNET`
- `READ_CONTACTS`
- `VIBRATE`

### iOS (`ios/Runner/Info.plist`)
다음 권한 설명이 필요합니다:
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysUsageDescription`
- `NSContactsUsageDescription`

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점 및 메인 네비게이션
├── models/                   # 데이터 모델
│   ├── emergency_contact.dart
│   └── sos_record.dart
├── providers/                # State 관리
│   └── cane_provider.dart
└── screens/                  # UI 화면
    ├── home_screen.dart      # 홈 화면
    ├── location_screen.dart  # 위치 페이지
    ├── sos_screen.dart       # SOS/도움요청 페이지
    └── settings_screen.dart  # 설정 페이지
```

## 추후 구현 예정

- [ ] 실제 블루투스 지팡이 연동
- [ ] 실시간 위치 추적
- [ ] 카카오톡 위치 공유
- [ ] SOS 기록 상세 페이지
- [ ] 프로필/사용자 정보 페이지
- [ ] 로그/기록 페이지
- [ ] 펌웨어 OTA 업데이트
- [ ] 푸시 알림
- [ ] 서버 연동 (주변 도움 요청)

## 라이센스

© 2025 AI Group Project
