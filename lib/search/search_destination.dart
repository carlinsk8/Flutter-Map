import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_app/models/search_response.dart';

import 'package:mapa_app/models/search_result.dart';
import 'package:mapa_app/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TraffitService _traffitService;
  final LatLng _proximidad;
  final List<SearchResult> history;

  SearchDestination(this._proximidad, this.history)
      : this.searchFieldLabel = 'Buscar...',
        this._traffitService = new TraffitService();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => this.close(context, SearchResult(cancelo: true)),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultadosSugerencia();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicacion manual'),
            onTap: () {
              this.close(context, SearchResult(cancelo: false, manual: true));
            },
          ),
          ...this
              .history
              .map(
                (result) => ListTile(
                  leading: Icon(Icons.history),
                  title: Text(result.nombreDestino),
                  subtitle: Text(result.description),
                  onTap: () {
                    this.close(context, result);
                  },
                ),
              )
              .toList()
        ],
      );
    }
    return _construirResultadosSugerencia();
  }

  Widget _construirResultadosSugerencia() {
    this
        ._traffitService
        .getSugerenciasPorQuery(this.query.trim(), this._proximidad);
    //(this.query.trim(), this._proximidad)
    return StreamBuilder(
      stream: this._traffitService.sugerenciasStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final lugares = snapshot.data.features;
        if (lugares.length == 0) {
          return ListTile(
            title: Text('No hay recultados con $query'),
          );
        }
        return ListView.separated(
            itemCount: lugares.length,
            separatorBuilder: (_, i) => Divider(),
            itemBuilder: (_, i) {
              final lugar = lugares[i];
              return ListTile(
                leading: Icon(Icons.place),
                title: Text(lugar.textEs),
                subtitle: Text(lugar.placeNameEs),
                onTap: () {
                  this.close(
                    context,
                    SearchResult(
                      cancelo: false,
                      manual: false,
                      position: LatLng(lugar.center[1], lugar.center[0]),
                      nombreDestino: lugar.textEs,
                      description: lugar.placeNameEs,
                    ),
                  );
                },
              );
            });
      },
    );
  }
}
