import 'package:flutter/material.dart';

class CasesPage extends StatelessWidget {
  const CasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        _CaseCard(
          type: 'lost',
          title: 'Perdida: Luna',
          desc: 'Última vez vista en Av. Federalismo',
          when: 'Hace 2 h',
        ),
        _CaseCard(
          type: 'sighted',
          title: 'Avistamiento',
          desc: 'Perro café pequeño por Parque Rojo',
          when: 'Ayer',
        ),
        _CaseCard(
          type: 'reunited',
          title: 'Reencuentro',
          desc: 'Michi regresó a casa 🎉',
          when: 'Hoy',
        ),
      ],
    );
  }
}

class _CaseCard extends StatelessWidget {
  final String type, title, desc, when;
  const _CaseCard({
    required this.type,
    required this.title,
    required this.desc,
    required this.when,
  });

  Color _badgeColor(BuildContext c) => switch (type) {
    'lost' => Theme.of(c).colorScheme.error,
    'sighted' => Theme.of(c).colorScheme.secondary,
    _ => Theme.of(c).colorScheme.primary,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _badgeColor(context).withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type.toUpperCase(),
            style: TextStyle(
              color: _badgeColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text('$desc • $when'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
