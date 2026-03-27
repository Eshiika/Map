import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/datasources/api_service.dart';
import 'package:frontend/viewmodels/map_view_model.dart';
import 'package:frontend/screens/map_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:frontend/data/models/city.dart';
import 'package:frontend/data/repository/city_repository.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend/main.dart' as app;

class FakeCityRepository extends CityRepository {
  FakeCityRepository() : super(ApiService());

  static final List<City> _allCities = [
    City(id: 1, name: 'Paris', latitude: 48.8566, longitude: 2.3522,  population: 2161000, region: 'Île-de-France'),
    City(id: 2, name: 'Lyon', latitude: 45.7640, longitude: 4.8357,  population: 513275,  region: 'Auvergne-Rhône-Alpes'),
    City(id: 3, name: 'Marseille', latitude: 43.2965, longitude: 5.3698,  population: 861635,  region: "Provence-Alpes-Côte d'Azur"),
    City(id: 4, name: 'Amiens', latitude: 49.8942, longitude: 2.2957,  population: 133448,  region: 'Hauts-de-France'),
    City(id: 5, name: 'Laon', latitude: 49.5638, longitude: 3.6236,  population: 25279,   region: 'Hauts-de-France'),
    City(id: 6, name: 'Creil', latitude: 49.2573, longitude: 2.4783,  population: 34012,   region: 'Hauts-de-France'),
    City(id: 7, name: 'Noyon', latitude: 49.5822, longitude: 3.0000,  population: 13500,   region: 'Hauts-de-France'),
    City(id: 8, name: 'Verberie', latitude: 49.3136, longitude: 2.8292,  population: 3200,    region: 'Hauts-de-France'),
  ];

  @override
  Future<List<String>> getRegions() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return ['Île-de-France', 'Auvergne-Rhône-Alpes', "Provence-Alpes-Côte d'Azur", 'Hauts-de-France'];
  }

  @override
  Future<List<City>> getCities({
    String? region,
    int? nbVille,
    int? habitantMin,
    double? latitude,
    double? longitude,
    double? rayon,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));

    return _allCities.where((city) {
      if (habitantMin != null && habitantMin > 0 && city.population < habitantMin) {
        return false;
      }
      if (region != null && region.isNotEmpty && city.region != region) {
        return false;
      }
      if (latitude != null && longitude != null && rayon != null && rayon > 0) {
        final dlat = city.latitude  - latitude;
        final dlon = city.longitude - longitude;
        final distKm = sqrt(dlat * dlat + dlon * dlon) * 111.0;
        if (distKm > rayon) return false;
      }
      return true;
    }).take(nbVille ?? _allCities.length).toList();
  }
}

Future<void> setPointAndLoad(WidgetTester tester) async {
  final context = tester.element(find.byType(MapScreen));
  final vm = context.read<MapViewModel>();
  vm.setSelectedPoint(const LatLng(47.0, 2.0));
  await vm.loadCities();
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel pathProviderChannel =
  MethodChannel('plugins.flutter.io/path_provider');

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel,
            (MethodCall methodCall) async {
          return '/tmp';
        });
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  testWidgets('Test Système', (tester) async {
    final vm = MapViewModel(FakeCityRepository());

    await tester.pumpWidget(
      ChangeNotifierProvider<MapViewModel>.value(
        value: vm,
        child: const MaterialApp(
          home: MapScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('FlutterMap'), findsOneWidget);
    expect(find.byKey(const Key('mapWidget')), findsOneWidget);
    await setPointAndLoad(tester);

    // Vérifie que le champ population existe
    final populationField = find.byKey(const Key('textFieldPopulation'));
    expect(populationField, findsOneWidget);

    // Saisie de la population
    await tester.enterText(populationField, '5000');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.textContaining('Villes trouvées'), findsOneWidget);
    expect(find.textContaining('Verberie'), findsNothing);
    expect(find.textContaining('Noyon'), findsWidgets);
    expect(find.textContaining('Amiens'), findsWidgets);
  });
}