import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  // final _geolocator = Geolocato
  StreamSubscription<Geolocator.Position> _positionSubcription;

  void iniciarSeguimiento() {
    _positionSubcription = Geolocator.getPositionStream(
      desiredAccuracy: Geolocator.LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((Geolocator.Position position) {
      final nuevaPosicion = new LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio(nuevaPosicion));
    });
  }

  void cancelarSeguimiento() {
    _positionSubcription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(MiUbicacionEvent event) async* {
    if (event is OnUbicacionCambio) {
      print(event);
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion,
      );
    }
  }
}
