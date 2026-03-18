import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../data/models/city.dart';
import '../data/repository/city_repository.dart';

class MapViewModel extends ChangeNotifier {
  final CityRepository cityRepository;

  MapViewModel(this.cityRepository);

  LatLng? selectedPoint;
  double nbCity = 10;
  double rayon = 10;
  String? selectedRegion;
  int? habitantMin;

  List<String> regions = [];
  List<City> cities = [];
  City? hoveredCity;

  final Distance distanceCalculator = const Distance();

  Future<void> loadRegions() async {
    try {
      regions = await cityRepository.getRegions();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur loadRegions: $e');
    }
  }

  Future<void> loadCities() async {
    try {
      if (selectedPoint == null) return;

      cities = await cityRepository.getCities(
        region: selectedRegion,
        nbVille: nbCity.toInt(),
        habitantMin: habitantMin,
        latitude: selectedPoint!.latitude,
        longitude: selectedPoint!.longitude,
        rayon: rayon * 1000,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur loadCities: $e');
    }
  }

  void setSelectedPoint(LatLng point) {
    selectedPoint = point;
    notifyListeners();
  }

  void clearSelectedPoint() {
    selectedPoint = null;
    cities = [];
    notifyListeners();
  }

  void setNbCity(double value) {
    nbCity = value;
    notifyListeners();
  }

  void setRayon(double value) {
    rayon = value;
    notifyListeners();
  }

  void setSelectedRegion(String? value) {
    selectedRegion = value;
    notifyListeners();
  }

  void setHoveredCity(City city) {
    hoveredCity = city;
    notifyListeners();
  }

  void setHabitantMin(String value) {
    final parsedValue = int.tryParse(value.trim());
    habitantMin = parsedValue;
    notifyListeners();
  }

  void clearHabitantMin() {
    habitantMin = null;
    notifyListeners();
  }

  void clearHoveredCity(City city) {
    if (hoveredCity?.id == city.id) {
      hoveredCity = null;
      notifyListeners();
    }
  }

  double getDistanceInKm(City city) {
    if (selectedPoint == null) return 0;

    final meters = distanceCalculator.as(
      LengthUnit.Meter,
      selectedPoint!,
      LatLng(city.latitude, city.longitude),
    );

    return meters / 1000;
  }

  bool isHoveredCity(City city) {
    return hoveredCity != null && hoveredCity!.id == city.id;
  }
}