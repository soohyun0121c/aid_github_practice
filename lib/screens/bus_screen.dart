import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../providers/cane_provider.dart';
// 버스 데이터 모델은 사용하지 않음 (고정 음성만 사용)

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  String _currentStation = '중앙대학교 후문';
  bool _isWaiting = false;

  // 데이터 사용 안함 (고정 음성 문구만 사용)

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('ko-KR');
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    final provider = Provider.of<CaneProvider>(context, listen: false);
    await _flutterTts.setSpeechRate(provider.voiceSpeed);
    await _flutterTts.setVolume(provider.voiceVolume);
    await _flutterTts.speak(text);
  }

  Future<void> _announceDelayedBus() async {
    if (_isWaiting) return;
    setState(() => _isWaiting = true);
    await Future.delayed(const Duration(seconds: 3));
    await _speak('동작 공일이 잠시 후, 그리고 7분 뒤 도착 예정입니다');
    setState(() => _isWaiting = false);
  }

  // 실데이터 연동 제거: 고정 음성 문구만 사용

  // 고정 문구만 사용하므로 데이터 기반 Getter는 비활성화

  @override
  Widget build(BuildContext context) {
    return Consumer<CaneProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCurrentStation(),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildVoiceButton(
                    title: '정차 중인 버스',
                    icon: Icons.stop_circle,
                    color: Colors.red,
                    onPressed: _announceStoppedBuses,
                  ),
                  const SizedBox(height: 20),
                  _buildVoiceButton(
                    title: '곧 도착 버스',
                    icon: Icons.directions_bus,
                    color: Colors.orange,
                    onPressed: _announceArrivingBuses,
                  ),
                  const SizedBox(height: 20),
                  _buildVoiceButton(
                    title: _isWaiting ? '대기 중…' : '음성으로 버스 번호 말하기',
                    icon: Icons.schedule,
                    color: Colors.blue,
                    onPressed: _announceDelayedBus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStation() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '현재 정류장',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _currentStation,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.blue),
              onPressed: () {
                _speak('현재 정류장은 $_currentStation 입니다');
              },
              tooltip: '음성으로 듣기',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _announceStoppedBuses() async {
    await _speak('정차 중인 버스는 동작 이일, 동작 공일 입니다');
  }

  Future<void> _announceArrivingBuses() async {
    await _speak('오오일일이 4분 뒤 도착 예정입니다');
  }

  // 기타 버튼은 음성 검색으로 대체됨

  // 검색 기능 제거 (요청에 따라 고정 문구만 사용)

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
