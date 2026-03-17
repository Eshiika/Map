import 'package:frontend/api_service.dart';
import 'package:frontend/models/city.dart';

class CityRepository {
  final ApiService api;

  CityRepository(this.api);

  Future<List<String>> getRegions() async {
    final response = await api.get("/cities/region");
    return List<String>.from(response["data"]);
  }

  Future<List<City>> getCities({
    String? region,
    int? nbVille,
    int? habitantMin,
    double? latitude,
    double? longitude,
    double? rayon,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (region != null && region.isNotEmpty) {
      queryParameters["region"] = region;
    }
    if (nbVille != null && nbVille > 0) {
      queryParameters["nbVille"] = nbVille;
    }
    if (habitantMin != null && habitantMin >= 0) {
      queryParameters["habitantMin"] = habitantMin;
    }
    if (latitude != null) {
      queryParameters["latitude"] = latitude;
    }
    if (longitude != null) {
      queryParameters["longitude"] = longitude;
    }
    if (rayon != null && rayon > 0) {
      queryParameters["rayon"] = rayon;
    }

    final response = await api.get(
      "/cities",
      queryParameters: queryParameters,
    );

    final List<dynamic> data = response["data"];

    return data
        .map((json) => City.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}