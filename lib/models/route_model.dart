class RouteModel {
  final String id;
  final String name;
  final String startStationId;
  final String endStationId;
  final String transportationType;
  final double averagePunctualityRating;
  final double averageSafetyRating;
  final double averageCleanlinessRating;
  final double averageOverallRating;

  const RouteModel({
    required this.id,
    required this.name,
    required this.startStationId,
    required this.endStationId,
    required this.transportationType,
    required this.averagePunctualityRating,
    required this.averageSafetyRating,
    required this.averageCleanlinessRating,
    required this.averageOverallRating,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startStationId: json['startStationId'] as String,
      endStationId: json['endStationId'] as String,
      transportationType: json['transportationType'] as String,
      averagePunctualityRating: (json['averagePunctualityRating'] as num).toDouble(),
      averageSafetyRating: (json['averageSafetyRating'] as num).toDouble(),
      averageCleanlinessRating: (json['averageCleanlinessRating'] as num).toDouble(),
      averageOverallRating: (json['averageOverallRating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startStationId': startStationId,
      'endStationId': endStationId,
      'transportationType': transportationType,
      'averagePunctualityRating': averagePunctualityRating,
      'averageSafetyRating': averageSafetyRating,
      'averageCleanlinessRating': averageCleanlinessRating,
      'averageOverallRating': averageOverallRating,
    };
  }
}

// Mock data for routes
final List<RouteModel> mockRoutes = [
  // Regional Rail Routes
  const RouteModel(
    id: 'rr1',
    name: 'Line 1',
    startStationId: '1', // Jefferson Station
    endStationId: '4',   // St. Martins
    transportationType: 'Regional Rail',
    averagePunctualityRating: 4.0,
    averageSafetyRating: 4.5,
    averageCleanlinessRating: 4.3,
    averageOverallRating: 4.3,
  ),
  const RouteModel(
    id: 'rr2',
    name: 'Line 2',
    startStationId: '2', // Suburban Station
    endStationId: '5',   // Highland
    transportationType: 'Regional Rail',
    averagePunctualityRating: 3.5,
    averageSafetyRating: 4.0,
    averageCleanlinessRating: 4.5,
    averageOverallRating: 4.0,
  ),
  const RouteModel(
    id: 'rr3',
    name: 'Line 3',
    startStationId: '3', // 30th Street Station
    endStationId: '6',   // Chestnut Hill West
    transportationType: 'Regional Rail',
    averagePunctualityRating: 4.2,
    averageSafetyRating: 4.3,
    averageCleanlinessRating: 4.0,
    averageOverallRating: 4.2,
  ),
  const RouteModel(
    id: 'rr4',
    name: 'Line 4',
    startStationId: '1', // Jefferson Station
    endStationId: '5',   // Highland
    transportationType: 'Regional Rail',
    averagePunctualityRating: 3.8,
    averageSafetyRating: 4.2,
    averageCleanlinessRating: 4.1,
    averageOverallRating: 4.0,
  ),
  const RouteModel(
    id: 'rr5',
    name: 'Line 5',
    startStationId: '2', // Suburban Station
    endStationId: '6',   // Chestnut Hill West
    transportationType: 'Regional Rail',
    averagePunctualityRating: 4.1,
    averageSafetyRating: 4.4,
    averageCleanlinessRating: 4.2,
    averageOverallRating: 4.2,
  ),
  
  // Bus Routes
  const RouteModel(
    id: 'bus1',
    name: 'Line 6',
    startStationId: '101', // Frankford Transportation Center
    endStationId: '201',   // 69th Street Transportation Center
    transportationType: 'Bus',
    averagePunctualityRating: 3.2,
    averageSafetyRating: 3.8,
    averageCleanlinessRating: 3.5,
    averageOverallRating: 3.5,
  ),
  const RouteModel(
    id: 'bus2',
    name: 'Line 7',
    startStationId: '102', // Olney Transportation Center
    endStationId: '202',   // Wissahickon Transportation Center
    transportationType: 'Bus',
    averagePunctualityRating: 3.0,
    averageSafetyRating: 3.5,
    averageCleanlinessRating: 3.2,
    averageOverallRating: 3.2,
  ),
  const RouteModel(
    id: 'bus3',
    name: 'Line 8',
    startStationId: '103', // Broad & Cecil B. Moore
    endStationId: '203',   // Broad & Oregon
    transportationType: 'Bus',
    averagePunctualityRating: 2.8,
    averageSafetyRating: 3.3,
    averageCleanlinessRating: 3.0,
    averageOverallRating: 3.0,
  ),
  const RouteModel(
    id: 'bus4',
    name: 'Line 9',
    startStationId: '104', // Broad & Erie
    endStationId: '204',   // Cheltenham & Ogontz
    transportationType: 'Bus',
    averagePunctualityRating: 3.1,
    averageSafetyRating: 3.6,
    averageCleanlinessRating: 3.3,
    averageOverallRating: 3.3,
  ),
  const RouteModel(
    id: 'bus5',
    name: 'Line 10',
    startStationId: '105', // Market & 40th
    endStationId: '205',   // Frankford & Cottman
    transportationType: 'Bus',
    averagePunctualityRating: 3.3,
    averageSafetyRating: 3.7,
    averageCleanlinessRating: 3.4,
    averageOverallRating: 3.5,
  ),
  
  // Subway Routes
  const RouteModel(
    id: 'sub1',
    name: 'Line 11',
    startStationId: '301', // 15th Street Station
    endStationId: '401',   // 69th Street Station
    transportationType: 'Subway',
    averagePunctualityRating: 4.1,
    averageSafetyRating: 3.5,
    averageCleanlinessRating: 3.2,
    averageOverallRating: 3.6,
  ),
  const RouteModel(
    id: 'sub2',
    name: 'Line 12',
    startStationId: '302', // City Hall Station
    endStationId: '402',   // AT&T Station
    transportationType: 'Subway',
    averagePunctualityRating: 4.3,
    averageSafetyRating: 3.6,
    averageCleanlinessRating: 3.3,
    averageOverallRating: 3.7,
  ),
  const RouteModel(
    id: 'sub3',
    name: 'Line 13',
    startStationId: '303', // Fern Rock Transportation Center
    endStationId: '403',   // Walnut-Locust Station
    transportationType: 'Subway',
    averagePunctualityRating: 4.5,
    averageSafetyRating: 3.7,
    averageCleanlinessRating: 3.4,
    averageOverallRating: 3.9,
  ),
  const RouteModel(
    id: 'sub4',
    name: 'Line 14',
    startStationId: '304', // Frankford Transportation Center
    endStationId: '404',   // 8th Street Station
    transportationType: 'Subway',
    averagePunctualityRating: 4.2,
    averageSafetyRating: 3.4,
    averageCleanlinessRating: 3.1,
    averageOverallRating: 3.6,
  ),
  
  // Trolley Routes
  const RouteModel(
    id: 'trol1',
    name: 'Line 15',
    startStationId: '501', // 13th Street Station
    endStationId: '601',   // 63rd Street Station
    transportationType: 'Trolley',
    averagePunctualityRating: 3.7,
    averageSafetyRating: 3.9,
    averageCleanlinessRating: 3.6,
    averageOverallRating: 3.7,
  ),
  const RouteModel(
    id: 'trol2',
    name: 'Line 16',
    startStationId: '502', // 15th Street Station
    endStationId: '602',   // Darby Transportation Center
    transportationType: 'Trolley',
    averagePunctualityRating: 3.6,
    averageSafetyRating: 3.8,
    averageCleanlinessRating: 3.5,
    averageOverallRating: 3.6,
  ),
  const RouteModel(
    id: 'trol3',
    name: 'Line 17',
    startStationId: '503', // 30th Street Station
    endStationId: '603',   // Yeadon
    transportationType: 'Trolley',
    averagePunctualityRating: 3.5,
    averageSafetyRating: 3.7,
    averageCleanlinessRating: 3.4,
    averageOverallRating: 3.5,
  ),
  const RouteModel(
    id: 'trol4',
    name: 'Line 18',
    startStationId: '504', // 15th Street Station
    endStationId: '604',   // 61st Street
    transportationType: 'Trolley',
    averagePunctualityRating: 3.8,
    averageSafetyRating: 4.0,
    averageCleanlinessRating: 3.7,
    averageOverallRating: 3.8,
  ),
  const RouteModel(
    id: 'trol5',
    name: 'Line 19',
    startStationId: '505', // 15th Street Station
    endStationId: '605',   // Eastwick
    transportationType: 'Trolley',
    averagePunctualityRating: 3.9,
    averageSafetyRating: 4.1,
    averageCleanlinessRating: 3.8,
    averageOverallRating: 3.9,
  ),
];

// Helper functions
RouteModel? getRouteById(String id) {
  try {
    return mockRoutes.firstWhere((route) => route.id == id);
  } catch (e) {
    return null;
  }
}

List<RouteModel> getRoutesByTransportationType(String transportationType) {
  return mockRoutes
      .where((route) => route.transportationType == transportationType)
      .toList();
}

List<RouteModel> getRoutesByStations(String startStationId, String endStationId) {
  return mockRoutes
      .where((route) =>
          route.startStationId == startStationId &&
          route.endStationId == endStationId)
      .toList();
}
