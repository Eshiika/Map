import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/map_screen.dart';
import 'package:frontend/repository/city_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterMap',
      debugShowCheckedModeBanner: false,
      home: MapScreen(cityRepository: CityRepository(ApiService()),),
    );
  }
}