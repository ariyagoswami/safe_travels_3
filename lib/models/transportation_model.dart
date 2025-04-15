class TransportationModel {
  final String id;
  final String name;
  final String type;
  final String? iconPath;

  const TransportationModel({
    required this.id,
    required this.name,
    required this.type,
    this.iconPath,
  });

  factory TransportationModel.fromJson(Map<String, dynamic> json) {
    return TransportationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      iconPath: json['iconPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'iconPath': iconPath,
    };
  }
}

// Mock data for transportation options
final List<TransportationModel> mockTransportationOptions = [
  const TransportationModel(
    id: '1',
    name: 'Regional Rail',
    type: 'train',
  ),
  const TransportationModel(
    id: '2',
    name: 'Bus',
    type: 'bus',
  ),
  const TransportationModel(
    id: '3',
    name: 'Subway',
    type: 'subway',
  ),
  const TransportationModel(
    id: '4',
    name: 'Trolley',
    type: 'trolley',
  ),
];
