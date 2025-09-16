// lib/app_shell/app_shell.dart
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
  int _pageIndex = 0;
  late final PageController _pc = PageController(initialPage: _pageIndex);

  // Páginas
  final _pages = const [
    HomePage(), // 0
    ReunionsPage(), // 1
    FaqPage(), // 2
    MapPage(), // 3
    AboutPage(), // 4
    PricingPage(), // 5
    PetsPage(), // 6
    CasesPage(), // 7
    VetsPage(), // 8
    ProfilePage(), // 9
  ];

  // Mapeo TopNav (web) -> índices reales
  static const _topToPage = [0, 7, 3, 2, 4, 5];

  // Ítems del menú inferior (lineal, con píldora animada)
  static const List<_NavSpec> _bottomItems = [
    _NavSpec(icon: Icons.home_outlined, label: 'Inicio', targetIndex: 0),
    _NavSpec(icon: Icons.pets_outlined, label: 'Casos', targetIndex: 7),
    _NavSpec(icon: Icons.map_outlined, label: 'Mapa', targetIndex: 3),
    _NavSpec(icon: Icons.verified_outlined, label: 'Acerca', targetIndex: 4),
    _NavSpec(icon: Icons.person_outline, label: 'Perfil', targetIndex: 9),
  ];

  // Posición del seleccionado dentro de _bottomItems
  int get _bottomPos {
    final i = _bottomItems.indexWhere((e) => e.targetIndex == _pageIndex);
    return i == -1 ? 0 : i;
  }

  String get _title => switch (_pageIndex) {
    0 => 'Inicio',
    7 => 'Casos de mascotas',
    3 => 'Mapa',
    2 => 'Preguntas',
    4 => 'Quiénes somos',
    5 => 'Precios',
    6 => 'Mis Mascotas',
    8 => 'Veterinarias',
    _ => 'Perfil',
  };

  Future<void> _goToPage(int target) async {
    setState(() => _pageIndex = target);
    await _pc.animateToPage(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWideWeb = kIsWeb && width >= 900;

    // Índice actual para el TopNav
    final topIdx = () {
      final i = _topToPage.indexOf(_pageIndex);
      return i < 0 ? 0 : i;
    }();

    final appBar = isWideWeb
        ? TopNavBar(
            selectedIndex: topIdx,
            onSelect: (i) => _goToPage(_topToPage[i]),
            logoAsset: 'logo.png',
            showAuthActions: true,
            onLogin: () {},
            onRegister: () {},
          )
        : AppBar(title: Text(_title));

    return Scaffold(
      appBar: appBar,

      // Transición entre pantallas con swipe animado
      body: PageView(
        controller: _pc,
        onPageChanged: (i) => setState(() => _pageIndex = i),
        children: _pages,
        // physics: const NeverScrollableScrollPhysics(), // si quieres solo taps
      ),

      // Barra inferior tipo píldora animada
      bottomNavigationBar: isWideWeb
          ? null
          : AnimatedPillBottomBar(
              items: _bottomItems,
              currentPos: _bottomPos,
              onTap: (pos) => _goToPage(_bottomItems[pos].targetIndex),

              // Colores personalizables (ajusta a tu branding)
              backgroundColor: const Color(0xFFEAFBF1), // verde claro
              pillColor: const Color(0xFFDFF7EA), // píldora
              activeColor: const Color(0xFF32BAEA), // ítem activo (cyan)
              inactiveColor: Colors.black87, // ítems inactivos
            ),
    );
  }
}

// --------- Definición de ítems ---------
class _NavSpec {
  final IconData icon;
  final String label;
  final int targetIndex;
  const _NavSpec({
    required this.icon,
    required this.label,
    required this.targetIndex,
  });
}

// --------- Barra inferior con píldora deslizante ---------
class AnimatedPillBottomBar extends StatelessWidget {
  final List<_NavSpec> items;
  final int currentPos;
  final ValueChanged<int> onTap;

  final Color? backgroundColor;
  final Color? pillColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const AnimatedPillBottomBar({
    super.key,
    required this.items,
    required this.currentPos,
    required this.onTap,
    this.backgroundColor,
    this.pillColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bg = backgroundColor ?? cs.surfaceVariant.withOpacity(0.5);
    final pill = pillColor ?? cs.surfaceVariant.withOpacity(0.9);
    final active = activeColor ?? cs.primary;
    final inactive = inactiveColor ?? cs.onSurface.withOpacity(0.85);

    const double barHeight = 72;
    const double iconSize = 24;
    const double hPad = 14;
    const double vPad = 10;
    const double gap = 8;
    const double indicatorRadius = 24;

    // Calcula ancho del label activo para la píldora
    final TextStyle labelStyle = theme.textTheme.labelLarge!.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: active,
    );
    final label = items[currentPos].label;
    final tp = TextPainter(
      text: TextSpan(text: label, style: labelStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final double pillWidth = iconSize + gap + tp.width + (hPad * 2);
    final double pillHeight = iconSize + (vPad * 2);

    return Material(
      color: bg,
      elevation: 12,
      child: SizedBox(
        height: barHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final slot = totalWidth / items.length;
            final centerX = (currentPos * slot) + slot / 2;

            double clampLeft = (centerX - (pillWidth / 2)).clamp(
              8,
              totalWidth - pillWidth - 8,
            );

            // 🔧 Snap a la grilla física para evitar 0.15px de sobra
            final dpr = MediaQuery.of(context).devicePixelRatio;
            double snap(double v) => (v * dpr).round() / dpr;

            final left = snap(clampLeft);

            return Stack(
              alignment: Alignment.center,
              children: [
                // —— PÍLDORA DESLIZANTE DE FONDO ——
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  left: (centerX - (pillWidth / 2)).clamp(
                    8,
                    totalWidth - pillWidth - 8,
                  ),
                  top: (barHeight - pillHeight) / 2,
                  child: Container(
                    width: pillWidth,
                    height: pillHeight,
                    decoration: BoxDecoration(
                      color: pill,
                      borderRadius: BorderRadius.circular(indicatorRadius),
                    ),
                  ),
                ),

                // —— ÍTEMS EN LÍNEA ——
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (i) {
                    final selected = i == currentPos;

                    return InkWell(
                      onTap: () => onTap(i),
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SizedBox(
                        width: slot,
                        height: barHeight,
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            child: selected
                                ? Row(
                                    key: ValueKey('sel_$i'),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AnimatedScale(
                                        duration: const Duration(
                                          milliseconds: 140,
                                        ),
                                        curve: Curves.easeOut,
                                        scale: 1.08,
                                        child: Icon(
                                          items[i].icon,
                                          size: iconSize,
                                          color: active,
                                        ),
                                      ),
                                      const SizedBox(width: gap),
                                      Text(items[i].label, style: labelStyle),
                                    ],
                                  )
                                : Icon(
                                    key: ValueKey('icon_$i'),
                                    items[i].icon,
                                    size: iconSize,
                                    color: inactive,
                                  ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
