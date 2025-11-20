import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../providers/cane_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage('ko-KR');
    } catch (e) {
      debugPrint('TTS initialization error: $e');
    }
  }

  Future<void> _testVoice(CaneProvider provider) async {
    try {
      await _flutterTts.setSpeechRate(provider.voiceSpeed);
      await _flutterTts.setVolume(provider.voiceVolume);
      await _flutterTts.speak('스마트 지팡이 어플리케이션입니다');
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CaneProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 연결 상태
              _buildConnectionStatus(context, provider),
              const SizedBox(height: 24),

              // 음성 안내 설정
              _buildSectionTitle('음성 안내'),
              _buildVoiceSettings(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context, CaneProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  provider.isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: provider.isConnected ? Colors.green : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.isConnected ? '지팡이 연결됨' : '지팡이 연결 안 됨',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: provider.isConnected
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        provider.isConnected ? '정상 작동 중' : '연결이 필요합니다',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!provider.isConnected) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.toggleConnection();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('지팡이 연결 중...')),
                    );
                  },
                  icon: const Icon(Icons.bluetooth_searching),
                  label: const Text('지팡이 연결하기'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceSettings(BuildContext context, CaneProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('음성 안내 사용하기'),
              value: provider.voiceGuidanceEnabled,
              onChanged: (value) => provider.setVoiceGuidance(value),
              contentPadding: EdgeInsets.zero,
            ),
            if (provider.voiceGuidanceEnabled) ...[
              const Divider(),
              const SizedBox(height: 8),

              // 음성 속도
              const Text(
                '음성 속도',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text('느림'),
                  Expanded(
                    child: Slider(
                      value: provider.voiceSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 6,
                      label: '${provider.voiceSpeed.toStringAsFixed(1)}x',
                      onChanged: (value) => provider.setVoiceSpeed(value),
                    ),
                  ),
                  const Text('빠름'),
                ],
              ),
              const SizedBox(height: 16),

              // 음성 크기
              const Text(
                '음성 크기',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.volume_down),
                  Expanded(
                    child: Slider(
                      value: provider.voiceVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(provider.voiceVolume * 100).toInt()}%',
                      onChanged: (value) => provider.setVoiceVolume(value),
                    ),
                  ),
                  const Icon(Icons.volume_up),
                ],
              ),
              const SizedBox(height: 16),

              // 테스트 재생
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _testVoice(provider),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('테스트 재생'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
