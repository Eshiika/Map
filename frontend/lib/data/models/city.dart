class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int population;
  final String region;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.population,
    required this.region,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      population: json['population'],
      region: json['region'],
    );
  }
}