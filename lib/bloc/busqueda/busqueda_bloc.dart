import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:meta/meta.dart';

part 'busqueda_event.dart';
part 'busqueda_state.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  BusquedaBloc() : super(BusquedaState());

  @override
  Stream<BusquedaState> mapEventToState(BusquedaEvent event) async* {
    if (event is OnAtivarMarcadorManual) {
      yield state.copyWtih(seleccionManual: true);
    } else if (event is OnDesactivarMarcadorMAnual) {
      yield state.copyWtih(seleccionManual: false);
    } else if (event is OnAddHistory) {
      final existe = state.history
          .where(
            (result) => result.nombreDestino == event.result.nombreDestino,
          )
          .length;

      if (existe == 0) {
        final newHistory = [...state.history, event.result];
        yield state.copyWtih(history: newHistory);
      }
    }
  }
}
