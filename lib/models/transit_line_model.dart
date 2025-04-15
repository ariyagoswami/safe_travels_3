class TransitLineModel {
  final String name;
  final String lineId;
  final List<String> stations;

  const TransitLineModel({
    required this.name,
    required this.lineId,
    required this.stations,
  });

  // Check if this line connects two stations
  bool connectsStations(String startStation, String endStation) {
    final startIndex = stations.indexOf(startStation);
    final endIndex = stations.indexOf(endStation);
    
    // Both stations must be on this line
    if (startIndex == -1 || endIndex == -1) {
      return false;
    }
    
    // Stations can be in any order (allows for travel in either direction)
    return true;
  }
  
  // Get the direction of travel (useful for display)
  String getDirection(String startStation, String endStation) {
    final startIndex = stations.indexOf(startStation);
    final endIndex = stations.indexOf(endStation);
    
    if (startIndex == -1 || endIndex == -1) {
      return "Unknown";
    }
    
    // If endIndex > startIndex, we're going "outbound" (away from center city)
    // If startIndex > endIndex, we're going "inbound" (toward center city)
    return endIndex > startIndex ? "Outbound" : "Inbound";
  }
}