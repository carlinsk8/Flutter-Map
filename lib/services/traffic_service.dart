import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/helpers/debouncer.dart';
import 'package:mapa_app/models/driving_response.dart';
import 'package:mapa_app/models/reverse_query_response.dart';
import 'package:mapa_app/models/search_response.dart';

class TraffitService {
  // singleton
  TraffitService._privateConstructor();
  static final TraffitService _instance = TraffitService._privateConstructor();
  factory TraffitService() {
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));
  final StreamController<SearchResponse> _sugerenciasStreamController =
      new StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get sugerenciasStream =>
      _sugerenciasStreamController.stream;

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5';
  final _apiKey =
      'pk.eyJ1IjoiY2FybGlubnNrOCIsImEiOiJja2dpM241eDEwMnYzMzJwaXluZmk3YWRhIn0.fB-LPJiIRbLw08yIUEL1sg';
  Future<DrivingResponse> getCoordsInicioFin(
      LatLng inicio, LatLng destino) async {
    final coordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this._baseUrlDir}/mapbox/driving/$coordString';

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

  Future<SearchResponse> getResultadoPorQuery(
      String busqueda, LatLng proximidad) async {
    final url = '${this._baseUrlGeo}/mapbox.places/$busqueda.json';
    try {
      final resp = await this._dio.get(url, queryParameters: {
        'access_token': this._apiKey,
        'autocomplete': 'true',
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es',
      });
      final searchResponse = searchResponseFromJson(resp.data);
      return searchResponse;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultadoPorQuery(value, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<ReverseQueryResponse> getCoordenadasInfo(LatLng destinoCorrs) async {
    final url =
        '${this._baseUrlGeo}/mapbox.places/${destinoCorrs.longitude},${destinoCorrs.latitude}.json';

    final resp = await this._dio.get(url, queryParameters: {
      'access_token': this._apiKey,
      'language': 'es',
    });

    final data = reverseQueryResponseFromJson(resp.data);

    return data;
  }
}
