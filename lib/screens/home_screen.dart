import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cane_provider.dart';
import 'vibration_pattern_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int)? onNavigateToTab;
  const HomeScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Consumer<CaneProvider>(
      builder: (context, caneProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 지팡이 연결 상태 카드
              _buildConnectionCard(context, caneProvider),
              const SizedBox(height: 16),

              // 빠른 액션
              const Text(
                '빠른 액션',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // 상태/알림
              const Text(
                '상태 및 알림',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildBatteryCard(context, caneProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionCard(BuildContext context, CaneProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 왼쪽: 지팡이 아이콘 + 상태
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.accessibility_new,
                    size: 40,
                    color: provider.isConnected ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.isConnected ? '연결됨' : '연결 안 됨',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: provider.isConnected
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      if (provider.lastUpdate != null)
                        Text(
                          '마지막 업데이트: ${DateFormat('HH:mm').format(provider.lastUpdate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // 오른쪽: 버튼들
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    provider.refreshConnection();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('연결 상태 새로고침')));
                  },
                  tooltip: '새로고침',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.location_on,
                label: '지팡이 위치 보기',
                color: Colors.blue,
                onTap: () {
                  if (onNavigateToTab != null) {
                    onNavigateToTab!(1); // 위치 탭
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.directions_bus,
                label: '버스 정보',
                color: Colors.green,
                onTap: () {
                  if (onNavigateToTab != null) {
                    onNavigateToTab!(2); // 버스 탭
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _buildActionButton(
            context,
            icon: Icons.vibration,
            label: '진동 패턴 학습',
            color: Colors.purple,
            onTap: () {
              final callback = onNavigateToTab ?? (_) {};
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VibrationPatternScreen(
                    onNavigateToTab: callback,
                    activeTabIndex: 0,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryCard(BuildContext context, CaneProvider provider) {
    Color batteryColor;
    if (provider.batteryLevel > 50) {
      batteryColor = Colors.green;
    } else if (provider.batteryLevel > 20) {
      batteryColor = Colors.orange;
    } else {
      batteryColor = Colors.red;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              provider.batteryLevel > 20
                  ? Icons.battery_std
                  : Icons.battery_alert,
              color: batteryColor,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '지팡이 배터리',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${provider.batteryLevel}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: batteryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                value: provider.batteryLevel / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(batteryColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
