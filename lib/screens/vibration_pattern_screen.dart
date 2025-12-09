import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../providers/cane_provider.dart';

class VibrationPatternScreen extends StatefulWidget {
  final void Function(int) onNavigateToTab;
  final int activeTabIndex; // which bottom nav tab to highlight
  const VibrationPatternScreen({
    super.key,
    required this.onNavigateToTab,
    required this.activeTabIndex,
  });

  @override
  State<VibrationPatternScreen> createState() => _VibrationPatternScreenState();
}

class _VibrationPatternScreenState extends State<VibrationPatternScreen> {
  final FlutterTts _tts = FlutterTts();

  late List<_VibrationItem> _cachedItems;
  bool _itemsReady = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initializeItems();
  }

  List<_VibrationItem> get _items {
    if (!_itemsReady) {
      _initializeItems();
    }
    return _cachedItems;
  }

  void _initializeItems() {
    _cachedItems = [
      _VibrationItem(
        title: '계단 감지',
        patternVisual: '- - - -',
        description: '네 번의 짧은 진동으로 계단을 알림',
        pattern: _pattern([
          shortOn,
          gapShort,
          shortOn,
          gapShort,
          shortOn,
          gapShort,
          shortOn,
        ]),
      ),
      _VibrationItem(
        title: '차도',
        patternVisual: '~~~~~',
        description: '연속 진동으로 차도 접근 경고',
        pattern: _pattern([
          continuousOn,
          gapShort,
          continuousOn,
          gapShort,
          continuousOn,
        ]),
      ),
      _VibrationItem(
        title: '장애물 (전봇대/변압기)',
        patternVisual: '--- - --- -',
        description: '긴-짧음 반복으로 고정 장애물 경고',
        pattern: _pattern([
          longOn,
          gapShort,
          shortOn,
          gapShort,
          longOn,
          gapShort,
          shortOn,
        ]),
      ),
      _VibrationItem(
        title: '장애물 (사람)',
        patternVisual: '-- - -- -',
        description: '중간-짧음 반복으로 이동 장애물(사람) 경고',
        pattern: _pattern([
          mediumOn,
          gapShort,
          shortOn,
          gapShort,
          mediumOn,
          gapShort,
          shortOn,
        ]),
      ),
      _VibrationItem.dynamic(
        title: '자전거 (거리별)',
        patternVisual: '-   -   -   - / -  -  -  -  - / - - - - - -',
        description: '거리 감소에 따라 간격이 좁아지는 경고 패턴',
        dynamicBuilder: _bicyclePattern,
      ),
    ];
    _itemsReady = true;
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('ko-KR');
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  // Pattern symbol legend mapping
  // '-'  : 짧은 진동 (short 200ms)
  // '--' : 중간 (medium 400ms)
  // '---': 긴 (long 600ms)
  // '~'  : 연속 (continuous 1500ms)
  // Off gaps vary by context.

  static const int shortOn = 200;
  static const int mediumOn = 400;
  static const int longOn = 600;
  static const int continuousOn = 1500;

  static const int gapShort = 150;
  static const int gapMedium = 350;
  static const int gapLong = 500;

  // Helper to build vibration pattern (on/off alternating list)
  List<int> _pattern(List<int> pulses, {int lastGap = 0}) {
    // pulses already include on + off sequence except final gap optionally
    final result = List<int>.from(pulses);
    if (lastGap > 0) {
      result.add(lastGap);
    }
    return result;
  }

  Future<void> _play(List<int> pattern) async {
    // No-op: vibration removed per requirement.
  }

  Future<void> _speak(String text) async {
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

  // Bicycle pattern changes by distance bucket.
  List<int> _bicyclePattern(double distanceMeters) {
    if (distanceMeters <= 5) {
      // Rapid six short pulses: - - - - - -
      return _pattern([
        shortOn,
        gapShort,
        shortOn,
        gapShort,
        shortOn,
        gapShort,
        shortOn,
        gapShort,
        shortOn,
        gapShort,
        shortOn,
      ]);
    } else if (distanceMeters <= 10) {
      // Medium spacing five pulses: -  -  -  -  -
      return _pattern([
        shortOn,
        gapMedium,
        shortOn,
        gapMedium,
        shortOn,
        gapMedium,
        shortOn,
        gapMedium,
        shortOn,
      ]);
    } else {
      // Long spacing four pulses: -   -   -   - (15~10m)
      return _pattern([
        shortOn,
        gapLong,
        shortOn,
        gapLong,
        shortOn,
        gapLong,
        shortOn,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('진동 패턴 학습')),
      body: Column(
        children: [
          // 상단 영역: 학습 컨텐츠 (스크롤)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildLegendCard();
                }
                final item = _items[index - 1];
                return _buildPatternCard(item);
              },
            ),
          ),

          // 하단 영역: 빠른 진동 버튼 (빈칸 없이 꽉 채움)
          _buildQuickButtons(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.activeTabIndex,
        onTap: (index) {
          if (index == widget.activeTabIndex) return; // already selected
          widget.onNavigateToTab(index);
          Navigator.of(context).pop();
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: '위치'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: '버스',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }

  Widget _buildLegendCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '표기 설명',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _legendRow('-', '짧은 진동 (약 0.2초)'),
              _legendRow('--', '중간 진동 (약 0.4초)'),
              _legendRow('---', '긴 진동 (약 0.6초)'),
              _legendRow('~', '연속 진동 (1.5초)'),
              _legendRow('공백', '진동 사이 휴지 (간격)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendRow(String symbol, String meaning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              symbol,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(meaning)),
        ],
      ),
    );
  }

  Widget _buildPatternCard(_VibrationItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.patternVisual,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.description,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              if (item.isDynamic)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _play(item.dynamicBuilder!(15)),
                        child: const Text('재생 (15~10m)'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _play(item.dynamicBuilder!(8)),
                        child: const Text('재생 (10~5m)'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _play(item.dynamicBuilder!(4)),
                        child: const Text('재생 (5m 이내)'),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _play(item.pattern),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('재생'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickButtons() {
    // Items always available through getter with lazy init
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _quickButton('계단 감지', _items[0].pattern),
          const SizedBox(height: 8),
          _quickButton('차도', _items[1].pattern),
          const SizedBox(height: 8),
          _quickButton('장애물', _items[2].pattern),
          const SizedBox(height: 8),
          _quickButton('사람', _items[3].pattern),
          const SizedBox(height: 8),
          _quickButton('자전거', _items[4].dynamicBuilder!(8)),
        ],
      ),
    );
  }

  Widget _quickButton(String label, List<int> pattern) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        await _speak('$label 진동입니다');
        await _play(pattern);
      },
      child: Text(label),
    );
  }
}

class _VibrationItem {
  final String title;
  final String patternVisual;
  final String description;
  final List<int> pattern; // Used when not dynamic
  final bool isDynamic;
  final List<int> Function(double distance)? dynamicBuilder;

  _VibrationItem({
    required this.title,
    required this.patternVisual,
    required this.description,
    required this.pattern,
  }) : isDynamic = false,
       dynamicBuilder = null;

  _VibrationItem.dynamic({
    required this.title,
    required this.patternVisual,
    required this.description,
    required this.dynamicBuilder,
  }) : isDynamic = true,
       pattern = const [];
}
