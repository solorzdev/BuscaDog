import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../features/map/map_page.dart';
import '../features/pets/pets_page.dart';
import '../features/cases/cases_page.dart';
import '../features/vets/vets_page.dart';
import '../features/profile/profile_page.dart';
import 'widgets/top_navbar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _pages = const [
    MapPage(),
    PetsPage(),
    CasesPage(),
    VetsPage(),
    ProfilePage(),
  ];

  String get _title => switch (_index) {
    0 => 'Mapa',
    1 => 'Mis Mascotas',
    2 => 'Casos',
    3 => 'Veterinarias',
    _ => 'Perfil',
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWideWeb = kIsWeb && width >= 900; // top navbar en web/escritorio

    final navDestinations = const [
      NavigationDestination(
        icon: Icon(Icons.map_outlined),
        selectedIcon: Icon(Icons.map),
        label: 'Mapa',
      ),
      NavigationDestination(
        icon: Icon(Icons.pets_outlined),
        selectedIcon: Icon(Icons.pets),
        label: 'Mascotas',
      ),
      NavigationDestination(
        icon: Icon(Icons.report_gmailerrorred_outlined),
        selectedIcon: Icon(Icons.report),
        label: 'Casos',
      ),
      NavigationDestination(
        icon: Icon(Icons.local_hospital_outlined),
        selectedIcon: Icon(Icons.local_hospital),
        label: 'Vets',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ];

    return Scaffold(
      // NAVBAR SUPERIOR (web/escritorio)
      appBar: isWideWeb
          ? TopNavBar(
              selectedIndex: _index,
              onSelect: (i) => setState(() => _index = i),
              logoAsset: 'assets/brand/logo.png', // <- tu logo
              showAuthActions: true,
              onLogin: () {
                /* TODO: navegación a login */
              },
              onRegister: () {
                /* TODO: navegación a registro */
              },
            )
          : AppBar(title: Text(_title)),

      // CUERPO
      body: IndexedStack(index: _index, children: _pages),

      // NAV INFERIOR (solo móvil)
      bottomNavigationBar: isWideWeb
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: navDestinations,
            ),
      floatingActionButton: _buildFabForIndex(_index, isWideWeb),
    );
  }

  Widget? _buildFabForIndex(int index, bool isWideWeb) {
    if (isWideWeb) return null; // FAB solo en móvil
    switch (index) {
      case 0:
        return FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add_location_alt),
          label: const Text('Reportar caso'),
        );
      case 1:
        return FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Nueva mascota'),
        );
      default:
        return null;
    }
  }
}
