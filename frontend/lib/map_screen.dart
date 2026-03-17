import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/models/city.dart';
import 'package:frontend/repository/city_repository.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final CityRepository cityRepository;
  const MapScreen({super.key, required this.cityRepository});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedPoint;
  double nbCity = 10.0;
  double rayon = 10.0;
  String? selectedRegion;
  final TextEditingController habitantMinController = TextEditingController();
  List<String> regions = [];
  List<City> cities = [];
  final Distance distanceCalculator = const Distance();
  int count = 0;
  City? hoveredCity;

  @override
  void initState() {
    super.initState();
    loadRegions();
  }

  @override
  void dispose() {
    habitantMinController.dispose();
    super.dispose();
  }

  Future<void> loadRegions() async {
    try {
      final List<String> result = await widget.cityRepository.getRegions();
      setState(() {
        regions = result;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadCities() async {
    try {
      if (selectedPoint == null) return;

      final result = await widget.cityRepository.getCities(
        region: selectedRegion,
        nbVille: nbCity.toInt(),
        habitantMin: int.tryParse(habitantMinController.text),
        latitude: selectedPoint!.latitude,
        longitude: selectedPoint!.longitude,
        rayon: rayon * 1000,
      );

      setState(() {
        cities = result;
      });
    } catch (e) {
      print('Erreur loadCities : $e');
    }
    count = cities.length;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterMap", style: TextStyle(color: Colors.blue)),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 1200;
          final bool isMedium = constraints.maxWidth > 900;

          final int mapFlex = isWide ? 2 : (isMedium ? 3 : 2);
          final int sideFlex = isWide ? 1 : (isMedium ? 2 : 3);

          return Row(
            children: [
              Expanded(
                flex: mapFlex,
                child: FlutterMap(
                  options: MapOptions(
                      initialCenter: const LatLng(47, 2),
                      initialZoom: 6,
                      minZoom: 3,
                      maxZoom: 15,
                      onTap: (tapPosition, point) {
                        setState(() {
                          selectedPoint = point;
                        });
                        loadCities();
                      }
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: "com.example.frontend",
                    ),
                    // Attribution OSM obligatoire
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        color: Colors.white70,
                        child: const Text(
                          '© OpenStreetMap contributors',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    MarkerLayer(
                        markers: [
                          ...cities.map((city) {
                            return Marker(
                              point: LatLng(city.latitude, city.longitude),
                              width: 180,
                              height: 80,
                              child: MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    hoveredCity = city;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    if (hoveredCity?.id == city.id) {
                                      hoveredCity = null;
                                    }
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    if (isHoveredCity(city))
                                      Positioned(
                                        bottom: 80,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            '[${getDistanceInKm(city)
                                                .toStringAsFixed(1)} km] ${city
                                                .name} / ${city
                                                .population} hab. / ${city
                                                .region}',
                                            style: const TextStyle(
                                                fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    Icon(
                                      Icons.location_pin,
                                      size: 40,
                                      color: isHoveredCity(city)
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          if (selectedPoint != null)
                            Marker(
                              point: LatLng(selectedPoint!.latitude,
                                  selectedPoint!.longitude),
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPoint = null;
                                  });
                                },
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 60,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ]
                    )
                  ],
                ),
              ),
              Expanded(
                flex: sideFlex,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Paramètres",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text("Nombre de villes"),
                      ),
                      Slider(
                          value: nbCity,
                          min: 10,
                          max: 2018,
                          divisions: 99,
                          activeColor: Colors.blue,
                          label: nbCity.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              nbCity = value;
                            });
                            loadCities();
                          }
                      ),
                      ListTile(
                        title: Text("Rayon de recherche (en km)"),
                      ),
                      Slider(
                          value: rayon,
                          min: 10,
                          max: 300,
                          divisions: 99,
                          activeColor: Colors.blue,
                          label: rayon.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              rayon = value;
                            });
                            loadCities();
                          }
                      ),
                      ListTile(title: Text("Région")),
                      DropdownButtonFormField<String?>(
                        initialValue: selectedRegion,
                        decoration: InputDecoration(
                          labelText: 'Région',
                          labelStyle: TextStyle(color: Colors.blue),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Toutes les régions'),
                          ),
                          ...regions.map((region) {
                            return DropdownMenuItem<String?>(
                              value: region,
                              child: Text(region),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRegion = value;
                          });
                          loadCities();
                        },
                      ),
                      ListTile(title: Text("Habitant minimum")),
                      TextField(
                        controller: habitantMinController,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Ex: 5000",
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: loadCities,
                              icon: Icon(Icons.search),
                            )
                        ),
                        onSubmitted: (value) {
                          loadCities();
                        },
                      ),
                      const SizedBox(height: 10),
                      if (cities.isNotEmpty)
                        Text(
                          "Villes trouvées $count",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemCount: cities.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final city = cities[index];
                          return MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                hoveredCity = city;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                if (hoveredCity?.id == city.id) {
                                  hoveredCity = null;
                                }
                              });
                            },
                            child: Card(
                              color: isHoveredCity(city)
                                  ? Colors.blue.shade100
                                  : null,
                              child: ListTile(
                                title: Text(
                                    '[${getDistanceInKm(city).toStringAsFixed(
                                        1)} km] ${city.name}'),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        })
    );
  }
}