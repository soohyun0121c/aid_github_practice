class BusArrival {
  final String busNumber;
  final String routeName;
  final int arrivalMinutes;
  final int remainingStops;
  final String status; // 'approaching', 'arriving', 'stopped'
  final bool isLowFloorBus; // 저상버스 여부

  BusArrival({
    required this.busNumber,
    required this.routeName,
    required this.arrivalMinutes,
    required this.remainingStops,
    required this.status,
    this.isLowFloorBus = false,
  });

  String get statusText {
    switch (status) {
      case 'stopped':
        return '정차 중';
      case 'arriving':
        return '곧 도착';
      case 'approaching':
        return '${arrivalMinutes}분 후 도착';
      default:
        return '운행 중';
    }
  }
}

class BusStation {
  final String stationId;
  final String stationName;
  final double latitude;
  final double longitude;

  BusStation({
    required this.stationId,
    required this.stationName,
    required this.latitude,
    required this.longitude,
  });
}
