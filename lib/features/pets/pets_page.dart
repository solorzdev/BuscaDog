import 'package:flutter/material.dart';

class PetsPage extends StatelessWidget {
  const PetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.pets)),
            title: const Text('Luna'),
            subtitle: const Text('Perro • Hem hem • Vacunas al día'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.pets)),
            title: const Text('Michi'),
            subtitle: const Text('Gato • Esterilizado'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ),
      ],
    );
  }
}
