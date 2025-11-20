import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../config/seoul_api_key.dart';
import '../models/bus_info.dart';

class SeoulBusApi {
  static const String _base = 'http://ws.bus.go.kr/api/rest';

  bool get isConfigured => seoulApiKey.isNotEmpty;

  Future<String?> _getArsIdByStationName(String name) async {
    final uri = Uri.parse(
      '$_base/stationinfo/getStationByName?serviceKey=$seoulApiKey&stSrch=${Uri.encodeComponent(name)}',
    );
    final resp = await http.get(uri);
    if (resp.statusCode != 200) return null;

    final doc = xml.XmlDocument.parse(utf8.decode(resp.bodyBytes));
    final nodes = doc.findAllElements('station');
    if (nodes.isEmpty) return null;
    // Prefer exact match if exists
    final exact = nodes.firstWhere(
      (n) => n.getElement('stNm')?.text == name,
      orElse: () => nodes.first,
    );
    return exact.getElement('arsId')?.text;
  }

  Future<List<BusArrival>> getArrivalsByStationName(String stationName) async {
    if (!isConfigured) return [];
    try {
      final arsId = await _getArsIdByStationName(stationName);
      if (arsId == null) return [];

      final uri = Uri.parse(
        '$_base/stationinfo/getStationByUid?serviceKey=$seoulApiKey&arsId=$arsId',
      );
      final resp = await http.get(uri);
      if (resp.statusCode != 200) return [];

      final doc = xml.XmlDocument.parse(utf8.decode(resp.bodyBytes));
      final items = doc.findAllElements('itemList');

      final List<BusArrival> result = [];
      for (final item in items) {
        final number =
            item.getElement('rtNm')?.text ??
            item.getElement('busRouteAbrv')?.text ??
            item.getElement('busRouteNm')?.text ??
            '알수없음';
        final routeName = item.getElement('busRouteNm')?.text ?? number;
        final arrmsg = item.getElement('arrmsg1')?.text ?? '';
        final msg2 = item.getElement('arrmsg2')?.text ?? '';

        final parsed = _parseArrivalMessage(arrmsg);
        final arrivalMinutes = parsed.$1;
        final status = parsed.$2;
        final remainingStops =
            _parseRemainingStops(arrmsg) ?? _parseRemainingStops(msg2) ?? 0;

        result.add(
          BusArrival(
            busNumber: number,
            routeName: routeName,
            arrivalMinutes: arrivalMinutes,
            remainingStops: remainingStops,
            status: status,
            isLowFloorBus: false,
          ),
        );
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  (int, String) _parseArrivalMessage(String msg) {
    final m = RegExp(r'([0-9]+)분').firstMatch(msg);
    if (msg.contains('도착') && msg.contains('정류소')) {
      return (0, 'stopped');
    }
    if (msg.contains('곧')) {
      return (0, 'arriving');
    }
    if (m != null) {
      final minutes = int.tryParse(m.group(1)!) ?? 0;
      return (minutes, minutes <= 1 ? 'arriving' : 'approaching');
    }
    return (5, 'approaching');
  }

  int? _parseRemainingStops(String msg) {
    final s = RegExp(r'([0-9]+)정거장').firstMatch(msg);
    if (s != null) return int.tryParse(s.group(1)!);
    return null;
  }
}
