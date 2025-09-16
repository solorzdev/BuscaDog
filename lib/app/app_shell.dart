import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/home/home_page.dart';
import '../features/about/about_page.dart';
import '../features/faq/faq_page.dart';
import '../features/map/map_page.dart';
import '../features/reunions/reunions_page.dart';
import '../features/pricing/pricing_page.dart';

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

  // Importante: los primeros 6 índices coinciden con el TopNav (web)
  final _pages = const [
    HomePage(), // 0 Inicio
    ReunionsPage(),
    // AboutPage(), // 1 Quiénes somos
    FaqPage(), // 2 Preguntas
    MapPage(), // 3 Mapa
    AboutPage(),
    // ReunionsPage(), // 4 Reuniones
    PricingPage(), // 5 Precios
    // El resto son secciones para móvil (BottomNav)
    PetsPage(), // 6 Mascotas
    CasesPage(), // 7 Casos
    VetsPage(), // 8 Veterinarias
    ProfilePage(), // 9 Perfil
  ];

  String get _title => switch (_index) {
    0 => 'Inicio',
    1 => 'Casos de macotas',
    2 => 'Preguntas',
    3 => 'Mapa',
    4 => 'Quiénes somos',
    5 => 'Precios',
    6 => 'Mis Mascotas',
    7 => 'Casos',
    8 => 'Veterinarias',
    _ => 'Perfil',
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWideWeb = kIsWeb && width >= 900;

    // ------- Top Nav (web/escritorio) -------
    final appBar = isWideWeb
        ? TopNavBar(
            selectedIndex: _index.clamp(0, 5), // solo resalta 0..5
            onSelect: (i) => setState(() => _index = i), // i ya coincide
            logoAsset: 'logo.png',
            showAuthActions: true,
            onLogin: () {},
            onRegister: () {},
          )
        : AppBar(title: Text(_title));

    // ------- Bottom Nav (móvil) -------
    // Mostramos: Inicio, Mapa, Mascotas, Casos, Perfil
    final mobileMap = [0, 3, 6, 7, 9]; // índices en _pages
    final selectedMobile = mobileMap.indexOf(_index);
    final bottomNav = isWideWeb
        ? null
        : NavigationBar(
            selectedIndex: selectedMobile == -1 ? 0 : selectedMobile,
            onDestinationSelected: (i) => setState(() => _index = mobileMap[i]),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                label: 'Mapa',
              ),
              NavigationDestination(
                icon: Icon(Icons.pets_outlined),
                label: 'Mascotas',
              ),
              NavigationDestination(
                icon: Icon(Icons.report_gmailerrorred_outlined),
                label: 'Casos de mascotas',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Perfil',
              ),
            ],
          );

    return Scaffold(
      appBar: appBar,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: bottomNav,
      floatingActionButton: _buildFabForIndex(_index, isWideWeb),
    );
  }

  Widget? _buildFabForIndex(int index, bool isWideWeb) {
    if (isWideWeb) return null; // FAB solo en móvil
    switch (index) {
      case 3: // Mapa
        return FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add_location_alt),
          label: const Text('Reportar caso'),
        );
      case 6: // Mascotas
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
