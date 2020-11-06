part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return FadeInDown(
            duration: Duration(milliseconds: 400),
            child: buildSearchBar(context),
          );
        }
      },
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: width,
        child: GestureDetector(
          onTap: () async {
            final proximidad = context.bloc<MiUbicacionBloc>().state.ubicacion;
            final history = context.bloc<BusquedaBloc>().state.history;
            final resultado = await showSearch(
              context: context,
              delegate: SearchDestination(proximidad, history),
            );
            this.retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            width: double.infinity,
            child: Text(
              '¿Donde quieres ir?',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(100),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future retornoBusqueda(BuildContext context, SearchResult result) async {
    if (result.cancelo) return;

    if (result.manual) {
      context.bloc<BusquedaBloc>().add(OnAtivarMarcadorManual());
      return;
    }
    calculandoAlerta(context);
    //Calcular ruta valor recibido
    final trafficService = TraffitService();
    final mapaBloc = context.bloc<MapaBloc>();

    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;
    final drivingTraffit =
        await trafficService.getCoordsInicioFin(inicio, destino);

    final geometry = drivingTraffit.routes[0].geometry;
    final duration = drivingTraffit.routes[0].duration;
    final distance = drivingTraffit.routes[0].distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map(
          (point) => LatLng(point[0], point[1]),
        )
        .toList();
    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoordenadas, distance, duration, nombreDestino));
    Navigator.of(context).pop();
    // add  history
    final busquedaBloc = context.bloc<BusquedaBloc>();
    busquedaBloc.add(OnAddHistory(result));
  }
}
