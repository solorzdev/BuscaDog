import 'package:flutter/material.dart';
import '../features/map/map_page.dart';
import '../features/pets/pets_page.dart';
import '../features/cases/cases_page.dart';
import '../features/vets/vets_page.dart';
import '../features/profile/profile_page.dart';

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
    return LayoutBuilder(
      builder: (_, constraints) {
        final isWide = constraints.maxWidth >= 900;

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

        final navBar = NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: navDestinations,
        );

        final navRail = NavigationRail(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: Text('Mapa'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: Text('Mascotas'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.report_gmailerrorred_outlined),
              selectedIcon: Icon(Icons.report),
              label: Text('Casos'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.local_hospital_outlined),
              selectedIcon: Icon(Icons.local_hospital),
              label: Text('Vets'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: Text('Perfil'),
            ),
          ],
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(_title),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              const SizedBox(width: 8),
            ],
          ),
          body: Row(
            children: [
              if (isWide) SizedBox(width: 88, child: navRail),
              Expanded(
                child: IndexedStack(index: _index, children: _pages),
              ),
            ],
          ),
          bottomNavigationBar: isWide ? null : navBar,
          floatingActionButton: switch (_index) {
            0 => FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Reportar caso'),
            ),
            1 => FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Nueva mascota'),
            ),
            _ => null,
          },
        );
      },
    );
  }
}
