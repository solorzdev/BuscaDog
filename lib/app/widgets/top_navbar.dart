import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  // Ruta del asset del logo
  final String logoAsset;
  // Mostrar/ocultar CTAs (web)
  final bool showAuthActions;
  final VoidCallback? onLogin;
  final VoidCallback? onRegister;

  const TopNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    this.logoAsset = 'assets/brand/logo.png',
    this.showAuthActions = true,
    this.onLogin,
    this.onRegister,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF32BAEA); // cyan branding
    final items = const [
      (Icons.home_outlined, 'Inicio'),
      (Icons.info_outline, 'Quiénes somos'),
      (Icons.help_outline, 'Preguntas'),
      (Icons.map_outlined, 'Mapa'),
      (Icons.verified_outlined, 'Reuniones'),
      (Icons.attach_money_outlined, 'Precios'),
    ];

    return Material(
      color: bg,
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (_, c) {
            final w = c.maxWidth;
            final compact =
                w < 1100; // cuando el ancho es reducido, comprimimos labels

            return Container(
              height: preferredSize.height,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // LOGO (click => Inicio)
                  InkWell(
                    onTap: () => onSelect(0),
                    child: Row(
                      children: [
                        Image.asset(
                          'logo.png',
                          height: 36,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Text(
                            'BuscaDog',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),
                  // DIVISOR
                  Container(width: 1, height: 32, color: Colors.white24),

                  const SizedBox(width: 12),

                  // ITEMS CENTRALES
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < items.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: TextButton.icon(
                                onPressed: () => onSelect(i),
                                icon: Icon(
                                  items[i].$1,
                                  size: 20,
                                  color: selectedIndex == i
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                                label: Text(
                                  items[i].$2,
                                  style: TextStyle(
                                    color: selectedIndex == i
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: selectedIndex == i
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  shape: const StadiumBorder(),
                                  backgroundColor: selectedIndex == i
                                      ? Colors.white.withOpacity(.18)
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // CTAs DERECHA (solo web/escritorio)
                  if (kIsWeb && showAuthActions) ...[
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: onLogin,
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text(
                        'Log in',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white54),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: onRegister,
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Register'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFBB03B), // ámbar btn
                        foregroundColor: Colors.black87,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        elevation: 1,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
