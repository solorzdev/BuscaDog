import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Quiénes somos',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        const Text(
          'Conectamos familias con su mascota mediante alertas, mapa en tiempo real y una comunidad de ayuda.',
        ),
        const SizedBox(height: 16),
        const ListTile(
          leading: Icon(Icons.flag_outlined),
          title: Text('Misión'),
          subtitle: Text('Acelerar el reencuentro de mascotas y familias.'),
        ),
        const ListTile(
          leading: Icon(Icons.visibility_outlined),
          title: Text('Visión'),
          subtitle: Text('La red de búsqueda de mascotas más efectiva.'),
        ),
      ],
    );
  }
}
