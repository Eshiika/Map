import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/viewmodels/map_view_model.dart';
import 'package:frontend/widgets/habitant_min_field.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();

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
                      onTap: (tapPosition, point) async {
                        vm.setSelectedPoint(point);
                        await vm.loadCities();
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
                          ...vm.cities.map((city) {
                            return Marker(
                              point: LatLng(city.latitude, city.longitude),
                              width: 180,
                              height: 80,
                              child: MouseRegion(
                                onEnter: (_) => vm.setHoveredCity(city),
                                onExit: (_) => vm.clearHoveredCity(city),
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    if (vm.isHoveredCity(city))
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
                                            '[${vm.getDistanceInKm(city)
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
                                      color: vm.isHoveredCity(city)
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                          if (vm.selectedPoint != null)
                            Marker(
                              point: LatLng(vm.selectedPoint!.latitude,
                                  vm.selectedPoint!.longitude),
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: vm.clearSelectedPoint,
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
                          value: vm.nbCity,
                          min: 10,
                          max: 2018,
                          divisions: 99,
                          activeColor: Colors.blue,
                          label: vm.nbCity.toInt().toString(),
                          onChanged: (value) async {
                            vm.setNbCity(value);
                            await vm.loadCities();
                          }
                      ),
                      ListTile(
                        title: Text("Rayon de recherche (en km)"),
                      ),
                      Slider(
                          value: vm.rayon,
                          min: 10,
                          max: 300,
                          divisions: 99,
                          activeColor: Colors.blue,
                          label: vm.rayon.toInt().toString(),
                          onChanged: (value) async {
                            vm.setRayon(value);
                            await vm.loadCities();
                          }
                      ),
                      ListTile(title: Text("Région")),
                      DropdownButtonFormField<String?>(
                        initialValue: vm.selectedRegion,
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
                          ...vm.regions.map((region) {
                            return DropdownMenuItem<String?>(
                              value: region,
                              child: Text(region),
                            );
                          }),
                        ],
                        onChanged: (value) async {
                          vm.setSelectedRegion(value);
                          await vm.loadCities();
                        },
                      ),
                      ListTile(title: Text("Habitant minimum")),
                      const HabitantMinField(),
                      const SizedBox(height: 10),
                      if (vm.cities.isNotEmpty)
                        Text(
                          "Villes trouvées ${vm.cities.length}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemCount: vm.cities.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final city = vm.cities[index];
                          return MouseRegion(
                            onEnter: (_) => vm.setHoveredCity(city),
                            onExit: (_) => vm.clearHoveredCity(city),
                            child: Card(
                              color: vm.isHoveredCity(city)
                                  ? Colors.blue.shade100
                                  : null,
                              child: ListTile(
                                title: Text(
                                    '[${vm.getDistanceInKm(city).toStringAsFixed(
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