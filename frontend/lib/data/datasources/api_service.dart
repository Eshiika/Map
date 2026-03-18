import 'package:dio/dio.dart';

class ApiService {

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api',
  ));

  Future<Map<String, dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception('Erreur GET $path : ${e.message}');
    }
  }
}