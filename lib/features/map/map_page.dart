import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/mock/places_mock.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    const center = LatLng(20.6736, -103.3440); // GDL
    final markers = mockPlaces.map((p) {
      return Marker(
        point: LatLng(p.lat, p.lng),
        width: 44,
        height: 44,
        child: Tooltip(
          message: p.name,
          child: const Icon(Icons.location_on, size: 36),
        ),
      );
    }).toList();

    return Column(
      children: [
        // Filtros compactos
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
                label: Text('Hoteles'),
                selected: false,
                onSelected: null,
              ),
              FilterChip(
                label: Text('Restaurantes'),
                selected: false,
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
        Expanded(
          child: FlutterMap(
            options: const MapOptions(initialCenter: center, initialZoom: 12),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.buscadog.app',
              ),
              MarkerLayer(markers: markers),
            ],
          ),
        ),
      ],
    );
  }
}
