class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String region;
  final int population;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.population,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      region: json['region'],
      population: json['population'],
    );
  }
}