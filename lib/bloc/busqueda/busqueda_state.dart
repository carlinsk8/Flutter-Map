part of 'busqueda_bloc.dart';

@immutable
class BusquedaState {
  final bool seleccionManual;
  final List<SearchResult> history;

  BusquedaState({
    this.seleccionManual = false,
    List<SearchResult> history,
  }) : this.history = history == null ? [] : history;

  copyWtih({
    bool seleccionManual,
    List<SearchResult> history,
  }) =>
      BusquedaState(
        seleccionManual: seleccionManual ?? this.seleccionManual,
        history: history ?? this.history,
      );
}
