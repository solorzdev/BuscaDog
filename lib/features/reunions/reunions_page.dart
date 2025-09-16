import 'package:flutter/material.dart';

class ReunionsPage extends StatelessWidget {
  const ReunionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _ReunionCard(
          title: 'Luna volvió a casa 🎉',
          place: 'Guadalajara, Jal.',
          when: 'Hoy',
        ),
        _ReunionCard(
          title: 'Michi encontrado',
          place: 'Zapopan, Jal.',
          when: 'Ayer',
        ),
        _ReunionCard(
          title: 'Rocky reunido',
          place: 'Tlaquepaque, Jal.',
          when: 'Hace 3 días',
        ),
      ],
    );
  }
}

class _ReunionCard extends StatelessWidget {
  final String title, place, when;
  const _ReunionCard({
    required this.title,
    required this.place,
    required this.when,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.favorite)),
        title: Text(title),
        subtitle: Text('$place • $when'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
