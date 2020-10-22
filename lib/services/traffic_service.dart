import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/models/driving_response.dart';

class TraffitService {
  // singleton
  TraffitService._privateConstructor();
  static final TraffitService _instance = TraffitService._privateConstructor();
  factory TraffitService() {
    return _instance;
  }

  final _dio = new Dio();
  final _baseUrl = 'https://api.mapbox.com/directions/v5';
  final _apiKey =
      'pk.eyJ1IjoiY2FybGlubnNrOCIsImEiOiJja2dpM241eDEwMnYzMzJwaXluZmk3YWRhIn0.fB-LPJiIRbLw08yIUEL1sg';
  Future<DrivingResponse> getCoordsInicioFin(
      LatLng inicio, LatLng destino) async {
    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this._baseUrl}/mapbox/driving/$coordString';

    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es',
    });

    final data = DrivingResponse.fromJson(resp.data);

    return data;
  }
}
