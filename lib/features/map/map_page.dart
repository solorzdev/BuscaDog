import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Alias: usa tu VetApi existente
import '../../data/api/vet_api.dart' as data;

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // ===== Parámetros finos =====
  static const LatLng _center = LatLng(20.6736, -103.3440);
  static const int _timeoutSec = 6;

  // Límites para no matar el render
  static const int _detailMaxPins = 400; // si hay más, nos quedamos en agregado
  static const int _aggLimitLowZoom = 1200; // cap de círculos a zoom bajo
  static const int _aggLimitHighZoom = 2000;

  // Umbrales de recarga
  static const double _minZoomDelta = 0.35;
  static const double _minBoundsDeltaDeg = 0.02;

  // Zooms recomendados
  static const double _detailMinZoom = 12.5; // desde aquí intentamos detalle

  final data.VetApi _api = data.VetApi();
  final MapController _map = MapController();

  // Estado de datos
  final ValueNotifier<List<data.Vet>> _vets = ValueNotifier<List<data.Vet>>([]);

  // UI/state
  bool _mapReady = false;
  bool _loading = true;
  String? _error;

  // Control de concurrencia
  int _seq = 0;
  bool _inFlight = false; // lock duro
  Timer? _refineTimer;

  // Viewport previo
  LatLngBounds? _lastB;
  double _lastZ = 12;

  // ======= Helpers =======
  bool _viewportChangedEnough(LatLngBounds b, double z) {
    if (_lastB == null) return true;
    if ((z - _lastZ).abs() >= _minZoomDelta) return true;
    double d(double a, double bb) => (a - bb).abs();
    return d(b.south, _lastB!.south) > _minBoundsDeltaDeg ||
        d(b.north, _lastB!.north) > _minBoundsDeltaDeg ||
        d(b.west, _lastB!.west) > _minBoundsDeltaDeg ||
        d(b.east, _lastB!.east) > _minBoundsDeltaDeg;
  }

  int _precisionForZoom(double z) {
    if (z < 7) return 0;
    if (z < 9) return 1;
    if (z < 11) return 2;
    if (z < 13) return 3;
    return 4;
  }

  List<data.Vet> _sanitize(List<data.Vet> list) {
    return list
        .where((v) {
          final a = v.lat, b = v.lon;
          return a.isFinite &&
              b.isFinite &&
              a >= -90 &&
              a <= 90 &&
              b >= -180 &&
              b <= 180;
        })
        .toList(growable: false);
  }

  // ======= Fetchers (lock + descartes) =======
  Future<void> _fetchAggregated() async {
    if (!_mapReady || _inFlight) return;
    final cam = _map.camera;
    final b = cam.visibleBounds;
    final z = cam.zoom;
    if (!_viewportChangedEnough(b, z)) return;

    _inFlight = true;
    setState(() {
      _loading = true;
      _error = null;
    });
    _lastB = b;
    _lastZ = z;
    final my = ++_seq;

    final cap = z < 11 ? _aggLimitLowZoom : _aggLimitHighZoom;

    try {
      final raw = await _api
          .listAggregatedByBbox(
            s: b.south,
            w: b.west,
            n: b.north,
            e: b.east,
            precision: _precisionForZoom(z),
            limit: cap,
          )
          .timeout(const Duration(seconds: _timeoutSec));

      if (my != _seq) return;

      _vets.value = _sanitize(raw);
    } catch (e) {
      if (my != _seq) return;
      _error = '$e';
    } finally {
      if (mounted)
        setState(() {
          _loading = false;
        });
      _inFlight = false;
    }
  }

  Future<void> _fetchDetail() async {
    if (!_mapReady || _inFlight) return;
    final cam = _map.camera;
    final b = cam.visibleBounds;
    final z = cam.zoom;
    if (!_viewportChangedEnough(b, z)) return;

    _inFlight = true;
    setState(() {
      _loading = true;
      _error = null;
    });
    _lastB = b;
    _lastZ = z;
    final my = ++_seq;

    try {
      final raw = await _api
          .listByBbox(s: b.south, w: b.west, n: b.north, e: b.east, limit: 800)
          .timeout(const Duration(seconds: _timeoutSec));

      if (my != _seq) return;

      _vets.value = _sanitize(raw);
    } catch (e) {
      if (my != _seq) return;
      _error = '$e';
    } finally {
      if (mounted)
        setState(() {
          _loading = false;
        });
      _inFlight = false;
    }
  }

  void _twoStage({bool force = false}) {
    if (!_mapReady) return;

    final z = _map.camera.zoom;
    // 1) Siempre agregado primero (barato)
    if (force || z < _detailMinZoom) {
      _refineTimer?.cancel();
      _fetchAggregated();
      if (z >= _detailMinZoom) {
        _refineTimer = Timer(const Duration(milliseconds: 350), _fetchDetail);
      }
      return;
    }

    // 2) Con zoom alto: igual arrancamos con agregado (rápido),
    //    y refinamos a detalle si el usuario se detuvo.
    _refineTimer?.cancel();
    _fetchAggregated();
    _refineTimer = Timer(const Duration(milliseconds: 350), _fetchDetail);
  }

  // ======= Eventos =======
  void _onMapEvent(MapEvent e) {
    final ended =
        e is MapEventMoveEnd ||
        e is MapEventFlingAnimationEnd ||
        e is MapEventRotateEnd ||
        e is MapEventDoubleTapZoomEnd;
    if (ended) {
      _twoStage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final circleColor = Colors.black.withOpacity(0.85);

    return Column(
      children: [
        // Filtros (decorativos)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Wrap(
            spacing: 8,
            children: const [
              FilterChip(
                label: Text('Veterinarias'),
                selected: true,
                onSelected: null,
              ),
              FilterChip(
                label: Text('≤ 5 km'),
                selected: true,
                onSelected: null,
              ),
            ],
          ),
        ),

        if (_loading) const LinearProgressIndicator(minHeight: 2),

        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
            ),
          ),

        Expanded(
          // ⚠️ OJO: el FlutterMap ya no depende del ValueListenable.
          // Solo las LAYERS se reconstruyen con los datos.
          child: FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 12,
              onMapReady: () {
                _mapReady = true;
                _twoStage(force: true);
              },
              onMapEvent: _onMapEvent,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.buscadog.app',
                panBuffer: 0,
                keepBuffer: 1,
              ),

              // Solo las capas dependen de los datos
              ValueListenableBuilder<List<data.Vet>>(
                valueListenable: _vets,
                builder: (_, vets, __) {
                  final z = _map.camera.zoom;

                  // Regla de decisión: ¿detalle o agregado?
                  final canDetail =
                      z >= _detailMinZoom && vets.length <= _detailMaxPins;

                  if (!canDetail) {
                    // ====== Modo agregado (círculos muy baratos) ======
                    final circles = vets
                        .map(
                          (v) => CircleMarker(
                            point: LatLng(v.lat, v.lon),
                            useRadiusInMeter: false,
                            radius: () {
                              final t = (v.total ?? 1).toDouble();
                              return math.min(10.0, 3.0 + math.log(t + 1.0));
                            }(),
                            color: circleColor,
                            borderColor: Colors.white,
                            borderStrokeWidth: 0.8,
                          ),
                        )
                        .toList(growable: false);

                    return CircleLayer(circles: circles);
                  }

                  // ====== Modo detalle (markers) ======
                  final markers = vets
                      .map(
                        (v) => Marker(
                          point: LatLng(v.lat, v.lon),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.black87,
                          ),
                        ),
                      )
                      .toList(growable: false);

                  return MarkerLayer(markers: markers, rotate: false);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _refineTimer?.cancel();
    _vets.dispose();
    _api.dispose(); // cierra el http.Client
    super.dispose();
  }
}
