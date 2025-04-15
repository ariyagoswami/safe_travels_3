import 'package:safe_travels_3/config/constants.dart';
import 'package:safe_travels_3/data/septa_data.dart';

class StationModel {
  final String id;
  final String name;
  final String type; // 'starting' or 'ending'
  final String transportationType; // 'Regional Rail', 'Bus', 'Subway', 'Trolley'
  final double? latitude;
  final double? longitude;

  const StationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.transportationType,
    this.latitude,
    this.longitude,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      transportationType: json['transportationType'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'transportationType': transportationType,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

// Mock data for stations
final List<StationModel> mockStations = [
  // Starting locations
  const StationModel(
    id: '1',
    name: 'Jefferson Station',
    type: 'starting',
    transportationType: 'Regional Rail',
    latitude: 39.9525,
    longitude: -75.1580,
  ),
  const StationModel(
    id: '2',
    name: 'Suburban Station',
    type: 'starting',
    transportationType: 'Regional Rail',
    latitude: 39.9539,
    longitude: -75.1677,
  ),
  const StationModel(
    id: '3',
    name: 'Gray 30th Street',
    type: 'starting',
    transportationType: 'Regional Rail',
    latitude: 39.9566,
    longitude: -75.1819,
  ),
  
  // Ending locations
  const StationModel(
    id: '4',
    name: 'St. Martins',
    type: 'ending',
    transportationType: 'Regional Rail',
    latitude: 40.0746,
    longitude: -75.2040,
  ),
  const StationModel(
    id: '5',
    name: 'Highland',
    type: 'ending',
    transportationType: 'Regional Rail',
    latitude: 40.0810,
    longitude: -75.1950,
  ),
  const StationModel(
    id: '6',
    name: 'Chestnut Hill West',
    type: 'ending',
    transportationType: 'Regional Rail',
    latitude: 40.0776,
    longitude: -75.2085,
  ),
];

// Helper functions
List<StationModel> getStationsByType(String type) {
  return mockStations.where((station) => station.type == type).toList();
}

// Updated helper functions to filter by transportation type
List<StationModel> getStartingStations({String? transportationType}) {
  // If no transportation type is specified, return all stations from constants
  if (transportationType == null) {
    return AppConstants.startingLocations.asMap().entries.map((entry) {
      return StationModel(
        id: entry.key.toString(),
        name: entry.value,
        type: 'starting',
        transportationType: 'All',
      );
    }).toList();
  }
  
  // If transportation type is Regional Rail, use SEPTA data
  if (transportationType == 'Regional Rail') {
    return allSeptaStations.asMap().entries.map((entry) {
      return StationModel(
        id: entry.key.toString(),
        name: entry.value,
        type: 'starting',
        transportationType: transportationType,
      );
    }).toList();
  }
  
  // For other transportation types, use the existing mock data
  Map<String, List<String>> transportationStations = {
    'Bus': [
      'Frankford Transportation Center', 'Olney Transportation Center', '69th Street Transportation Center',
      'Wissahickon Transportation Center', 'Norristown Transportation Center', 'Chester Transportation Center',
      'Broad & Cecil B. Moore', 'Broad & Erie', 'Broad & Oregon', 'Market & 40th', 'Market & 11th',
      'Cheltenham & Ogontz', 'Germantown & Chelten', 'Ridge & Midvale', 'Front & Olney',
      'Broad & Snyder', 'Broad & Hunting Park', 'Frankford & Cottman', 'Frankford & Arrott',
      'Bustleton & Cottman', 'Roosevelt & Cottman', 'Castor & Erie', 'Torresdale & Cottman',
      'Rhawn & Rowland', 'Oxford Valley Mall', 'Neshaminy Mall', 'Philadelphia Mills'
    ],
    'Subway': [
      '15th Street Station', '13th Street Station', '11th Street Station', '8th Street Station',
      '5th Street Station', '2nd Street Station', 'Spring Garden Station', 'Girard Station',
      'Cecil B. Moore Station', 'Erie Station', 'Allegheny Station', 'Huntingdon Station',
      '69th Street Station', 'Frankford Transportation Center', 'Fern Rock Transportation Center',
      'AT&T Station', 'Snyder Station', 'Tasker-Morris Station', 'Lombard-South Station',
      'Race-Vine Station', 'Fairmount Station', 'Susquehanna-Dauphin Station', 'North Philadelphia Station',
      'City Hall Station', 'Walnut-Locust Station', 'Ellsworth-Federal Station', 'Oregon Station',
      'Wyoming Station', 'Logan Station', 'Olney Station', 'Church Station', 'Hunting Park Station'
    ],
    'Trolley': [
      '13th Street Station', '15th Street Station', '19th Street Station', '22nd Street Station',
      '30th Street Station', '33rd Street Station', '36th Street Station', '40th Street Station',
      '46th Street Station', '52nd Street Station', '56th Street Station', '63rd Street Station',
      'Darby Transportation Center', '69th Street Transportation Center', 'Haddington', 'Overbrook',
      'Wynnefield', 'Angora', 'Elmwood', 'Eastwick', 'Mt Airy', 'Germantown', 'Chestnut Hill',
      'Girard Avenue', 'Richmond Street', 'Frankford Avenue', 'Lancaster Avenue', 'Baltimore Avenue',
      'Woodland Avenue', 'Chester Avenue', 'Media', 'Sharon Hill', 'Drexel Hill', 'Springfield'
    ]
  };
  
  // Filter stations based on transportation type
  List<String> filteredStations = transportationStations[transportationType] ?? [];
  
  // If no specific stations for this transportation type, use a subset of the constants
  if (filteredStations.isEmpty) {
    filteredStations = AppConstants.endingLocations.take(10).toList();
  }
  
  return filteredStations.asMap().entries.map((entry) {
    return StationModel(
      id: entry.key.toString(),
      name: entry.value,
      type: 'starting',
      transportationType: transportationType,
    );
  }).toList();
}

List<StationModel> getEndingStations({String? transportationType}) {
  // If no transportation type is specified, return all stations from constants
  if (transportationType == null) {
    return AppConstants.endingLocations.asMap().entries.map((entry) {
      return StationModel(
        id: (entry.key + 1000).toString(),
        name: entry.value,
        type: 'ending',
        transportationType: 'All',
      );
    }).toList();
  }
  
  // If transportation type is Regional Rail, use SEPTA data
  if (transportationType == 'Regional Rail') {
    return allSeptaStations.asMap().entries.map((entry) {
      return StationModel(
        id: (entry.key + 1000).toString(),
        name: entry.value,
        type: 'ending',
        transportationType: transportationType,
      );
    }).toList();
  }
  
  // For other transportation types, use the existing mock data
  Map<String, List<String>> transportationStations = {
    'Bus': [
      'Frankford Transportation Center', 'Olney Transportation Center', '69th Street Transportation Center',
      'Wissahickon Transportation Center', 'Norristown Transportation Center', 'Chester Transportation Center',
      'Plymouth Meeting Mall', 'King of Prussia Mall', 'Oxford Valley Mall', 'Neshaminy Mall', 'Philadelphia Mills',
      'Cheltenham Mall', 'Cedarbrook Plaza', 'Andorra Shopping Center', 'Roosevelt Mall',
      'Grant Plaza', 'Cottman & Bustleton', 'Frankford & Gregg', 'Broad & Olney',
      'Broad & Erie', 'Broad & Lehigh', 'Broad & Cecil B. Moore', 'Broad & Girard',
      'Broad & Snyder', 'Broad & Oregon', 'Front & Market', 'Front & Chestnut'
    ],
    'Subway': [
      '69th Street Station', 'Frankford Transportation Center', 'Fern Rock Transportation Center',
      'AT&T Station', 'Snyder Station', 'Tasker-Morris Station', 'Lombard-South Station',
      'Race-Vine Station', 'Fairmount Station', 'Susquehanna-Dauphin Station', 'North Philadelphia Station',
      'City Hall Station', 'Walnut-Locust Station', 'Ellsworth-Federal Station', 'Oregon Station',
      'Wyoming Station', 'Logan Station', 'Olney Station', 'Church Station', 'Hunting Park Station',
      '15th Street Station', '13th Street Station', '11th Street Station', '8th Street Station',
      '5th Street Station', '2nd Street Station', 'Spring Garden Station', 'Girard Station'
    ],
    'Trolley': [
      'Darby Transportation Center', '69th Street Transportation Center', 'Haddington', 'Overbrook',
      'Wynnefield', 'Angora', 'Elmwood', 'Eastwick', 'Mt Airy', 'Germantown', 'Chestnut Hill',
      'Girard Avenue', 'Richmond Street', 'Frankford Avenue', 'Lancaster Avenue', 'Baltimore Avenue',
      'Woodland Avenue', 'Chester Avenue', 'Media', 'Sharon Hill', 'Drexel Hill', 'Springfield',
      '13th Street Station', '15th Street Station', '19th Street Station', '22nd Street Station',
      '30th Street Station', '33rd Street Station', '36th Street Station', '40th Street Station'
    ]
  };
  
  // Filter stations based on transportation type
  List<String> filteredStations = transportationStations[transportationType] ?? [];
  
  // If no specific stations for this transportation type, use a subset of the constants
  if (filteredStations.isEmpty) {
    filteredStations = AppConstants.endingLocations.take(10).toList();
  }
  
  return filteredStations.asMap().entries.map((entry) {
    return StationModel(
      id: (entry.key + 1000).toString(),
      name: entry.value,
      type: 'ending',
      transportationType: transportationType,
    );
  }).toList();
}
