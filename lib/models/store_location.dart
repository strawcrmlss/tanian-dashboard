class StoreLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  StoreLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory StoreLocation.fromJson(Map<String, dynamic> json) {
    return StoreLocation(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
