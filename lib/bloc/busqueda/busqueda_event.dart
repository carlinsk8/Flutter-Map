part of 'busqueda_bloc.dart';

@immutable
abstract class BusquedaEvent {}

class OnAtivarMarcadorManual extends BusquedaEvent {}

class OnDesactivarMarcadorMAnual extends BusquedaEvent {}
