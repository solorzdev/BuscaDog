import 'package:flutter/material.dart';
import '../../data/mock/places_mock.dart';

class VetsPage extends StatelessWidget {
  const VetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vets = mockPlaces.where((p) => p.kind == 'veterinary').toList();
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: vets.length,
      itemBuilder: (_, i) {
        final v = vets[i];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.local_hospital),
            title: Text(v.name),
            subtitle: Text(
              '(${v.lat.toStringAsFixed(3)}, ${v.lng.toStringAsFixed(3)})',
            ),
            trailing: FilledButton.tonal(
              onPressed: () {},
              child: const Text('Ver'),
            ),
          ),
        );
      },
    );
  }
}
