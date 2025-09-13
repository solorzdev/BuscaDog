import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
        const SizedBox(height: 12),
        Text('Octa', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('Tema'),
          trailing: const Text('Claro'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Cerrar sesión'),
        ),
      ],
    );
  }
}
