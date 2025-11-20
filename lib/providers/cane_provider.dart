import 'package:flutter/foundation.dart';

class CaneProvider with ChangeNotifier {
  // 지팡이 연결 상태
  bool _isConnected = false;
  int _batteryLevel = 78;
  DateTime? _lastUpdate;

  // 설정
  bool _voiceGuidanceEnabled = true;
  double _voiceSpeed = 1.0;
  double _voiceVolume = 0.7;
  String _voiceType = '기본 여자목소리';

  // Getters
  bool get isConnected => _isConnected;
  int get batteryLevel => _batteryLevel;
  DateTime? get lastUpdate => _lastUpdate;
  bool get voiceGuidanceEnabled => _voiceGuidanceEnabled;
  double get voiceSpeed => _voiceSpeed;
  double get voiceVolume => _voiceVolume;
  String get voiceType => _voiceType;

  // 지팡이 연결
  void toggleConnection() {
    _isConnected = !_isConnected;
    _lastUpdate = DateTime.now();
    notifyListeners();
  }

  void refreshConnection() {
    _lastUpdate = DateTime.now();
    notifyListeners();
  }

  // 설정 업데이트
  void setVoiceGuidance(bool enabled) {
    _voiceGuidanceEnabled = enabled;
    notifyListeners();
  }

  void setVoiceSpeed(double speed) {
    _voiceSpeed = speed;
    notifyListeners();
  }

  void setVoiceVolume(double volume) {
    _voiceVolume = volume;
    notifyListeners();
  }

  void setVoiceType(String type) {
    _voiceType = type;
    notifyListeners();
  }

  // 테스트용 진동
  void testVibration() {
    // TODO: 실제 지팡이에 진동 신호 전송
    debugPrint('Testing vibration...');
  }

  // 배터리 업데이트
  void updateBattery(int level) {
    _batteryLevel = level;
    notifyListeners();
  }
}
