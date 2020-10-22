part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return _BuildMArcadorManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMArcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        //BOton regresar
        Positioned(
          top: 35,
          left: 30,
          child: FadeInLeft(
            duration: Duration(milliseconds: 400),
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  context
                      .bloc<BusquedaBloc>()
                      .add(OnDesactivarMarcadorMAnual());
                },
              ),
            ),
          ),
        ),
        Center(
          child: Transform.translate(
            offset: Offset(0, -13),
            child: BounceInDown(
              from: 200,
              child: Icon(
                Icons.location_on,
                size: 50,
              ),
            ),
          ),
        ),

        //Boton confirmar destino
        Positioned(
          bottom: 70,
          left: 40,
          child: FadeIn(
            child: MaterialButton(
              minWidth: width - 120,
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              child: Text(
                'Confirmar destino',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                this.calcularDestino(context);
              },
            ),
          ),
        )
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficService = TraffitService();
    final mapaBloc = context.bloc<MapaBloc>();

    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;

    final trafficResponse =
        await trafficService.getCoordsInicioFin(inicio, destino);

    final geometry = trafficResponse.routes[0].geometry;
    final duration = trafficResponse.routes[0].duration;
    final distance = trafficResponse.routes[0].distance;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> rutaCoords = points
        .map(
          (point) => LatLng(point[0], point[1]),
        )
        .toList();

    mapaBloc.add(OnCrearRutaInicioDestino(rutaCoords, distance, duration));
    Navigator.of(context).pop();
    context.bloc<BusquedaBloc>().add(OnDesactivarMarcadorMAnual());
  }
}
