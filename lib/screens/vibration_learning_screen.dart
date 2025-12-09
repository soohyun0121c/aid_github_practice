import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../providers/cane_provider.dart';

class VibrationLearningScreen extends StatefulWidget {
  const VibrationLearningScreen({super.key});

  @override
  State<VibrationLearningScreen> createState() =>
      _VibrationLearningScreenState();
}

class _VibrationLearningScreenState extends State<VibrationLearningScreen> {
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('ko-KR');
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  Future<void> _speak(String text) async {
    if (!mounted) return;
    try {
      final provider = Provider.of<CaneProvider>(context, listen: false);
      await _tts.stop();
      await _tts.setSpeechRate(provider.voiceSpeed);
      await _tts.setVolume(provider.voiceVolume);
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진동 패턴 학습'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '현재 동작:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPatternButton('계단'),
                  const SizedBox(height: 12),
                  _buildPatternButton('차도'),
                  const SizedBox(height: 12),
                  _buildPatternButton('장애물'),
                  const SizedBox(height: 12),
                  _buildPatternButton('사람'),
                  const SizedBox(height: 12),
                  _buildPatternButton('자전거'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternButton(String label) {
    // 각 라벨에 맞는 아이콘 매핑
    IconData icon;
    switch (label) {
      case '계단':
        icon = Icons.stairs;
        break;
      case '차도':
        icon = Icons.local_shipping;
        break;
      case '장애물':
        icon = Icons.warning;
        break;
      case '사람':
        icon = Icons.person;
        break;
      case '자전거':
        icon = Icons.directions_bike;
        break;
      default:
        icon = Icons.help;
    }

    return Card(
      elevation: 3,
      child: InkWell(
        onTap: () => _speak('$label 진동입니다'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
