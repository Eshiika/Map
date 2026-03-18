import 'package:flutter/material.dart';
import 'package:frontend/data/datasources/api_service.dart';
import 'package:frontend/screens/map_screen.dart';
import 'package:frontend/data/repository/city_repository.dart';
import 'package:frontend/viewmodels/map_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  final apiservice = ApiService();
  final cityRepository = CityRepository(apiservice);
  runApp(
    ChangeNotifierProvider(
      create: (_) => MapViewModel(cityRepository)..loadRegions(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterMap',
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}